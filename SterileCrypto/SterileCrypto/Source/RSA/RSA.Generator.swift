import Foundation
import BigInt

extension RSA {
	class Generator { }
}



extension RSA.Generator {
	enum Error: Swift.Error, CustomDebugStringConvertible {
		case keySizeIsSmallerThanMinimalSize(keySize: UInt)
		case publicExponentHasNotInverseValueWithPhi(e: Data, phi: Data)
		
		var debugDescription: String {
			let debugDescription: String
			
			switch self {
			case .keySizeIsSmallerThanMinimalSize(let keySize):
				debugDescription = "Key size is smaller than minimal size: \(keySize)"
			case .publicExponentHasNotInverseValueWithPhi(let e, let phi):
				debugDescription = "Public exponent has not inverse value with phi: \(e) – \(phi)"
			}
			
			return debugDescription
		}
	}
}



private extension RSA.Generator {
	struct Constants {
		static let minimalKeySize: UInt = 10
	}
}



extension RSA.Generator {
	func generateKeyPair (size keySize: UInt) throws -> RSA.KeyPair {
		guard keySize > RSA.Generator.Constants.minimalKeySize else { throw Error.keySizeIsSmallerThanMinimalSize(keySize: keySize) }
		let pqSize = keySize / 2
		
		let p = try generateP(pqSize)
		let q = try generateQ(pqSize, keySize, p)
		let phi = calculatePhi(p, q)
		let (e, d) = try generateExponents(phi)
		
		let privateKey = RSA.PrivateKey(p: p, q: q, e: e, d: d)
		let keyPair = RSA.KeyPair(privateKey: privateKey)
		
		return keyPair
	}
}



private extension RSA.Generator {
	func generateP (_ pqSize: UInt) throws -> BigUInt {
		let p = try Math.generatePrimeNumber(size: pqSize)
		return p
	}
	
	func generateQ (_ pqSize: UInt, _ keySize: UInt, _ p: BigUInt) throws -> BigUInt {
		while true {
			let q = try Math.generatePrimeNumber(size: pqSize)
			let n = p * q
			
			if q != p && n.bitWidth == keySize {
				return q
			}
		}
	}
	
	func calculatePhi (_ p: BigUInt, _ q: BigUInt) -> BigUInt {
		let phi = (p - 1) * (q - 1)
		return phi
	}
	
	func generateExponents (_ phi: BigUInt) throws -> (e: BigUInt, d: BigUInt) {
		while true {
			do {
				let e = try generateE(phi)
				let d = try calculateD(e, phi)
				
				return (e, d)
			}
			catch Error.publicExponentHasNotInverseValueWithPhi { }
			catch {
				throw error
			}
		}
	}
	
	func generateE (_ phi: BigUInt) throws -> BigUInt {
		while true {
			let e = BigUInt.randomInteger(lessThan: phi)
			if Math.isCoprime(e, phi) {
				return e
			}
		}
	}
	
	func calculateD (_ e: BigUInt, _ phi: BigUInt) throws -> BigUInt {
		guard let d = e.inverse(phi) else { throw Error.publicExponentHasNotInverseValueWithPhi(e: e.serialize(), phi: phi.serialize()) }
		return d
	}
}

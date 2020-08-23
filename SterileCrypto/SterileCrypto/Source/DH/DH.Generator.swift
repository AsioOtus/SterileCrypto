import BigInt



extension DH {
	public class Generator { }
}



public extension DH.Generator {
	func generateValues (privateKeySize: UInt, parametersSize: UInt) throws -> (DH.PrivateKey, DH.Parameters) {
		let privateKey = try generatePrivateKey(size: privateKeySize)
		let parameters = try generateParameters(size: parametersSize)
		
		return (privateKey, parameters)
	}
}



public extension DH.Generator {
	func generatePrivateKey (size: UInt) throws -> DH.PrivateKey {
		let value = try Math.generatePrimeNumber(size: size)
		
		let privateKey = DH.PrivateKey(value)
		return privateKey
	}
}



public extension DH.Generator {
	func generateParameters (size: UInt) throws -> DH.Parameters {
		let m = try Math.generatePrimeNumber(size: size)
		let g = try generatePrimeRoot(modulus: m, size: size)
		
		let parameters = DH.Parameters(g: g, m: m)
		return parameters
	}
	
	private func generatePrimeRoot (modulus: BigUInt, size: UInt) throws -> BigUInt {
		while true {
			let g = try Math.generatePrimeNumber(size: size)
			
			guard Math.isPrimitiveRoot(g, of: modulus) else { return g }
		}
	}
}

import Foundation
import BigInt

extension RSA {
	class Verifier { }
}



extension RSA.Verifier {
	func verify (message: String, signature: Data, publicKey: RSA.PublicKey) -> Bool {
		let messageData = message.data(using: .utf8)!
		let isVerified = verify(data: messageData, signature: signature, publicKey: publicKey)
		return isVerified
	}
	
	func verify (data: Data, signature: Data, publicKey: RSA.PublicKey) -> Bool {
		let signatureDataHash = verify(signature, publicKey)
		let dataHash = data.sha256
		
		let isVerified = signatureDataHash == dataHash
		return isVerified
	}
	
	private func verify (_ signature: Data, _ publicKey: RSA.PublicKey) -> Data {
		let dataHashNumber = BigUInt(signature).power(publicKey.e, modulus: publicKey.n)
		let dataHash = dataHashNumber.serialize()
		return dataHash
	}
}

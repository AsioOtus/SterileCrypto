import Foundation
import BigInt



extension RSA {
	public class Signer {	}
}



public extension RSA.Signer {
	func sign (message: String, privateKey: RSA.PrivateKey) -> Data {
		let messageData = message.data(using: .utf8)!
		let signatureData = sign(data: messageData, privateKey: privateKey)
		return signatureData
	}
	
	func sign (data: Data, privateKey: RSA.PrivateKey) -> Data {
		let dataHash = data.sha256
		let signatureData = sign(dataHash, privateKey)
		return signatureData
	}
	
	private func sign (_ dataHash: Data, _ privateKey: RSA.PrivateKey) -> Data {
		let signatureNumber = BigUInt(dataHash).power(privateKey.d, modulus: privateKey.n)
		let signatureData = signatureNumber.serialize()
		return signatureData
	}
}

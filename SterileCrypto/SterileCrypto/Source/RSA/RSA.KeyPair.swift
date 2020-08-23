import BigInt

extension RSA {
	struct KeyPair {
		let privateKey: RSA.PrivateKey
		
		var publicKey: RSA.PublicKey {
			return self.privateKey.publicKey
		}
		
		var keys: (RSA.PrivateKey, RSA.PublicKey) {
			return (self.privateKey, self.publicKey)
		}
		
		var size: UInt {
			return self.privateKey.size
		}
		
		init (privateKey: RSA.PrivateKey) {
			self.privateKey = privateKey
		}
	}
}

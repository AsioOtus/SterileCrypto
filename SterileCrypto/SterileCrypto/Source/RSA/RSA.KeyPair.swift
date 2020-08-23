import BigInt



extension RSA {
	public struct KeyPair {
		public let privateKey: RSA.PrivateKey
		
		public var publicKey: RSA.PublicKey {
			return self.privateKey.publicKey
		}
		
		public var keys: (RSA.PrivateKey, RSA.PublicKey) {
			return (self.privateKey, self.publicKey)
		}
		
		public var size: UInt {
			return self.privateKey.size
		}
		
		public init (privateKey: RSA.PrivateKey) {
			self.privateKey = privateKey
		}
	}
}

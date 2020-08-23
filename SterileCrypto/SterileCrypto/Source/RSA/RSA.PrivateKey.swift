import BigInt

extension RSA {
	public class PrivateKey {
		public let p: BigUInt
		public let q: BigUInt
		public let n: BigUInt
		public let e: BigUInt
		public let d: BigUInt
		
		public let size: UInt
				
		public let publicKey: RSA.PublicKey
		
		public init (p: BigUInt, q: BigUInt, e: BigUInt, d: BigUInt) {
			self.p = p
			self.q = q
			self.e = e
			self.d = d
			self.n = p * q
						
			self.size = UInt(self.p.bitWidth)
			
			self.publicKey = RSA.PublicKey(n: n, e: self.e)
		}
	}
}



extension RSA.PrivateKey: CustomStringConvertible {
	public var description: String {
		let description =
		"""
		RSA key pair
		p: \(p)
		q: \(q)
		n: \(n)
		e: \(e)
		d: \(d)
		size: \(size)
		"""
		
		return description
	}
}

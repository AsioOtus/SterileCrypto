import BigInt

extension RSA {
	public class PublicKey {
		public let n: BigUInt
		public let e: BigUInt
		
		public let size: UInt
		
		public init (n: BigUInt, e: BigUInt) {
			self.n = n
			self.e = e
			
			self.size = UInt(self.n.bitWidth)
		}
	}
}



extension RSA.PublicKey: CustomStringConvertible {
	public var description: String {
		let description =
		"""
		RSA public key
		n: \(n)
		e: \(e)
		size: \(size)
		"""
		
		return description
	}
}

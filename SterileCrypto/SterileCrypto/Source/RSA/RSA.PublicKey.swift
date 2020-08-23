import BigInt

extension RSA {
	class PublicKey {
		let n: BigUInt
		let e: BigUInt
		
		let size: UInt
		
		init (n: BigUInt, e: BigUInt) {
			self.n = n
			self.e = e
			
			self.size = UInt(self.n.bitWidth)
		}
	}
}



extension RSA.PublicKey: CustomStringConvertible {
	var description: String {
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

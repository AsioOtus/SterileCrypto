import BigInt

extension RSA {
	class PrivateKey {
		let p: BigUInt
		let q: BigUInt
		let n: BigUInt
		let e: BigUInt
		let d: BigUInt
		
		let size: UInt
				
		let publicKey: RSA.PublicKey
		
		init (p: BigUInt, q: BigUInt, e: BigUInt, d: BigUInt) {
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
	var description: String {
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

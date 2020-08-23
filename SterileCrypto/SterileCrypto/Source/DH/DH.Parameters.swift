import BigInt

extension DH {
	class Parameters {
		let g: BigUInt
		let m: BigUInt
		
		init (g: BigUInt, m: BigUInt) {
			self.g = g
			self.m = m
		}
	}
}

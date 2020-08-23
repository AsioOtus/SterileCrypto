import BigInt



extension DH {
	public class Parameters {
		public let g: BigUInt
		public let m: BigUInt
		
		public init (g: BigUInt, m: BigUInt) {
			self.g = g
			self.m = m
		}
	}
}

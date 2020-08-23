import BigInt



extension DH {
	public class SharedKey {
		public let value: BigUInt
		
		public init (_ value: BigUInt) {
			self.value = value
		}
	}
}

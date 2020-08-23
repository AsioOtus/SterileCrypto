import BigInt



extension DH {
	public class PublicKey {
		public let value: BigUInt
		
		public let size: UInt
		
		public init (_ value: BigUInt) {
			self.value = value
			
			self.size = UInt(self.value.bitWidth)
		}
	}
}

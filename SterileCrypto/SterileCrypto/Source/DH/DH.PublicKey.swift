import BigInt

extension DH {
	class PublicKey {
		let value: BigUInt
		
		let size: UInt
		
		init (_ value: BigUInt) {
			self.value = value
			
			self.size = UInt(self.value.bitWidth)
		}
	}
}

import BigInt

extension DH {
	class SharedKey {
		let value: BigUInt
		
		init (_ value: BigUInt) {
			self.value = value
		}
	}
}

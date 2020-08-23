extension DH {
	class RespondingPartialKey {
		let publicKey: DH.PublicKey
		
		init (publicKey: DH.PublicKey) {
			self.publicKey = publicKey
		}
	}
}

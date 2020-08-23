extension DH {
	class RequestingPartialKey {
		let publicKey: DH.PublicKey
		let parameters: DH.Parameters
		
		init (publicKey: DH.PublicKey, parameters: DH.Parameters) {
			self.publicKey = publicKey
			self.parameters = parameters
		}
	}
}

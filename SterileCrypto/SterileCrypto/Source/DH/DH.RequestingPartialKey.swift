extension DH {
	public class RequestingPartialKey {
		public let publicKey: DH.PublicKey
		public let parameters: DH.Parameters
		
		public init (publicKey: DH.PublicKey, parameters: DH.Parameters) {
			self.publicKey = publicKey
			self.parameters = parameters
		}
	}
}

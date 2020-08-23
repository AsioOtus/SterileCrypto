extension DH {
	public class RespondingPartialKey {
		public let publicKey: DH.PublicKey
		
		public init (publicKey: DH.PublicKey) {
			self.publicKey = publicKey
		}
	}
}

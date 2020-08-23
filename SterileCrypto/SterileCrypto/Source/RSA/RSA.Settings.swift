extension RSA {
	public struct Settings {
		public struct Cryption {
			public let blockSize: Int
			public let entanglementUsing: Bool
			public let paddingByte: UInt8
			public let paddingEdge: Edge
		}
	}
}

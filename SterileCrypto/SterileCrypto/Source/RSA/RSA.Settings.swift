extension RSA {
	struct Settings {
		struct Cryption {
			let blockSize: Int
			let entanglementUsing: Bool
			let paddingByte: UInt8
			let paddingEdge: Edge
		}
	}
}

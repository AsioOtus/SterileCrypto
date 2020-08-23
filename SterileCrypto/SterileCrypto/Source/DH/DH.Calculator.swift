import BigInt

extension DH {
	class Calculator {	}
}



extension DH.Calculator {
	static func calculatePartialKey (privateKey: DH.PrivateKey, parameters: DH.Parameters) -> DH.PartialKey {
		let publicKey = calculatePublicKey(privateKey: privateKey, parameters: parameters)
		let partialKey = DH.PartialKey(publicKey: publicKey, parameters: parameters)
		return partialKey
	}
	
	static func calculatePartialKey (privateKey: DH.PrivateKey, partialKey: DH.PartialKey) -> DH.PartialKey {
		let publicKey = calculatePublicKey(privateKey: privateKey, parameters: partialKey.parameters)
		let partialKey = DH.PartialKey(publicKey: publicKey, parameters: partialKey.parameters)
		return partialKey
	}
}



extension DH.Calculator {
	static func calculateRequestingPartialKey (privateKey: DH.PrivateKey, parameters: DH.Parameters) -> DH.RequestingPartialKey {
		let publicKey = calculatePublicKey(privateKey: privateKey, parameters: parameters)
		let partialKey = DH.RequestingPartialKey(publicKey: publicKey, parameters: parameters)
		return partialKey
	}
	
	static func calculateRespondingPartialKey (privateKey: DH.PrivateKey, partialKey: DH.RequestingPartialKey) -> DH.RespondingPartialKey {
		let publicKey = calculatePublicKey(privateKey: privateKey, parameters: partialKey.parameters)
		let partialKey = DH.RespondingPartialKey(publicKey: publicKey)
		return partialKey
	}
}



extension DH.Calculator {
	static func calculatePublicKey (privateKey: DH.PrivateKey, parameters: DH.Parameters) -> DH.PublicKey {
		let value = privateKey.value.power(parameters.g, modulus: parameters.m)
		let publicKey = DH.PublicKey(value)
		return publicKey
	}
}



extension DH.Calculator {
	static func calculateSharedKey (privateKey: DH.PrivateKey, requestingPartialKey: DH.RequestingPartialKey) -> DH.SharedKey {
		let sharedKey = calculateSharedKey(privateKey: privateKey, publicKey: requestingPartialKey.publicKey, parameters: requestingPartialKey.parameters)
		return sharedKey
	}
}



extension DH.Calculator {
	static func calculateSharedKey (privateKey: DH.PrivateKey, partialKey: DH.PartialKey) -> DH.SharedKey {
		let sharedKey = calculateSharedKey(privateKey: privateKey, publicKey: partialKey.publicKey, parameters: partialKey.parameters)
		return sharedKey
	}
	
	static func calculateSharedKey (privateKey: DH.PrivateKey, publicKey: DH.PublicKey, parameters: DH.Parameters) -> DH.SharedKey {
		let value = publicKey.value.power(privateKey.value, modulus: parameters.m)
		let sharedKey = DH.SharedKey(value)
		return sharedKey
	}
}

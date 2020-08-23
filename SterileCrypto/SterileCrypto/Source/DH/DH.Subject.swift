extension DH {
	class Subject {
		private let generator = DH.Generator()
		
		private(set) var privateKey: DH.PrivateKey
		private(set) var parameters: DH.Parameters
		private(set) var sharedKey: DH.SharedKey? = nil
		
		var partialKey: DH.PartialKey {
			let partialKey = DH.Calculator.calculatePartialKey(privateKey: privateKey, parameters: parameters)
			return partialKey
		}
		
		var requestingPartialKey: DH.RequestingPartialKey {
			let requestingPartialKey = DH.Calculator.calculateRequestingPartialKey(privateKey: privateKey, parameters: parameters)
			return requestingPartialKey
		}
		
		init (keySize: UInt) throws {
			(privateKey, parameters) = try generator.generateValues(privateKeySize: keySize, parametersSize: keySize)
		}
	}
}



extension DH.Subject {
	func regeneratePrivateKey (size: UInt) throws {
		privateKey = try generator.generatePrivateKey(size: size)
	}
	
	func regenerateParameters (size: UInt) throws {
		parameters = try generator.generateParameters(size: size)
	}
}



extension DH.Subject {
	func createSharedKey (with anotherSubject: DH.Subject) {
		let respondingPartialKey = anotherSubject.createPartialKey(with: partialKey)
		createSharedKey(respondingPartialKey: respondingPartialKey)
	}
	
	func createPartialKey (with requestPartialKey: DH.PartialKey) -> DH.PartialKey {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, publicKey: requestPartialKey.publicKey, parameters: requestPartialKey.parameters)
		let respondingPartialKey = DH.Calculator.calculatePartialKey(privateKey: privateKey, partialKey: requestPartialKey)
		return respondingPartialKey
	}
	
	func createSharedKey (respondingPartialKey: DH.PartialKey) {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, publicKey: respondingPartialKey.publicKey, parameters: parameters)
	}
}



extension DH.Subject {
	func createSharedKey2 (with anotherSubject: DH.Subject) {
		let respondingPartialKey = anotherSubject.createPartialKey(with: requestingPartialKey)
		createSharedKey(respondingPartialKey: respondingPartialKey)
	}
	
	func createPartialKey (with requestingPartialKey: DH.RequestingPartialKey) -> DH.RespondingPartialKey {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, requestingPartialKey: requestingPartialKey)
		let respondingPartialKey = DH.Calculator.calculateRespondingPartialKey(privateKey: privateKey, partialKey: requestingPartialKey)
		return respondingPartialKey
	}
	
	func createSharedKey (respondingPartialKey: DH.RespondingPartialKey) {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, publicKey: respondingPartialKey.publicKey, parameters: parameters)
	}
}

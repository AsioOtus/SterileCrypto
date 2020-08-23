extension DH {
	public class Subject {
		private let generator = DH.Generator()
		
		public private(set) var privateKey: DH.PrivateKey
		public private(set) var parameters: DH.Parameters
		public private(set) var sharedKey: DH.SharedKey? = nil
		
		public var partialKey: DH.PartialKey {
			let partialKey = DH.Calculator.calculatePartialKey(privateKey: privateKey, parameters: parameters)
			return partialKey
		}
		
		public var requestingPartialKey: DH.RequestingPartialKey {
			let requestingPartialKey = DH.Calculator.calculateRequestingPartialKey(privateKey: privateKey, parameters: parameters)
			return requestingPartialKey
		}
		
		public init (keySize: UInt) throws {
			(privateKey, parameters) = try generator.generateValues(privateKeySize: keySize, parametersSize: keySize)
		}
	}
}



public extension DH.Subject {
	func regeneratePrivateKey (size: UInt) throws {
		privateKey = try generator.generatePrivateKey(size: size)
	}
	
	func regenerateParameters (size: UInt) throws {
		parameters = try generator.generateParameters(size: size)
	}
}



public extension DH.Subject {
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



public extension DH.Subject {
	func createSeparatedSharedKey (with anotherSubject: DH.Subject) {
		let respondingPartialKey = anotherSubject.createSeparatedPartialKey(with: requestingPartialKey)
		createSeparatedSharedKey(respondingPartialKey: respondingPartialKey)
	}
	
	func createSeparatedPartialKey (with requestingPartialKey: DH.RequestingPartialKey) -> DH.RespondingPartialKey {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, requestingPartialKey: requestingPartialKey)
		let respondingPartialKey = DH.Calculator.calculateRespondingPartialKey(privateKey: privateKey, partialKey: requestingPartialKey)
		return respondingPartialKey
	}
	
	func createSeparatedSharedKey (respondingPartialKey: DH.RespondingPartialKey) {
		sharedKey = DH.Calculator.calculateSharedKey(privateKey: privateKey, publicKey: respondingPartialKey.publicKey, parameters: parameters)
	}
}

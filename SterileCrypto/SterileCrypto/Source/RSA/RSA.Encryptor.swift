import Foundation
import BigInt



public extension RSA.Encryptor {
	static let defaultSettings = RSA.Settings.Cryption(blockSize: 4, entanglementUsing: true, paddingByte: 0xff, paddingEdge: .start)
	static var settings = defaultSettings
}



extension RSA {
	public class Encryptor {
		public let settings: RSA.Settings.Cryption
		
		public init (settings: RSA.Settings.Cryption) {
			self.settings = settings
		}
		
		public convenience init () {
			self.init(settings: Encryptor.defaultSettings)
		}
	}
}



extension RSA.Encryptor {
	public enum Error: Swift.Error, CustomDebugStringConvertible {
		case blockSizeIsBiggerThanModule(blockSize: Int, moduleSize: Int)
		
		public var debugDescription: String {
			let debugDescription: String
			
			switch self {
			case .blockSizeIsBiggerThanModule(let blockSize, let moduleSize):
				debugDescription = "Block size is bigger than module: \(blockSize) – \(moduleSize)"
			}
			
			return debugDescription
		}
	}
}



public extension RSA.Encryptor {
	func encrypt (message: String, publicKey: RSA.PublicKey) throws -> Data {
		let messageData = message.data(using: .utf8)!
		let encryptedMessageData = try encrypt(data: messageData, publicKey: publicKey)
		return encryptedMessageData
	}
	
	private func encrypt (data: Data, publicKey: RSA.PublicKey) throws -> Data {
		guard settings.blockSize < publicKey.n.bitWidth else { throw Error.blockSizeIsBiggerThanModule(blockSize: settings.blockSize, moduleSize: publicKey.n.bitWidth) }
		
		let data = addPkcs15Padding(data)
		var blocks = data.split(blockSize: settings.blockSize)
		
		if settings.entanglementUsing {
			blocks = entangle(blocks, publicKey.n)
		}
		
		blocks = blocks.map{ encrypt(block: $0, publicKey: publicKey) }
		let encryptedData = Data(blocks.joined())
		return encryptedData
	}
	
	private func encrypt (block: Data, publicKey: RSA.PublicKey) -> Data {
		let encryptedBlock = BigUInt(block).power(publicKey.e, modulus: publicKey.n)
		let encryptedData = encryptedBlock.serialize()
		return encryptedData
	}
}



public extension RSA.Encryptor {
	func entangle (_ blocks: [Data], _ module: BigUInt) -> [Data] {
		var entangledBlocks = [Data]()
		
		for (i, block) in blocks.enumerated() {
			let entangledNumber = i == 0 ? BigUInt(block) : (BigUInt(block) + BigUInt(entangledBlocks[i - 1])) % module
			
			let entangledBlock = entangledNumber.serialize()
			entangledBlocks.append(entangledBlock)
		}
		
		return entangledBlocks
	}
	
	func addPkcs15Padding (_ data: Data) -> Data {
		let controlBytesCount = 3
		
		let blocksCount = Double(data.count + controlBytesCount) / Double(settings.blockSize)
		let totalDataSize = Int(blocksCount.rounded(.up)) * settings.blockSize
		let plainPaddingBytesCount = totalDataSize - data.count - controlBytesCount
		let plainPaddingBytes = Data(Array(repeating: 0xff, count: plainPaddingBytesCount))
		let paddingBytes = Data([0x00, 0x01] + plainPaddingBytes + [0x00])
		let paddedData = paddingBytes + data
		
		return paddedData
	}
}

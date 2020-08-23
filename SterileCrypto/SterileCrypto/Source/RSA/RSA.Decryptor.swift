import Foundation
import BigInt

extension RSA {
	class Decryptor {
		static let defaultSettings = RSA.Settings.Cryption(blockSize: 4, entanglementUsing: true, paddingByte: 0xff, paddingEdge: .start)
		static var settings = defaultSettings
		
		let settings: RSA.Settings.Cryption
		
		init (settings: RSA.Settings.Cryption) {
			self.settings = settings
		}
		
		convenience init () {
			self.init(settings: Decryptor.defaultSettings)
		}
	}
}



extension RSA.Decryptor {
	enum Error: Swift.Error, CustomDebugStringConvertible {
		case pkcs15ControlStartBytesNotFound(firstFourBytes: Data)
		case pkcs15ControlEndByteNotFound
		
		var debugDescription: String {
			let debugDescription: String
			
			switch self {
			case .pkcs15ControlStartBytesNotFound(let firstFourBytes):
				debugDescription = "PKCS #15 control start bytes not found: \(firstFourBytes.hex)"
			case .pkcs15ControlEndByteNotFound:
				debugDescription = "PKCS #15 control end bytes not found"
			}
			
			return debugDescription
		}
	}
}



extension RSA.Decryptor {
	func decrypt (messageData: Data, privateKey: RSA.PrivateKey) throws -> String? {
		let decryptedData = try decrypt(data: messageData, privateKey: privateKey)
		return String(data: decryptedData, encoding: .utf8)
	}
	
	func decrypt (data: Data, privateKey: RSA.PrivateKey) throws -> Data {
		let magicNumber = 4
		let encryptedBlockSize = Int(privateKey.size) / magicNumber
				
		var blocks = data.split(blockSize: encryptedBlockSize)
		blocks = blocks.map{ decrypt(block: $0, privateKey: privateKey) }
		
		if settings.entanglementUsing {
			blocks = untangle(blocks, privateKey.n)
		}
		
		var data = Data(blocks.joined())
		data = try removePkcs15Padding(data)
		
		return data
	}
	
	private func decrypt (block: Data, privateKey: RSA.PrivateKey) -> Data {
		let decryptedBlock = BigUInt(block).power(privateKey.d, modulus: privateKey.n)
		let decryptedBlockAsData = decryptedBlock.serialize()
		return decryptedBlockAsData
	}
}



extension RSA.Decryptor {
	func untangle (_ blocks: [Data], _ module: BigUInt) -> [Data] {
		let module = BigInt(module)
		
		var untangledBlocks = [Data]()
		
		for (i, block) in blocks.enumerated() {
			let untangledNumber = i == 0 ? BigInt(BigUInt(block)) : (BigInt(BigUInt(block)) - BigInt(BigUInt(blocks[i - 1]))) % module
			
			let untangledBlock = untangledNumber.magnitude.serialize().pad(to: settings.blockSize, with: 0x00, at: .start)
			untangledBlocks.append(untangledBlock)
		}
		
		return untangledBlocks
	}
	
	func removePkcs15Padding (_ data: Data) throws -> Data {
		let startControlBytes = Data([0x00, 0x01])
		
		guard data.starts(with: startControlBytes)
			else { throw Error.pkcs15ControlStartBytesNotFound(firstFourBytes: data[safe: ..<4]) }
		
		let data = data[(startControlBytes.count)...]
		guard let indexOfMessageStart = data.firstIndex(of: 0x00)
			else { throw Error.pkcs15ControlEndByteNotFound }
		
		guard indexOfMessageStart < data.endIndex else { return Data() }
		
		let unpaddedData = data[data.index(after: indexOfMessageStart)...]
		return unpaddedData
	}
}

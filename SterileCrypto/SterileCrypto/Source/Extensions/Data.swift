import Foundation

extension Data {
	init <T> (_ value: T) {
		var value = value
		self = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
	}
	
	func `as` <T> (_ type: T.Type) -> T {
		let value = self.withUnsafeBytes {
			$0.load(as: type.self)
		}
		
		return value
	}
}





public extension FixedWidthInteger {
	var data: Data {
		var value = self
		let count = MemoryLayout<Self>.size
		let data = Data(bytes: &value, count: count)
		return data
	}
	
	init (_ data: Data) {
		self = data.withUnsafeBytes {
			$0.load(as: Self.self)
		}
	}
}



extension String {
	func padded (atStartTo length: Int, with character: Character = " ") -> String {
		let paddedString = createPaddingString(length, character) + self
		return paddedString
	}
	
	func padded (atEndTo length: Int, with character: Character = " ") -> String {
		let paddedString = self + createPaddingString(length, character)
		return paddedString
	}
	
	private func createPaddingString (_ length: Int, _ character: Character) -> String {
		let paddingStringLength = length - count
		return paddingStringLength > 0 ? String(repeating: character, count: paddingStringLength) : ""
	}
}



extension Data {
	var hex: String {
		return map { String($0, radix: 16).padded(atStartTo: 2, with: "0") }.joined(separator: " ")
	}
	
	var bin: String {
		return map { String($0, radix: 2).padded(atStartTo: 8, with: "0") }.joined(separator: " ")
	}
}



extension Data {
	func split (blockSize: Int) -> [Data] {
		var resultChunks = [Data]()
		
		var startIndex = 0
		var endIndex = blockSize
		
		while endIndex <= count {
			let chunk = Data(self[startIndex..<endIndex])
			resultChunks.append(chunk)
			
			startIndex += blockSize
			endIndex += blockSize
		}
		
		if startIndex < count {
			resultChunks.append(Data(self[startIndex...]))
		}
		
		return resultChunks
	}
	
	func pad (to size: Int, with padByte: UInt8, at edge: Edge) -> Data {
		guard count < size else { return self }
		
		let paddingSize = size - count
		let paddingData = Data(Array(repeating: padByte, count: paddingSize))
		let paddedData = edge == .start ? paddingData + self : self + paddingData
		
		return paddedData
	}
	
	func unpad (to size: Int, at edge: Edge) -> Data {
		guard count > size || size == 0 else { return self }
		
		let startIndex: Int
		let endIndex: Int
		
		switch edge {
		case .start:
			startIndex = count - size
			endIndex = count
		case .end:
			startIndex = 0
			endIndex = size
		}
		
		let unpaddedData = self[startIndex..<endIndex]
		return unpaddedData
	}
	
	subscript (safe range: PartialRangeUpTo<Data.Index>) -> Data {
		get {
			let resultData = range.upperBound > endIndex ? self : self[range]
			return resultData
		}
	}
}



extension Data {
	var sha256: Data {
		var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
		self.withUnsafeBytes {
			_ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
		}
		return Data(hash)
	}
	
	var sha512: Data {
		var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
		self.withUnsafeBytes {
			_ = CC_SHA512($0.baseAddress, CC_LONG(self.count), &hash)
		}
		return Data(hash)
	}
	
	@available(OSX, deprecated: 10.15)
	var md5: Data {
		var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
		
		self.withUnsafeBytes {
			_ = CC_MD5($0.baseAddress, CC_LONG(self.count), &hash)
		}
		
		return Data(hash)
	}
}





infix operator <<> : BitwiseShiftPrecedence
infix operator <>> : BitwiseShiftPrecedence

public extension FixedWidthInteger {
	func rotateLeft (_ shift: Int) -> Self {
		let valueBitsCount = MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self << shiftModulus) | (self >> (valueBitsCount - shiftModulus))
	}
	
	func rotateRight (_ shift: Int) -> Self {
		let valueBitsCount = MemoryLayout<Self>.size * 8
		let shiftModulus = shift % valueBitsCount
		return (self >> shiftModulus) | (self << (valueBitsCount - shiftModulus))
	}
	
	static func <<> (_ value: Self, _ shift: Int) -> Self {
		value.rotateLeft(shift)
	}
	
	static func <>> (_ value: Self, _ shift: Int) -> Self {
		value.rotateRight(shift)
	}
}

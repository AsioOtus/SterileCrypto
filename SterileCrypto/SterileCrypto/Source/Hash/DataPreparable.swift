import Foundation



public protocol DataPreparable {
	static var blockSize: Int { get }
}



public extension DataPreparable {
	static func prepare (_ data: Data) -> Data {
		let originalDataBytesCount = data.count
		let originalDataBitsCount = originalDataBytesCount * 8
		
		let paddingOne = [UInt8(0b1000_0000)]
		let paddingBytes = Array<UInt8>(repeating: 0, count: blockSize - 1 - (originalDataBytesCount % blockSize) - 8)
		
		let preparedData = data + paddingOne + paddingBytes + originalDataBitsCount.bigEndian.data
		
		return preparedData
	}
}

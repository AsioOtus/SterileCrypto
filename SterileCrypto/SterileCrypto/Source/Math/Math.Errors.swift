import Foundation
import BigInt

extension Math {
	struct Errors {
		enum PrimeNumberGeneration: Error, CustomDebugStringConvertible {
			case tooSmallBoundNumber(number: BigUInt)
			case tooSmallBoundSize(size: UInt)
			
			var debugDescription: String {
				let debugDescription: String
				
				switch self {
				case .tooSmallBoundNumber(let number):
					debugDescription = "Too small bound number: \(number)"
				case .tooSmallBoundSize(let size):
					debugDescription = "Too small bound size: \(size)"
				}
				
				return debugDescription
			}
		}
	}
}

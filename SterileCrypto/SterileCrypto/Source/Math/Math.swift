import BigInt

struct Math { }



extension Math {
	struct Parameters {
		static let minimalPrimeNumber = 3
		static let minimalPrimeNumberSize = 2
		static let theOnlyEvenPrimeNumber = 2
	}
}



extension Math {
	static func isCoprime (_ a: BigInt, _ b: BigInt) -> Bool {
		return _isCoprime(a, b)
	}
	
	static func isCoprime (_ a: BigUInt, _ b: BigInt) -> Bool {
		let a = BigInt(a)
		return _isCoprime(a, b)
	}
	
	static func isCoprime (_ a: BigInt, _ b: BigUInt) -> Bool {
		let b = BigInt(b)
		return _isCoprime(a, b)
	}
	
	static func isCoprime (_ a: BigUInt, _ b: BigUInt) -> Bool {
		let a = BigInt(a)
		let b = BigInt(b)
		return _isCoprime(a, b)
	}
	
	private static func _isCoprime (_ a: BigInt, _ b: BigInt) -> Bool {
		let isRelativelyPrime = a.greatestCommonDivisor(with: b) == 1
		return isRelativelyPrime
	}
}



extension Math {
	static func gcd (_ a: BigInt, _ b: BigInt) -> BigInt {
		return b != 0 ? gcd(b, a % b) : a
	}
	
	static func lcm (_ a: BigInt, _ b: BigInt) -> BigInt {
		return a * b / gcd(a, b)
	}
	
	static func exgcd (_ a: BigUInt, _ b: BigUInt) -> (BigUInt, BigUInt, BigUInt) {
		guard b != 0 else { return (a, 1, 0) }
		let (d, kA, kB) = exgcd(b, a % b)
		return (d, kB, kA - kB * (a / b))
	}
	
	static func inverseElement (_ a: BigUInt, _ m: BigUInt) -> BigUInt? {
		let (d, kA, _) = exgcd(a, m)
		let inverseElementValue = d == 1 ? (kA % m + m) % m : nil
		return inverseElementValue
	}
}



extension Math {
	static func generatePrimeNumber (size: UInt) throws -> BigUInt {
		guard size > Parameters.minimalPrimeNumberSize else { throw Math.Errors.PrimeNumberGeneration.tooSmallBoundSize(size: size) }
		
		let generatedNumber = generatePrimeNumber(with: { BigUInt.randomInteger(withExactWidth: Int(size)) })
		return generatedNumber
	}
	
	static func generatePrimeNumber (lessThan predeterminedNumber: BigUInt) throws -> BigUInt {
		guard predeterminedNumber < Parameters.minimalPrimeNumber else { throw Math.Errors.PrimeNumberGeneration.tooSmallBoundNumber(number: predeterminedNumber) }
		
		let generatedNumber = generatePrimeNumber(with: { BigUInt.randomInteger(lessThan: predeterminedNumber) })
		return generatedNumber
	}
	
	private static func generatePrimeNumber (with generationFunction: () -> (BigUInt)) -> BigUInt {
		while true {
			let randomNumber = generationFunction()
			
			if isPrime(randomNumber) {
				return randomNumber
			}
		}
	}
	
	private static func isPrime (_ number: BigUInt) -> Bool {
		guard number != Parameters.theOnlyEvenPrimeNumber else { return true }
		
		let number = number | 1
		let isPrime = number.isPrime()
		return isPrime
	}
}



extension Math {
	static func isPrimitiveRoot (_ g: BigUInt, of m: BigUInt) -> Bool {
		guard g.power(m - 1, modulus: m) == 1 else { return false}
		
		for i in 1..<(m - 1) {
			guard g.power(i, modulus: m) != 1 else { return false }
		}
		
		return true
	}
}

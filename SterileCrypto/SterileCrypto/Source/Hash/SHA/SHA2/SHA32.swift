protocol SHA32 {
	associatedtype UnsignedInteger: FixedWidthInteger
}

extension SHA32 {
	static func ch (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger {
		(x & y) ^ ((~x) & z)
	}
	
	static func ma (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger {
		(x & y) ^ (x & z) ^ (y & z)
	}
	
	static func delta0 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 7) ^ (x <>> 18) ^ (x >> 3)
	}
	
	static func delta1 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 17) ^ (x <>> 19) ^ (x >> 10)
	}
	
	static func sigma0 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 2) ^ (x <>> 13) ^ (x <>> 22)
	}
	
	static func sigma1 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 6) ^ (x <>> 11) ^ (x <>> 25)
	}
}

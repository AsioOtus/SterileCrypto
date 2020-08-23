public protocol SHA64 {
	associatedtype UnsignedInteger: FixedWidthInteger
}



public extension SHA64 {
	static func ch (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger {
		(x & y) ^ ((~x) & z)
	}
	
	static func ma (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger {
		(x & y) ^ (x & z) ^ (y & z)
	}
	
	static func delta0 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 1) ^ (x <>> 8) ^ (x >> 7)
	}
	
	static func delta1 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 19) ^ (x <>> 61) ^ (x >> 6)
	}
	
	static func sigma0 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 28) ^ (x <>> 34) ^ (x <>> 39)
	}
	
	static func sigma1 (_ x: UnsignedInteger) -> UnsignedInteger {
		(x <>> 14) ^ (x <>> 18) ^ (x <>> 41)
	}
}

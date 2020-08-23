import Foundation

protocol SHA2: DataPreparable {
	associatedtype UnsignedInteger: FixedWidthInteger
	
	static var blockSize: Int { get }
	
	static var h: [UnsignedInteger] { get }
	static var k: [UnsignedInteger] { get }
	
	static func calculateResultHash (_ hh: [UnsignedInteger]) -> Data
	
	static func ch (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger
	static func ma (_ x: UnsignedInteger, _ y: UnsignedInteger, _ z: UnsignedInteger) -> UnsignedInteger
	
	static func delta0 (_ x: UnsignedInteger) -> UnsignedInteger
	static func delta1 (_ x: UnsignedInteger) -> UnsignedInteger
	
	static func sigma0 (_ x: UnsignedInteger) -> UnsignedInteger
	static func sigma1 (_ x: UnsignedInteger) -> UnsignedInteger
}



extension SHA2 {
	static func hash (_ data: Data) -> Data {
		let preparedData = prepare(data)
		let blocks = preparedData.split(blockSize: blockSize)
		
		var hh = h
		
		for block in blocks {
			var w = block.split(blockSize: blockSize / 16).map{ UnsignedInteger(Data($0.reversed())) }
			
			for i in 0..<k.count where i > 15 {
				let s0 = delta0(w[i - 15])
				let s1 = delta1(w[i - 2])
				
				let t = w[i - 16] &+ s0 &+ w[i - 7] &+ s1
				w.append(t)
			}
			
			var a = hh[0]
			var b = hh[1]
			var c = hh[2]
			var d = hh[3]
			var e = hh[4]
			var f = hh[5]
			var g = hh[6]
			var h = hh[7]
			
			for i in 0..<k.count {
				let temp1 = h &+ sigma1(e) &+ ch(e, f, g) &+ w[i] &+ k[i]
				let temp2 = sigma0(a) &+ ma(a, b, c)
				
				h = g
				g = f
				f = e
				e = d &+ temp1
				d = c
				c = b
				b = a
				a = temp1 &+ temp2
			}
			
			hh[0] = hh[0] &+ a
			hh[1] = hh[1] &+ b
			hh[2] = hh[2] &+ c
			hh[3] = hh[3] &+ d
			hh[4] = hh[4] &+ e
			hh[5] = hh[5] &+ f
			hh[6] = hh[6] &+ g
			hh[7] = hh[7] &+ h
		}
			
		let hash = calculateResultHash(hh)
		return hash
	}
}

//
//  MaskStruct.swift
//  touchbarGame
//
//  Created by 周测 on 11/15/19.
//  Copyright © 2019 aiQG_. All rights reserved.
//

struct SpriteMask {
	static let all: UInt32 = .max
	static let none: UInt32 = 0			//0
	static let enemy: UInt32 = 0b1		//1
	static let shot: UInt32 = 0b10		//2
	static let player: UInt32 = 0b100	//4
	static let life: UInt32 = 0b1000	//8
}

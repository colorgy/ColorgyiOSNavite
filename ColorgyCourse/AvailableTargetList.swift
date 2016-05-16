//
//  AvailableTargetList.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class AvailableTargetList {
	
	var availableTargetList: [AvailableTarget]
	
	public init() {
		availableTargetList = [AvailableTarget]()
	}
	
	public var count: Int {
		return availableTargetList.count
	}
	
	public subscript(index: Int) -> AvailableTarget {
		
		get {
			return availableTargetList[index]
		}
		
		set {
			availableTargetList[index] = newValue
		}
	}
}

extension AvailableTargetList : SequenceType {
	public typealias Generator = AvailableTargetListGenerator
	
	public func generate() -> Generator {
		return AvailableTargetListGenerator(availableTargetList: self.availableTargetList)
	}
}

public class AvailableTargetListGenerator : GeneratorType {
	public typealias Element = AvailableTarget
	
	var currentIndex: Int = 0
	var availableTargetList: [AvailableTarget]?
	
	public init(availableTargetList: [AvailableTarget]) {
		self.availableTargetList = availableTargetList
	}
	
	public func next() -> Element? {
		guard let list = availableTargetList else { return nil }
		
		if currentIndex < list.count {
			let element = list[currentIndex]
			currentIndex += 1
			return element
		} else {
			return nil
		}
	}
}
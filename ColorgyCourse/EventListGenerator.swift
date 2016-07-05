//
//  EventListGenerator.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class  EventListGenerator: GeneratorType {
	public typealias Element = Event
	
	var currentIndex: Int = 0
	var eventList: [Event]?
	
	init(eventList: [Event]) {
		self.eventList = eventList
	}
	
	public func next() -> Element? {
		guard let list = eventList else { return nil }
		
		if currentIndex < list.count {
			let element = list[currentIndex]
			currentIndex += 1
			return element
		} else {
			return nil
		}
	}
}
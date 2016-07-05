//
//  EventList.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class EventList {
	public var eventList: [Event]
	
	public init() {
		eventList = [Event]()
	}
	
	public func add(event: Event) {
		eventList.append(event)
	}
	
	public func add(events: [Event]) {
		eventList.appendContentsOf(events)
	}
	
	// MARK: - Getter
	public var count: Int {
		return eventList.count
	}
	
	// MARK: - Subscript
	public subscript(index: Int) -> Event {
		
		get {
			return eventList[index]
		}
		
		set {
			eventList[index] = newValue
		}
	}
}

extension EventList : CustomStringConvertible {
	public var description: String {
		return eventList.description
	}
}

extension EventList : SequenceType {
	public typealias Generator = EventListGenerator
	
	public func generate() -> Generator {
		return EventListGenerator(eventList: eventList)
	}
}
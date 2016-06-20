//
//  EventManagerViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol EventManagerViewModelDelegate: class {
	
}

final public class EventManagerViewModel {
	
	public weak var delegate: EventManagerViewModelDelegate?
	public private(set) var context: EventManagerContext
	
	init(delegate: EventManagerViewModelDelegate?) {
		self.delegate = delegate
		self.context = EventManagerContext()
	}
	
	public func updateTitleText(text: String?) {
		context.title = text
	}
	
	public func updateSelectedColor(color: UIColor?) {
		context.color = color
	}
	
	public func createNewChildEvent() {
		let childEvent = EventManagerContext.ChildEvent(startTime: NSDate(), endTime: NSDate(), location: "yooooo")
		context.childEvents.append(childEvent)
	}
	
	public func removeChildeEventWithId(id: String?) {
		context.childEvents = context.childEvents.filter { (event) -> Bool in
			return event.eventId != id
		}
	}
}
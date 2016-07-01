//
//  EventManagerViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

public protocol EventManagerViewModelDelegate: class {
	
}

final public class EventManagerViewModel {
	
	public weak var delegate: EventManagerViewModelDelegate?
	public private(set) var context: EventManagerContext
	
	init(delegate: EventManagerViewModelDelegate?) {
		self.delegate = delegate
		self.context = EventManagerContext()
	}
	
	public func updateTitle(with text: String?) {
		context.title = text
	}
	
	public func updateSelectedColor(with color: UIColor?) {
		context.color = color
	}
	
	public func createNewChildEvent() {
		let childEvent = EventManagerContext.ChildEvent(startTime: NSDate(), endTime: NSDate(), location: "yooooo")
		context.childEvents.append(childEvent)
	}
	
	public func removeChildeEvent(with id: String?) {
		context.childEvents = context.childEvents.filter { (event) -> Bool in
			return event.eventId != id
		}
	}
}
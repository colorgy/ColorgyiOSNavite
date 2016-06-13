//
//  CreateEventViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol CreateEventViewModelDelegate: class {
	
}

final public class CreateEventViewModel {
	
	public weak var delegate: CreateEventViewModelDelegate?
	public private(set) var context: CreateEventContext
	
	init(delegate: CreateEventViewModelDelegate?) {
		self.delegate = delegate
		self.context = CreateEventContext()
	}
	
	public func updateTitleText(text: String?) {
		context.title = text
	}
	
	public func updateSelectedColor(color: UIColor?) {
		context.color = color
	}
	
	public func createNewChildEvent() {
		let childEvent = CreateEventContext.ChildEvent(startTime: NSDate(), endTime: NSDate(), location: "yooooo")
		context.childEvents.append(childEvent)
	}
}
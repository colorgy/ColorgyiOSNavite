//
//  CreateEventContext.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

/// This context is used while creating an event.
/// This is **not** a singleton.
/// Will help to generate event model.
final public class CreateEventContext {
	
	public var title: String
	public var color: UIColor?
	public var isRepeatEvent: Bool
	public var repeatEventEndTime: String?
	public var notificationTime: Int
	public var notes: String
	public var childEvents: [ChildEvent]
	
	public struct ChildEvent {
		var startTime: NSDate
		var endTime: NSDate
		var location: String
	}
	
	init() {
		self.title = ""
		self.color = UIColor(red: 198/255.0, green: 188/255.0, blue: 188/255.0, alpha: 1.0)
		self.isRepeatEvent = false
		self.notificationTime = 15
		self.notes = ""
		self.childEvents = [ChildEvent]()
	}
}
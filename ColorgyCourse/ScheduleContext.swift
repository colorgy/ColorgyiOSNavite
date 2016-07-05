//
//  ScheduleContext.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class ScheduleContext {
	
	/// Singleton of ColorgyUserInformation
	public class func shared() -> ScheduleContext {
		
		struct Static {
			static let instance: ScheduleContext = ScheduleContext()
		}
	
		return Static.instance
	}
	
	// MARK: - Init
	private init() {
		courseList = CourseList()
		eventList = EventList()
	}
	
	// MARK: - Parameters
	public private(set) var courseList: CourseList
	public private(set) var eventList: EventList
	
	// MARK: - 
	public func retrieveData(from fromYear: Int, to toYear: Int, complete: (() -> Void)?) {
		
	}
}
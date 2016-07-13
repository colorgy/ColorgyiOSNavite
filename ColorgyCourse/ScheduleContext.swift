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
		serverCourses = []
	}
	
	// MARK: - Parameters
	/// This stores course list that you will use in the given month.
	/// List will cache 42 days of data for further usage.
	/// If you want to get next or previos month's data, there is helper method help you to fetch data.
	public private(set) var courseList: CourseList
	/// This stores event list that you will use in the given month.
	/// List will cache 42 days of data for further usage.
	/// If you want to get next or previos month's data, there is helper method help you to fetch data.
	public private(set) var eventList: EventList
	/// This is server course data, will be init once.
	/// Init this array if user request to search server course.
	public private(set) var serverCourses: [ServerCourse]
	
	// MARK: - Loading Methods
	
	/// Load and update course list of date.
	/// This method will get first day in that month of given date.
	/// For example, if you want course list of 5/20, this method will load data starting from 5/1 and 41 more days' data.
	///
	/// Will load 42 days' data.
	///
	/// When finish loading course list, will call the complete callback.
	public func loadCourseList(of date: NSDate, complete: ((succeed: Bool) -> Void)?) {
		qosBlock {
			guard let fromDate = date.beginingDateOfItsMonth else {
				self.mainBlock { complete?(succeed: false) }
				return
			}
			guard let toDate = date.dateByAddingDay(41) else {
				self.mainBlock { complete?(succeed: false) }
				return
			}
			CourseRealmObject.queryDate(fromDate: fromDate, toDate: toDate) { (objects) in
				// transform
				let courses = Course.generateCourses(withRealmObjects: objects)
				// clear old data
				self.courseList.clearList()
				// add to list
				self.courseList.add(courses)
				// notify update
				self.mainBlock { complete?(succeed: true) }
			}
		}
	}
	
	/// Lazy load server courses for searching courses.
	public func loadServerCourses(complete: ((succeed: Bool) -> Void)?) {
		qosBlock { 
			guard let objects = ServerCourseRealmObject.getAllStoredObjects() else {
				self.mainBlock { complete?(succeed: false) }
				return
			}
			let courses = ServerCourse.generateServerCourses(withRealmObjects: objects)
			self.serverCourses = courses
			self.mainBlock { complete?(succeed: true) }
		}
	}
	
	// MARK: - Helper Methods
	private func mainBlock(block: () -> Void) {
		dispatch_async(dispatch_get_main_queue()) { 
			block()
		}
	}
	
	private func qosBlock(block: () -> Void) {
		let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
		let queue = dispatch_get_global_queue(qos, 0)
		dispatch_async(queue) { 
			block()
		}
	}
}
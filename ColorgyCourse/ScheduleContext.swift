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
	
	// MARK: - 
	public func retrieveData(from fromYear: Int, to toYear: Int, complete: (() -> Void)?) {
		
	}
	
	/// Load and update course list of date.
	/// This method will get first day in that month of given date.
	/// For example, if you want course list of 5/20, this method will load data starting from 5/1 and 41 more days' data.
	///
	/// Will load 42 days' data.
	///
	/// When finish loading course list, will call the complete callback.
	public func loadCourseList(of date: NSDate, complete: ((succeed: Bool) -> Void)?) {
		guard let fromDate = date.beginingDateOfItsMonth else {
			complete?(succeed: false)
			return
		}
		guard let toDate = date.dateByAddingDay(41) else {
			complete?(succeed: false)
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
			complete?(succeed: true)
		}
	}
}
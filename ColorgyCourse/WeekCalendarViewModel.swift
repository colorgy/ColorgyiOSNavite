//
//  WeekCalendarViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

@objc public protocol WeekCalendarViewModelDelegate: class {
	
}

final public class WeekCalendarViewModel {

	public weak var delegate: WeekCalendarViewModelDelegate?
	
	public init(delegate: WeekCalendarViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Public methods
	public func loadData(between fromDate: NSDate, and toDate: NSDate) {
		ScheduleContext.shared().loadCourseList(of: NSDate.create(dateOnYear: 2016, month: 7, day: 1)!) { (succeed) in
			print(succeed, #line, #function)
			let courses = ScheduleContext.shared().courseList
			print(courses)
		}
	}
}
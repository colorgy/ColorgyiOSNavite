//
//  Semester.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class Semester {
	
	/// this method will return (year, term) of this semester according to the time
	class func currentSemesterAndYear() -> (year: Int, term: Int) {
		
		let now = NSDate()
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "yyyy"
		// calculate the year
		let year = Int(formatter.stringFromDate(now)) ?? 0
		var feb = 28
		if year % 4 == 0 {
			// 潤年
			feb = 29
		}
		let daysOfMonth = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
		
		formatter.dateFormat = "MM"
		let monthOfNow = Int(formatter.stringFromDate(now)) ?? 1
		formatter.dateFormat = "dd"
		let dayOfNow = Int(formatter.stringFromDate(now)) ?? 0
		
		// 1/20
		let winterVacation = 20
		// 7/ 30 or 7/31
		var summerVacation = 1
		for i in 0...6 {
			// 1~7 month
			summerVacation += daysOfMonth[i]
		}
		
		// transform now into days
		var daysOfNow = dayOfNow
		for i in 0..<(monthOfNow - 1) {
			daysOfNow += daysOfMonth[i]
		}
		
		if (daysOfNow <= summerVacation && daysOfNow >= winterVacation) {
			// its term 2 and year must -1
			return (year - 1, 2)
		} else if daysOfNow > summerVacation {
			// its term 1, new semester
			return (year, 1)
		} else {
			// still year - 1, term 1
			return (year - 1, 1)
		}
	}
}
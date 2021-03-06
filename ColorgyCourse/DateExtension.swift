//
//  DateExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension NSDate {
	public var rruleFormatString: String {
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.stringFromDate(self)
	}
	
	public class func dateFromRRuleString(rruleString: String) -> NSDate? {
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.dateFromString(rruleString)
	}
}

extension NSDate {
	
	public func isBefore(date: NSDate) -> Bool {
		return compare(date) == .OrderedAscending
	}
	
	public func isSame(with date: NSDate) -> Bool {
		return compare(date) == .OrderedSame
	}
	
	public func isAfter(date: NSDate) -> Bool {
		return compare(date) == .OrderedDescending
	}
	
	public func isAfterOrSame(with date: NSDate) -> Bool {
		return isSame(with: date) || isAfter(date)
	}
	
	public func isBeforeOrSame(with date: NSDate) -> Bool {
		return isSame(with: date) || isBefore(date)
	}
}

extension NSDate {
	public var iso8601String: String {
		let formatter = NSDateFormatter()
		let currentLocale = NSLocale.currentLocale()
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.stringFromDate(self)
	}
	
	public class func dateFrom(iso8601 iso8601String: String?) -> NSDate? {
		guard let iso8601String = iso8601String else { return nil }
		let formatter = NSDateFormatter()
		let currentLocale = NSLocale.currentLocale()
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.dateFromString(iso8601String)
	}
}

extension NSDate {
	public override func isEqual(object: AnyObject?) -> Bool {
		if let date = object as? NSDate {
			if date.day == self.day && date.month == self.month && date.year == self.year {
				// 年月日一樣即相等
				return true
			}
		}
		return false
	}
}

extension NSDate {
	class func create(dateOnYear year: Int, month: Int, day: Int) -> NSDate? {
		return create(dateOnYear: year, month: month, day: day, hour: 0, minute: 0, second: 0)
	}
	
	class func create(dateOnYear year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> NSDate? {
		let components = NSDateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
//		let formatter = NSDateFormatter()
//		formatter.timeZone = NSTimeZone.localTimeZone()
//		formatter.dateFormat = "yyyy MM dd HH mm ss"
//		return formatter.dateFromString("\(year) \(month) \(day) \(hour) \(minute) \(second)")
		return NSCalendar.currentCalendar().dateFromComponents(components)
	}
}

extension NSDate {
	
	var daysInItsMonth: Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self).length
	}
	
	var tomorrow: NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: self)
		component.day += 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	var yesterday: NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: self)
		component.day -= 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	var beginingDateOfItsMonth: NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: self)
		component.day = 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	var endDateOfItsMonth: NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: self)
		component.month += 1
		component.day = 0
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	/// will return from 1 ~ 7
	/// 1 is sunday
	/// 7 is saturday
	/// ```
	/// sun mon tue wen thu fri sat
	///  1   2   3   4   5   6   7
	/// ```
	var weekday: Int {
		return NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: self)
	}
	
	var year: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: self).year
	}
	
	var month: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: self).month
	}
	
	var day: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: self).day
	}
	
	var hour: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: self).hour
	}
	
	var minute: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: self).minute
	}
	
	var second: Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: self).second
	}
	
	func dateByAddingYear(year: Int) -> NSDate? {
		let components = NSDateComponents.maxComponents()
		components.year = year
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: [])
	}
	
	func dateBySubtractingYear(year: Int) -> NSDate? {
		return self.dateByAddingYear(-year)
	}
	
	func dateByAddingMonth(month: Int) -> NSDate? {
		let components = NSDateComponents.maxComponents()
		components.month = month
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: [])
	}
	
	func dateBySubtractingMonth(month: Int) -> NSDate? {
		return self.dateByAddingMonth(-month)
	}
	
	func dateByAddingWeek(week: Int) -> NSDate? {
		let components = NSDateComponents.maxComponents()
		components.weekOfYear = week
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: [])
	}
	
	func dateBySubtractingWeek(week: Int) -> NSDate? {
		return self.dateByAddingWeek(-week)
	}
	
	func dateByAddingDay(day: Int) -> NSDate? {
		let components = NSDateComponents.maxComponents()
		components.day = day
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: [])
	}
	
	func dateBySubtractingDay(day: Int) -> NSDate? {
		return self.dateByAddingDay(-day)
	}
}

extension NSDateComponents {
	class func maxComponents() -> NSDateComponents {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		return components
	}
}
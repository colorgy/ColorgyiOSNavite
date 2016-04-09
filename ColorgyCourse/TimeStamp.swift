//
//  TimeStamp.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class TimeStamp : NSObject {
	
	var year: Int
	var month: Int
	var date: Int
	var hour: Int
	var minute: Int
	var second: Int
	var millisecond: Int
	
	override var description: String {
		return "TimeStamp: (\(year)-\(month)-\(date) \(hour):\(minute):\(second)'\(millisecond))"
	}
	
	override init() {
		let now = NSDate()
		self.year = now.year.intValue ?? 0
		self.month = now.month.intValue ?? 0
		self.date = now.day.intValue ?? 0
		self.hour = now.hour.intValue ?? 0
		self.minute = now.minute.intValue ?? 0
		self.second = now.second.intValue ?? 0
		self.millisecond = 0
		super.init()
	}
	
	init?(timeStampString: String) {
		
		self.year = Int()
		self.month = Int()
		self.date = Int()
		self.hour = Int()
		self.minute = Int()
		self.second = Int()
		self.millisecond = Int()
		
		super.init()
		
		var _year: Int?
		var _month: Int?
		var _date: Int?
		var _hour: Int?
		var _minute: Int?
		var _second: Int?
		var _millisecond: Int?
		
		let trimLastCharaterStrings = timeStampString.characters.split("Z").map(String.init)
		if let string = trimLastCharaterStrings.first {
			let splitDayAndHourStrings = string.characters.split("T").map(String.init)
			if splitDayAndHourStrings.count == 2 {
				let yearMonthDayString = splitDayAndHourStrings[0]
				let yearMonthDayStrings = yearMonthDayString.characters.split("-").map(String.init)
				if yearMonthDayStrings.count == 3 {
					_year = Int(yearMonthDayStrings[0])
					_month = Int(yearMonthDayStrings[1])
					_date = Int(yearMonthDayStrings[2])
				}
				
				let hourString = splitDayAndHourStrings[1]
				let hourStrings = hourString.characters.split(":").map(String.init)
				if hourStrings.count == 3 {
					_hour = Int(hourStrings[0])
					_minute = Int(hourStrings[1])
					if let secondAndMillisecond = Double(hourStrings[2]) {
						_second = Int(secondAndMillisecond / 1.0)
						_millisecond = Int(secondAndMillisecond % 1.0 * 1000)
					}
				}
			}
		}
		
		guard _year != nil else { return nil }
		guard _month != nil else { return nil }
		guard _date != nil else { return nil }
		guard _hour != nil else { return nil }
		guard _minute != nil else { return nil }
		guard _second != nil else { return nil }
		guard _millisecond != nil else { return nil }
		
		self.year = _year!
		self.month = _month!
		self.date = _date!
		self.hour = _hour!
		self.minute = _minute!
		self.second = _second!
		self.millisecond = _millisecond!
	}
	
	func nsdateValue() -> NSDate? {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSS"
		let dateString = "\(year)-\(month)-\(date)-\(hour)-\(minute)-\(second)-\(millisecond)"
		return formatter.dateFromString(dateString)
	}
	
	func timeIntervalSince1970() -> NSTimeInterval {
		if let nsdate = self.nsdateValue() {
			return nsdate.timeIntervalSince1970
		} else {
			return NSTimeIntervalSince1970
		}
	}
	
	func timeStampString() -> String {
		let now = NSDate()
		if let dateCreated = self.nsdateValue() {
			// apple's clock is 10 second behind aws's
			let awsAppleClockDifference = 14.0
			let timeInterval = now.timeIntervalSince1970 - dateCreated.timeIntervalSince1970 - (60.0 * 60 * 8) + awsAppleClockDifference
			//			print("now \(now.timeIntervalSince1970)")
			//			print("dateCreated \(dateCreated.timeIntervalSince1970)")
			//			print("difference \(now.timeIntervalSince1970 - dateCreated.timeIntervalSince1970)")
			//			print("difference \(now.timeIntervalSince1970 - dateCreated.timeIntervalSince1970 - (60.0 * 60 * 8))")
			if timeInterval < 60.0 {
				// seconds
				let seconds = Int(timeInterval % 60)
				return "\(seconds)秒前"
			} else if timeInterval < (60.0 * 60) {
				// minute，1~59分鐘
				// 60秒 x 60分鐘
				let minutes = Int((timeInterval / 60.0) % 60.0)
				return "\(minutes)分鐘前"
			} else if timeInterval < (60.0 * 60 * 24) {
				// hour，1~23小時
				// 60秒 x 60分鐘 x 24小時
				let hours = Int(((timeInterval / 60.0) / 60.0) % 24.0)
				return "\(hours)小時前"
			} else if timeInterval < (60.0 * 60 * 24 * 5) {
				// day，1~5天前
				// 60秒 x 60分鐘 x 24小時 x 5天
				let days = Int((((timeInterval / 60.0) / 60.0) / 24.0) % 5)
				return "\(days)天前"
			} else {
				// 日期顯示
				let formatter = NSDateFormatter()
				formatter.dateFormat = "MMMdd"
				return formatter.stringFromDate(dateCreated)
			}
		} else {
			return "未知時間"
		}
	}
}
//
//  RRule.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/6.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public struct RRule {
	
	// MARK: - Parameters
	public var dtStart: NSDate
	public var until: NSDate
	public var interval: Int
	public var frequency: Frequency
	public var weekStartDay: WKST
	
	// MARK: - Keys
	private struct Keys {
		static let dtStart = "DTSTART"
		static let until = "UNTIL"
		static let interval = "INTERVAL"
		static let frequency = "FREQ"
		static let weekStartDay = "WKST"
	}
	
	// MARK: - Init
	public init?(initWithRRuleString rs: String) {
		var dictionary = [String:String]()
		let contents = rs.characters.split(";").map(String.init)
		for content in contents {
			let keyValuePair = content.characters.split("=").map(String.init)
			if keyValuePair.count == 2 {
				let key = keyValuePair[0]
				let value = keyValuePair[1]
				dictionary[key] = value
			}
		}
		
		// start init
		guard let dtStart = RRule.transform(RRuleDateString: dictionary[Keys.dtStart]) else { return nil }
		self.dtStart = dtStart
		
		guard let dateUntil = (RRule.transform(RRuleDateString: dictionary[Keys.until]) ?? NSDate.create(dateOnYear: 2099, month: 12, day: 31) ?? nil) else { return nil }
		self.until = dateUntil
		
		if let intervalString = dictionary[Keys.interval], let interval = Int(intervalString) where interval > 0 {
			self.interval = interval
		} else {
			interval = 1
		}
		
		if let freqString = dictionary[Keys.frequency], let frequency = Frequency(freqString: freqString) {
			self.frequency = frequency
		} else {
			frequency = .Weekly
		}
		
		if let wsdtString = dictionary[Keys.weekStartDay], let wkst = WKST(wkst: wsdtString) {
			self.weekStartDay = wkst
		} else {
			self.weekStartDay = .MO
		}
	}
	
	public func allOccurrences() -> [NSDate] {
		// first, find base date to get start with
		var baseDate = self.dtStart
		// find start week day
		let weekdayOffset = baseDate.weekday - self.weekStartDay.toInt()
		// choose the start day
		if let newBaseDate = baseDate.dateBySubtractingDay(weekdayOffset) {
			baseDate = newBaseDate
		} else {
			return []
		}
		
		// beyond dtstart, move forward
		// base date < dtstart
		if baseDate.isBefore(self.dtStart) {
			// move 7 days forward
			if let newBaseDate = baseDate.dateByAddingDay(7) {
				baseDate = newBaseDate
			} else {
				return []
			}
		}
		
		if baseDate.isAfter(self.until) {
			return []
		}
		
		var loopingDate = baseDate
		var allOccurrences: [NSDate] = [loopingDate]
		
		while loopingDate.isBeforeOrSame(with: self.until) {
			switch self.frequency {
			case .Yearly:
				guard let nextDate = loopingDate.dateByAddingYear(1 * self.interval) else { return [] }
				loopingDate = nextDate
			case .Monthly:
				guard let nextDate = loopingDate.dateByAddingMonth(1 * self.interval) else { return [] }
				loopingDate = nextDate
			case .Weekly:
				guard let nextDate = loopingDate.dateByAddingWeek(1 * self.interval) else { return [] }
				loopingDate = nextDate
			case .Daily:
				guard let nextDate = loopingDate.dateByAddingDay(1 * self.interval) else { return [] }
				loopingDate = nextDate
			}
			if loopingDate.isBeforeOrSame(with: self.until) {
				allOccurrences.append(loopingDate)
			}
		}
		
		return allOccurrences
	}
	

	
	public static func transform(RRuleDateString rds: String?) -> NSDate? {
		guard let rds = rds else { return nil }
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.dateFromString(rds)
	}
	
	// MARK: - Getters
	public var rruleString: String {
		
		var rruleString: String = ""
		
		rruleString += "\(Keys.dtStart)=\(dtStart.rruleFormatString);"
		rruleString += "\(Keys.until)=\(until.rruleFormatString);"
		rruleString += "\(Keys.frequency)=\(frequency.rawValue);"
		rruleString += "\(Keys.interval)=\(interval);"
		rruleString += "\(Keys.weekStartDay)=\(weekStartDay.rawValue);"
		
		return rruleString
	}
	
	// MARK: - Enums
	public enum Frequency: String {
		case Yearly = "YEARLY"
		case Monthly = "MONTHLY"
		case Weekly = "WEEKLY"
		case Daily = "DAILY"
		
		public init?(freqString freq: String) {
			switch freq {
			case Frequency.Yearly.rawValue: self = .Yearly
			case Frequency.Monthly.rawValue: self = .Monthly
			case Frequency.Weekly.rawValue: self = .Weekly
			case Frequency.Daily.rawValue: self = .Daily
			default: return nil
			}
		}
	}
	
	public enum WKST: String {
		case MO = "MO"
		case TU = "TU"
		case WE = "WE"
		case TH = "TH"
		case FR = "FR"
		case SA = "SA"
		case SU = "SU"
		
		public init?(wkst: String) {
			switch wkst {
			case WKST.MO.rawValue: self = .MO
			case WKST.TU.rawValue: self = .TU
			case WKST.WE.rawValue: self = .WE
			case WKST.TH.rawValue: self = .TH
			case WKST.FR.rawValue: self = .FR
			case WKST.SA.rawValue: self = .SA
			case WKST.SU.rawValue: self = .SU
			default: return nil
			}
		}
		
		public func toInt() -> Int {
			switch self {
			case .SU: return 1
			case .MO: return 2
			case .TU: return 3
			case .WE: return 4
			case .TH: return 5
			case .FR: return 6
			case .SA: return 7
			}
		}
	}
}
//
//  RRule.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/6.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public struct RRule {
	public var dtStart: NSDate
	public var until: NSDate
	public var interval: Int
	public var frequency: Frequency
	public var weekStartDay: WKST
	
	private struct Keys {
		static let dtStart = "DTSTART"
		static let until = "UNTIL"
		static let interval = "INTERVAL"
		static let frequency = "FREQ"
		static let weekStartDay = "WKST"
	}
	
	public init?(rruleString rs: String) {
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
		var baseDate = NSDate.create(dateOnYear: dtStart.year, month: dtStart.month, day: dtStart.day)
		// find start week day
		baseDate?.weekday self.weekStartDay
	}
	
	public static func transform(RRuleDateString rds: String?) -> NSDate? {
		guard let rds = rds else { return nil }
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.dateFromString(rds)
	}
	
	public enum Frequency: String {
		case Yearly = "YEARLY"
		case Monthly = "MONTHLY"
		case Weekly = "WEEKLY"
		case Daily = "DAILY"
		case Hourly = "HOURLY"
		case Minutely = "MINUTELY"
		case Secondly = "SECONDLY"
		
		public init?(freqString freq: String) {
			switch freq {
			case Frequency.Yearly.rawValue: self = .Yearly
			case Frequency.Monthly.rawValue: self = .Monthly
			case Frequency.Weekly.rawValue: self = .Weekly
			case Frequency.Daily.rawValue: self = .Daily
			case Frequency.Hourly.rawValue: self = .Hourly
			case Frequency.Minutely.rawValue: self = .Minutely
			case Frequency.Secondly.rawValue: self = .Secondly
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
			case .MO: return 2
			case .TU: return 3
			case .WE: return 4
			case .TH: return 5
			case .FR: return 6
			case .SA: return 7
			case .SU: return 1
			}
		}
	}
}
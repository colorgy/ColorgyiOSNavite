//
//  CourseRawDataObject.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

/// This is a course raw data representation of a parsed json.
///
/// Pass in a json, then it will generate a CourseRawDataObject.
///
/// This object make it easier to deal with json formate data.
///
/// This json is from school API, not user API.
final public class CourseRawDataObject: CustomStringConvertible {
	
	// 1. properties
	// cache data from server
	// required
	let name: String
	let code: String
	let year: Int
	let term: Int
	
	// optional
	let credits: Int?
	let lecturer: String?
	let type: String?
	let id: Int?
	
	let day_1: Int?
	let day_2: Int?
	let day_3: Int?
	let day_4: Int?
	let day_5: Int?
	let day_6: Int?
	let day_7: Int?
	let day_8: Int?
	let day_9: Int?
	let period_1: Int?
	let period_2: Int?
	let period_3: Int?
	let period_4: Int?
	let period_5: Int?
	let period_6: Int?
	let period_7: Int?
	let period_8: Int?
	let period_9: Int?
	let location_1: String?
	let location_2: String?
	let location_3: String?
	let location_4: String?
	let location_5: String?
	let location_6: String?
	let location_7: String?
	let location_8: String?
	let location_9: String?
	
	// new part
	var general_code: String?
	
	public var description: String { return  "{\n\tname: \(name)\n\tcode: \(code)\n\tyear: \(year)\n\tterm: \(term)\n\tcredits: \(credits)\n\tlecturer: \(lecturer)\n\ttype: \(type)\n\tid: \(id)\n\tday_1: \(day_1)\n\tday_2: \(day_2)\n\tday_3: \(day_3)\n\tday_4: \(day_4)\n\tday_5: \(day_5)\n\tday_6: \(day_6)\n\tday_7: \(day_7)\n\tday_8: \(day_8)\n\tday_9: \(day_9)\n\tperiod_1: \(period_1)\n\tperiod_2: \(period_2)\n\tperiod_3: \(period_3)\n\tperiod_4: \(period_4)\n\tperiod_5: \(period_5)\n\tperiod_6: \(period_6)\n\tperiod_7: \(period_7)\n\tperiod_8: \(period_8)\n\tperiod_9: \(period_9)\n\tlocation_1: \(location_1)\n\tlocation_2: \(location_2)\n\tlocation_3: \(location_3)\n\tlocation_4: \(location_4)\n\tlocation_5: \(location_5)\n\tlocation_6: \(location_6)\n\tlocation_7: \(location_7)\n\tlocation_8: \(location_8)\n\tlocation_9: \(location_9)\n\tgeneral_code: \(general_code)\n}" }
	
	private struct rawDataKey {
		// required
		static let name = "name"
		static let code = "code"
		static let year = "year"
		static let term = "term"
		
		// optional
		static let credits = "credits"
		static let lecturer = "lecturer"
		// caution key is _type in json
		static let type = "_type"
		static let id = "id"
		
		static let day_1 = "day_1"
		static let day_2 = "day_2"
		static let day_3 = "day_3"
		static let day_4 = "day_4"
		static let day_5 = "day_5"
		static let day_6 = "day_6"
		static let day_7 = "day_7"
		static let day_8 = "day_8"
		static let day_9 = "day_9"
		static let period_1 = "period_1"
		static let period_2 = "period_2"
		static let period_3 = "period_3"
		static let period_4 = "period_4"
		static let period_5 = "period_5"
		static let period_6 = "period_6"
		static let period_7 = "period_7"
		static let period_8 = "period_8"
		static let period_9 = "period_9"
		static let location_1 = "location_1"
		static let location_2 = "location_2"
		static let location_3 = "location_3"
		static let location_4 = "location_4"
		static let location_5 = "location_5"
		static let location_6 = "location_6"
		static let location_7 = "location_7"
		static let location_8 = "location_8"
		static let location_9 = "location_9"
		
		// new part
		static let general_code = "general_code"
	}
	
	// 2. init
	/// Initialization of CourseRawDataObject.
	/// You need to pass in a json, then will return a CourseRawDataObject?
	///
	/// :param: json: a json from server. This json is from **school API**, not user API.
	public init?(json: JSON) {
		
		// must not be an array
		guard !json.isArray else { return nil }
		
		// required
		guard let name = json[rawDataKey.name].string else { return nil }
		self.name = name
		
		guard let code = json[rawDataKey.code].string else { return nil }
		self.code = code
		
		guard let year = json[rawDataKey.year].int else { return nil }
		self.year = year
		
		guard let term = json[rawDataKey.term].int else { return nil }
		self.term = term
		
		
		// optional
		self.credits = json[rawDataKey.credits].int
		self.lecturer = json[rawDataKey.lecturer].string
		self.type = json[rawDataKey.type].string
		self.id = json[rawDataKey.id].int
		
		
		self.day_1 = json[rawDataKey.day_1].int
		self.day_2 = json[rawDataKey.day_2].int
		self.day_3 = json[rawDataKey.day_3].int
		self.day_4 = json[rawDataKey.day_4].int
		self.day_5 = json[rawDataKey.day_5].int
		self.day_6 = json[rawDataKey.day_6].int
		self.day_7 = json[rawDataKey.day_7].int
		self.day_8 = json[rawDataKey.day_8].int
		self.day_9 = json[rawDataKey.day_9].int
		
		self.period_1 = json[rawDataKey.period_1].int
		self.period_2 = json[rawDataKey.period_2].int
		self.period_3 = json[rawDataKey.period_3].int
		self.period_4 = json[rawDataKey.period_4].int
		self.period_5 = json[rawDataKey.period_5].int
		self.period_6 = json[rawDataKey.period_6].int
		self.period_7 = json[rawDataKey.period_7].int
		self.period_8 = json[rawDataKey.period_8].int
		self.period_9 = json[rawDataKey.period_9].int
		
		self.location_1 = json[rawDataKey.location_1].string
		self.location_2 = json[rawDataKey.location_2].string
		self.location_3 = json[rawDataKey.location_3].string
		self.location_4 = json[rawDataKey.location_4].string
		self.location_5 = json[rawDataKey.location_5].string
		self.location_6 = json[rawDataKey.location_6].string
		self.location_7 = json[rawDataKey.location_7].string
		self.location_8 = json[rawDataKey.location_8].string
		self.location_9 = json[rawDataKey.location_9].string
		
		self.general_code = json[rawDataKey.general_code].string
	}
	// 3. methods.
	/// This method can get the counts of days array's length.
	///
	/// - returns: Count of days array.
	public func dayLength() -> Int {
		guard self.day_1 != nil else { return 0 }
		guard self.day_2 != nil else { return 1 }
		guard self.day_3 != nil else { return 2 }
		guard self.day_4 != nil else { return 3 }
		guard self.day_5 != nil else { return 4 }
		guard self.day_6 != nil else { return 5 }
		guard self.day_7 != nil else { return 6 }
		guard self.day_8 != nil else { return 7 }
		guard self.day_9 != nil else { return 8 }
		return 9
	}
	
	/// This method can get the counts of periods array's length.
	///
	/// - returns: Count of periods array.
	public func periodLength() -> Int {
		guard self.period_1 != nil else { return 0 }
		guard self.period_2 != nil else { return 1 }
		guard self.period_3 != nil else { return 2 }
		guard self.period_4 != nil else { return 3 }
		guard self.period_5 != nil else { return 4 }
		guard self.period_6 != nil else { return 5 }
		guard self.period_7 != nil else { return 6 }
		guard self.period_8 != nil else { return 7 }
		guard self.period_9 != nil else { return 8 }
		return 9
	}
	
	/// This method can get the counts of locations array's length.
	///
	/// - returns: Count of locations array.
	public func locationLength() -> Int {
		guard self.location_1 != nil else { return 0 }
		guard self.location_2 != nil else { return 1 }
		guard self.location_3 != nil else { return 2 }
		guard self.location_4 != nil else { return 3 }
		guard self.location_5 != nil else { return 4 }
		guard self.location_6 != nil else { return 5 }
		guard self.location_7 != nil else { return 6 }
		guard self.location_8 != nil else { return 7 }
		guard self.location_9 != nil else { return 8 }
		return 9
	}
	
	/// Can check if periods, days, locations are the same length
	/// - returns: Bool - if three arrays are at same lenth
	public func isSameDataLength() -> Bool {
		return (self.dayLength() == self.locationLength() && self.dayLength() == self.periodLength())
	}
	
	/// This is the minimum requirment of a period
	///
	/// If day and period array are not same length, you cannot parse it.
	public func daysAndPeriodsAreSameLength() -> Bool {
		return self.dayLength() == self.periodLength()
	}
	
	/// Generate an array of CourseRawDataObject
	public class func generateObjects(json: JSON) -> [CourseRawDataObject] {
		
		// initialize cache
		var objects = [CourseRawDataObject]()
		
		// check if is array
		if json.isArray {
			// start looping
			for (_, json) : (String, JSON) in json {
				if let object = CourseRawDataObject(json: json) {
					objects.append(object)
				}
			}
		} else {
			// single object
			if let object = CourseRawDataObject(json: json) {
				objects.append(object)
			}
		}
		
		return objects
	}
}
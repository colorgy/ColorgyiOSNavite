//
//  Course.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Course is a object that you can easily handle with the complex courses.
///
/// - Must use CourseRawData to create
///
final public class Course: NSObject {
	
	// MARK: - Parameters
	/// Used to course code, every course has a unique code to access with.
	let code: String
	/// Course's name
	let name: String
	/// Course's year. Format: 2015, 1945, etc.
	let year: Int
	/// Course's term. Format: 1 for first semester, 2 for second semester.
	let term: Int
	/// Name of course's teacher, professor.
	let lecturer: String?
	/// Credits of course
	let credits: Int?
	/// _type of course, like "ntust_course"
	let _type: String?
	// how to configure location period ?
	let periods: [Period]
	/// general code of this course, might be nil
	let general_code: String?
	
	override public var description: String { return "{\n\tcode: \(code)\n\tname: \(name)\n\tyear: \(year)\n\tterm: \(term)\n\tlecturer: \(lecturer)\n\tcredits: \(credits)\n\t_type: \(_type)\n\tperiods😆: \n📖📖📖📖📖\n\(periods)\n📖📖📖📖📖\n\tgeneral_code: \(general_code)\n}" }
	
	// MARK: - Init
	private init?(code: String?, name: String?, year: Int?, term: Int?, lecturer: String?, credits: Int?, _type: String?, days: [Int?], periods: [Int?], locations: [String?], general_code: String?) {
		
		// optional
		self._type = _type
		self.lecturer = lecturer
		self.credits = credits
		self.general_code = general_code
		
		self.periods = Period.generatePeriods(days, periods: periods, locations: locations)
		
		// required
		guard let code = code else { return nil }
		guard let name = name else { return nil }
		guard let year = year else { return nil }
		guard let term = term else { return nil }
		
		self.code = code
		self.name = name
		self.year = year
		self.term = term
		
		super.init()
	}
	
	/// create Course using CourseRawDataObject
	/// if CourseRawDataObject is something wrong, then this will not be created, and return nil
	/// - parameters: 
	///		- rawData: pass in a CourseRawDataObject
	/// - returns: Course
	public convenience init?(rawData: CourseRawDataObject) {
		
		// initialize cache
		var code: String?
		var name: String?
		var year: Int?
		var term: Int?
		var lecturer: String?
		var credits: Int?
		var _type: String?
		// how to configure location period ?
		var days: [Int?] = [Int?]()
		var periods: [Int?] = [Int?]()
		var locations: [String?] = [String?]()
		var general_code: String?
		
		code = rawData.code
		name = rawData.name
		year = rawData.year
		term = rawData.term
		lecturer = rawData.lecturer
		credits = rawData.credits
		_type = rawData.type
		general_code = rawData.general_code
		
		// minimun requirment day period must be same length
		guard rawData.daysAndPeriodsAreSameLength() else {
			return nil
		}
		
		// prepare data...
		let daysRawData = [rawData.day_1 ,rawData.day_2 ,rawData.day_3 ,rawData.day_4 ,rawData.day_5 ,rawData.day_6 ,rawData.day_7 ,rawData.day_8 ,rawData.day_9]
		let periodsRawData = [rawData.period_1 ,rawData.period_2 ,rawData.period_3 ,rawData.period_4 ,rawData.period_5 ,rawData.period_6 ,rawData.period_7 ,rawData.period_8 ,rawData.period_9]
		let locationsRawData = [rawData.location_1 ,rawData.location_2 ,rawData.location_3 ,rawData.location_4 ,rawData.location_5 ,rawData.location_6 ,rawData.location_7 ,rawData.location_8 ,rawData.location_9]
		
		// pack data
		for day in daysRawData {
			days.append(day)
		}
		for period in periodsRawData {
			periods.append(period)
		}
		for location in locationsRawData {
			locations.append(location)
		}
		
		self.init(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
	}
	
	// MARK: - Key
	private struct Key {
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
		
		static let general_code = "general_code"
	}
	
	// MARK: - Generators
	/// Generate an array of courses
	public class func generateCourseArrayWithRawDataObjects(rawDataObjects: [CourseRawDataObject]) -> [Course] {

		// initialize cache
		var courses = [Course]()
		
		for rawDataObject in rawDataObjects {
			if let course = Course(rawData: rawDataObject) {
				courses.append(course)
			}
		}
		
		return courses
	}
}

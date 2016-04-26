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
	public let code: String
	/// Course's name
	public let name: String
	/// Course's year. Format: 2015, 1945, etc.
	public let year: Int
	/// Course's term. Format: 1 for first semester, 2 for second semester.
	public let term: Int
	/// Name of course's teacher, professor.
	public let lecturer: String?
	/// Credits of course
	public let credits: Int?
	/// _type of course, like "ntust_course"
	public let _type: String?
	// how to configure location period ?
	public let periods: [Period]
	/// general code of this course, might be nil
	public let general_code: String?
	
	override public var description: String { return "{\n\tcode: \(code)\n\tname: \(name)\n\tyear: \(year)\n\tterm: \(term)\n\tlecturer: \(lecturer)\n\tcredits: \(credits)\n\t_type: \(_type)\n\tperiods😆: \n📖📖📖📖📖\n\(periods)\n📖📖📖📖📖\n\tgeneral_code: \(general_code)\n}" }
	
	// MARK: - Init
	public init?(code: String?, name: String?, year: Int?, term: Int?, lecturer: String?, credits: Int?, _type: String?, days: [Int?], periods: [Int?], locations: [String?], general_code: String?) {
		
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
		guard term <= 2 && term > 0 else { return nil }
		
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

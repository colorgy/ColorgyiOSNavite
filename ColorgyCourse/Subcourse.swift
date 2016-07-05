//
//  Subcourse.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Subcourse {
	
	public private(set) var id: String
	public private(set) var name: String
	public private(set) var uuid: String
	public private(set) var rrule: String?
	public private(set) var dtStart: NSDate
	public private(set) var dtEnd: NSDate
	public private(set) var detailDescription: String?
	public private(set) var createdAt: NSDate
	public private(set) var updatedAt: NSDate?
	
	public private(set) var courseCredits: Int
	public private(set) var courseLecturer: String?
	public private(set) var courseURL: String
	public private(set) var courseCode: String
	public private(set) var courseRequired: Bool = false
	public private(set) var courseTerm: Int
	public private(set) var courseYear: Int
	
	// MARK: - Keys
	struct Keys {
		static let id = "id"
		static let name = "name"
		static let uuid = "uuid"
		static let rrule = "rrule"
		static let dtStart = "dtstart"
		static let dtEnd = "dtend"
		static let detailDescription = "description"
		static let createdAt = "created_at"
		static let updatedAt = "updated_at"
		static let courseCredits = "course_credits"
		static let courseLecturer = "course_lecturer"
		static let courseURL = "course_url"
		static let courseCode = "course_code"
		static let courseRequired = "course_required"
		static let courseTerm = "course_term"
		static let courseYear = "course_year"
	}
	
	// MARK: - Init
	
	/// Init with json
	public convenience init?(json: JSON) {
		self.init(
			id: json[Keys.id].string,
			name: json[Keys.name].string,
			uuid: json[Keys.uuid].string,
			rrule: json[Keys.rrule].string,
			dtStart: json[Keys.dtStart].string,
			dtEnd: json[Keys.dtEnd].string,
			detailDescription: json[Keys.detailDescription].string,
			createdAt: json[Keys.createdAt].string,
			updatedAt: json[Keys.updatedAt].string,
			courseCredits: json[Keys.courseCredits].int,
			courseLecturer: json[Keys.courseLecturer].string,
			courseURL: json[Keys.courseURL].string,
			courseCode: json[Keys.courseCode].string,
			courseRequired: json[Keys.courseRequired].bool,
			courseTerm: json[Keys.courseTerm].int,
			courseYear: json[Keys.courseYear].int)
		
	}
	
	public convenience init?(withRealmObject object: SubcourseRealmObject) {
		self.init(
			id: object.id,
			name: object.name,
			uuid: object.uuid,
			rrule: object.rrule,
			dtStart: object.dtStart,
			dtEnd: object.dtEnd,
			detailDescription: object.detailDescription,
			createdAt: object.createdAt,
			updatedAt: object.updatedAt,
			courseCredits: object.courseCredits,
			courseLecturer: object.courseLecturer,
			courseURL: object.courseURL,
			courseCode: object.courseCode,
			courseRequired: object.courseRequired,
			courseTerm: object.courseTerm,
			courseYear: object.courseYear)
	}
	
	/// Init with content of strings
	public convenience init?(id: String?, name: String?, uuid: String?, rrule: String?, dtStart: String?, dtEnd: String?, detailDescription: String?, createdAt: String?, updatedAt: String?, courseCredits: Int?, courseLecturer: String?, courseURL: String?, courseCode: String?, courseRequired: Bool?, courseTerm: Int?, courseYear: Int?) {
		// transform string into nsdate
		
		self.init(
			id: id,
			name: name,
			uuid: uuid,
			rrule: rrule,
			dtStart: NSDate.dateFrom(iso8601: dtStart),
			dtEnd: NSDate.dateFrom(iso8601: dtEnd),
			detailDescription: detailDescription,
			createdAt: NSDate.dateFrom(iso8601: createdAt),
			updatedAt: NSDate.dateFrom(iso8601: updatedAt),
			courseCredits: courseCredits,
			courseLecturer: courseLecturer,
			courseURL: courseURL,
			courseCode: courseCode,
			courseRequired: courseRequired,
			courseTerm: courseTerm,
			courseYear: courseYear)
	}
	
	/// Init with contents
	public init?(id: String?, name: String?, uuid: String?, rrule: String?, dtStart: NSDate?, dtEnd: NSDate?, detailDescription: String?, createdAt: NSDate?, updatedAt: NSDate?, courseCredits: Int?, courseLecturer: String?, courseURL: String?, courseCode: String?, courseRequired: Bool?, courseTerm: Int?, courseYear: Int?) {
		
		guard let id = id else { return nil }
		guard let name = name else { return nil }
		guard let dtStart = dtStart else { return nil }
		guard let dtEnd = dtEnd else { return nil }
		guard let uuid = uuid else { return nil }
		guard let createdAt = createdAt else { return nil }
		
		guard let courseCredits = courseCredits else { return nil }
		guard let courseURL = courseURL else { return nil }
		guard let courseCode = courseCode else { return nil }
		guard let courseRequired = courseRequired else { return nil }
		guard let courseTerm = courseTerm else { return nil }
		guard let courseYear = courseYear else { return nil }
		
		self.id = id
		self.name = name
		self.uuid = uuid
		self.rrule = rrule
		self.dtStart = dtStart
		self.dtEnd = dtEnd
		self.detailDescription = detailDescription
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		
		self.courseCredits = courseCredits
		self.courseLecturer = courseLecturer
		self.courseURL = courseURL
		self.courseCode = courseCode
		self.courseRequired = courseRequired
		self.courseTerm = courseTerm
		self.courseYear = courseYear
	}
}

extension Subcourse : CustomStringConvertible {
	public var description: String {
		return "Subcourse: {\n\t\tid: \(id)\n\t\tname: \(name)\n\t\tuuid: \(uuid)\n\t\trrule: \(rrule)\n\t\tdtStart: \(dtStart)\n\t\tdtEnd: \(dtEnd)\n\t\tdetailDescription: \(detailDescription)\n\t\tcreatedAt: \(createdAt)\n\t\tupdatedAt: \(updatedAt)\n}"
	}
}

extension Subcourse {
	public class func generateSubcourses(with json: JSON?) -> [Subcourse] {
		var subcourses = [Subcourse]()
		guard let json = json where json.isArray else { return subcourses }
		for (_, json) : (String, JSON) in json {
			if let subcourse = Subcourse(json: json) {
				subcourses.append(subcourse)
			}
		}
		return subcourses
	}
	
	public class func generateSubcourses(withRealmObjects objects: [SubcourseRealmObject]) -> [Subcourse] {
		var subcourses = [Subcourse]()
		for object in objects {
			if let subcourse = Subcourse(withRealmObject: object) {
				subcourses.append(subcourse)
			}
		}
		return subcourses
	}
}
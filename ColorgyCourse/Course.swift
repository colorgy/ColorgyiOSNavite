//
//  Course.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final public class Course {
	
	public private(set) var id: String
	public private(set) var name: String
	public private(set) var uuid: String
	public private(set) var rrule: RRule?
	public private(set) var startTime: NSDate
	public private(set) var endTime: NSDate
	public private(set) var detailDescription: String?
	public private(set) var referenceId: String?
	public private(set) var createdAt: NSDate
	public private(set) var updatedAt: NSDate?
	
	public private(set) var courseCredits: Int
	public private(set) var courseLecturer: String?
	public private(set) var courseURL: String
	public private(set) var courseCode: String
	public private(set) var courseRequired: Bool = false
	public private(set) var courseTerm: Int
	public private(set) var courseYear: Int
	
	public private(set) var subcourses: [Subcourse]
	
	// MARK: - Keys
	struct Keys {
		static let id = "id"
		static let name = "name"
		static let uuid = "uuid"
		static let rrule = "rrule"
		static let startTime = "start_time"
		static let endTime = "end_time"
		static let detailDescription = "description"
		static let referenceId = "reference_id"
		static let createdAt = "created_at"
		static let updatedAt = "updated_at"
		static let courseCredits = "course_credits"
		static let courseLecturer = "course_lecturer"
		static let courseURL = "course_url"
		static let courseCode = "course_code"
		static let courseRequired = "course_required"
		static let courseTerm = "course_term"
		static let courseYear = "course_year"
		static let subcourses = "sub_courses"
	}
	
	// MARK: - Init
	
	/// Init with json
	public convenience init?(json: JSON) {
		
		let subcourses = Subcourse.generateSubcourses(with: json[Keys.subcourses])
		let rrule = RRule(initWithRRuleString: json[Keys.rrule].string)
		
		self.init(
			id: json[Keys.id].string,
			name: json[Keys.name].string,
			uuid: json[Keys.uuid].string,
			rrule: rrule,
			startTime: json[Keys.startTime].string,
			endTime: json[Keys.endTime].string,
			detailDescription: json[Keys.detailDescription].string,
			referenceId: json[Keys.referenceId].string,
			createdAt: json[Keys.createdAt].string,
			updatedAt: json[Keys.updatedAt].string,
			courseCredits: json[Keys.courseCredits].int,
			courseLecturer: json[Keys.courseLecturer].string,
			courseURL: json[Keys.courseURL].string,
			courseCode: json[Keys.courseCode].string,
			courseRequired: json[Keys.courseRequired].bool,
			courseTerm: json[Keys.courseTerm].int,
			courseYear: json[Keys.courseYear].int,
			subcourses: subcourses)
		
	}
	
	public convenience init?(withRealmObject object: CourseRealmObject) {
		
		// object -> Course -> subcourse
		let subcourseObjects = object.subcourses.map { $0 }
		let subcourses = Subcourse.generateSubcourses(withRealmObjects: subcourseObjects)
		
		self.init(
			id: object.id,
			name: object.name,
			uuid: object.uuid,
			rrule: object.rrule?.toRRule,
			startTime: object.startTime,
			endTime: object.endTime,
			detailDescription: object.detailDescription,
			referenceId: object.referenceId,
			createdAt: object.createdAt,
			updatedAt: object.updatedAt,
			courseCredits: object.courseCredits,
			courseLecturer: object.courseLecturer,
			courseURL: object.courseURL,
			courseCode: object.courseCode,
			courseRequired: object.courseRequired,
			courseTerm: object.courseTerm,
			courseYear: object.courseYear,
			subcourses: subcourses)
	}
	
	/// Init with content of strings
	public convenience init?(id: String?, name: String?, uuid: String?, rrule: RRule?, startTime: String?, endTime: String?, detailDescription: String?, referenceId: String?, createdAt: String?, updatedAt: String?, courseCredits: Int?, courseLecturer: String?, courseURL: String?, courseCode: String?, courseRequired: Bool?, courseTerm: Int?, courseYear: Int?, subcourses: [Subcourse]) {
		// transform string into nsdate
		
		self.init(
			id: id,
			name: name,
			uuid: uuid,
			rrule: rrule,
			startTime: NSDate.dateFrom(iso8601: startTime),
			endTime: NSDate.dateFrom(iso8601: endTime),
			detailDescription: detailDescription,
			referenceId: referenceId,
			createdAt: NSDate.dateFrom(iso8601: createdAt),
			updatedAt: NSDate.dateFrom(iso8601: updatedAt),
			courseCredits: courseCredits,
			courseLecturer: courseLecturer,
			courseURL: courseURL,
			courseCode: courseCode,
			courseRequired: courseRequired,
			courseTerm: courseTerm,
			courseYear: courseYear,
			subcourses: subcourses)
	}
	
	/// Init with contents
	public init?(id: String?, name: String?, uuid: String?, rrule: RRule?, startTime: NSDate?, endTime: NSDate?, detailDescription: String?, referenceId: String?, createdAt: NSDate?, updatedAt: NSDate?, courseCredits: Int?, courseLecturer: String?, courseURL: String?, courseCode: String?, courseRequired: Bool?, courseTerm: Int?, courseYear: Int?, subcourses: [Subcourse]) {
		
		guard let id = id else { return nil }
		guard let name = name else { return nil }
		guard let startTime = startTime else { return nil }
		guard let endTime = endTime else { return nil }
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
		self.startTime = startTime
		self.endTime = endTime
		self.detailDescription = detailDescription
		self.referenceId = referenceId
		self.createdAt = createdAt
		self.updatedAt = updatedAt
		
		self.courseCredits = courseCredits
		self.courseLecturer = courseLecturer
		self.courseURL = courseURL
		self.courseCode = courseCode
		self.courseRequired = courseRequired
		self.courseTerm = courseTerm
		self.courseYear = courseYear
		
		self.subcourses = subcourses
		
	}
}

extension Course : CustomStringConvertible {
	public var description: String {
		return "Course: {\n\tid: \(id)\n\tname: \(name)\n\tuuid: \(uuid)\n\trrule: \(rrule)\n\tstartTime: \(startTime)\n\tendTime: \(endTime)\n\tdetailDescription: \(detailDescription)\n\treferenceId: \(referenceId)\n\tcreatedAt: \(createdAt)\n\tupdatedAt: \(updatedAt)\n\tcourseCredits: \(courseCredits)\n\tcourseLecturer: \(courseLecturer)\n\tcourseURL: \(courseURL)\n\tcourseCode: \(courseCode)\n\tcourseRequired: \(courseRequired)\n\tcourseTerm: \(courseTerm)\n\tcourseYear: \(courseYear)\n\tsubcourses: \(subcourses)\n}"
	}
}

extension Course {
	public class func generateCourses(with json: JSON) -> [Course] {
		var courses = [Course]()
		guard json.isArray else { return courses }
		for (_, json) : (String, JSON) in json {
			if let course = Course(json: json) {
				courses.append(course)
			}
		}
		return courses
	}
	
	public class func generateCourses(withRealmObjects objects: [CourseRealmObject]) -> [Course] {
		var courses = [Course]()
		for object in objects {
			if let course = Course(withRealmObject: object) {
				courses.append(course)
			}
		}
		return courses
	}
}

extension Course {
	public func saveToRealm(complete: ((succeed: Bool) -> Void)?) {
		autoreleasepool {
			do {
				let realm = try Realm()
				realm.beginWrite()
				// start writing to realm
				let courseRealmObject = CourseRealmObject(withCourse: self)
				realm.add(courseRealmObject)
				// commit write
				try realm.commitWrite()
				// finished
				complete?(succeed: true)
			} catch {
				complete?(succeed: false)
			}
		}
	}
}
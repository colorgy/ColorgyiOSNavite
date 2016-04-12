//
//  StudnetAndCourseRelationshipObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

/// This is used when you get the studnet in a specific course
///
/// You will see the relationship between student and course
final public class CourseOwnershipObject: NSObject {
	
	// uuid here is not code, is server's
	/// UUID here is a server stamp, must be unique.
	public let uuid: String
	/// Course's unique id in server.
	///
	/// Normally, you don't need to handle this in app.
	public let id: Int
	/// Organization code of a specific course.
	///
	/// Might be nil due to instable data base.
	public let course_organization_code: String?
	/// Course Code.
	///
	/// This is a 😎 must have value.
	///
	/// Won't be nil. If this its nil, this UserCourseObject will never be generated.
	/// Never thought too much, just use it!
	public let course_code: String
	/// The id of user. Nothing special..
	public let user_id: Int
	/// Year. Format is like 2015, 1945, etc.
	public let year: Int
	/// 1 for first semester, 2 for second semester.
	public let term: Int
	/// Type of this course, like "ntust_course".
	public let _type: String
	
	public override var description: String {
		return "CourseOwnershipObject: {\n\tuuid: \(uuid)\n\tid: \(id)\n\tcourse_organization_code: \(course_organization_code)\n\tcourse_code: \(course_code)\n\tuser_id: \(user_id)\n\tyear: \(year)\n\tterm: \(term)\n\t_type: \(_type)\n}"
	}
	
	private struct CourseOwnershipObjectKey {
		static let uuid = "uuid"
		static let id = "id"
		static let course_organization_code = "course_organization_code"
		static let course_code = "course_code"
		static let user_id = "user_id"
		static let year = "year"
		static let term = "term"
		static let _type = "_type"
	}
	
	/// Initialization: Create a StudnetAndCourseRelationshipObject.
	///
	/// Won't be created if json file doesn't contain necessary values.
	///
	/// - parameters:
	///   - json: a json from server. This json is from **user API**, not school API.
	init?(json: JSON) {
		
		// this json shouldn't be an array
		guard !json.isArray else { return nil }
		
		guard let uuid = json[CourseOwnershipObjectKey.uuid].string else { return nil }
		guard let id = json[CourseOwnershipObjectKey.id].int else { return nil }
		guard let course_organization_code = json[CourseOwnershipObjectKey.course_organization_code].string else { return nil }
		guard let course_code = json[CourseOwnershipObjectKey.course_code].string else { return nil }
		guard let user_id = json[CourseOwnershipObjectKey.user_id].int else { return nil }
		guard let year = json[CourseOwnershipObjectKey.year].int else { return nil }
		guard let term = json[CourseOwnershipObjectKey.term].int else { return nil }
		guard let _type = json[CourseOwnershipObjectKey._type].string else { return nil }
		
		self.uuid = uuid
		self.id = id
		self.course_organization_code = course_organization_code
		self.course_code = course_code
		self.user_id = user_id
		self.year = year
		self.term = term
		self._type = _type
		
		super.init()
	}
	
	public class func generateOwnerShipObjects(json: JSON) -> [CourseOwnershipObject] {
		
		// initialize cache
		var objects = [CourseOwnershipObject]()
		
		// check if its an array
		if json.isArray {
			// array
			for (_, json) : (String, JSON) in json {
				if let object = CourseOwnershipObject(json: json) {
					objects.append(object)
				}
			}
		} else {
			// single object
			if let object = CourseOwnershipObject(json: json) {
				objects.append(object)
			}
		}
		
		return objects
	}
}
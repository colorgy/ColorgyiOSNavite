//
//  ServreCourseRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

public class ServerCourseRealmObject: Object {
    
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var rrule: RRuleRealmObject?
	dynamic var startTime: NSDate = NSDate()
	dynamic var endTime: NSDate = NSDate()
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
	dynamic var courseCredits: Int = 0
	dynamic var courseLecturer: String?
	dynamic var courseURL: String = ""
	dynamic var courseCode: String = ""
	dynamic var courseRequired: Bool = false
	dynamic var courseTerm: Int = 0
	dynamic var courseYear: Int = 0
	
	var subcourses = List<SubcourseRealmObject>()
	
	// MARK: - Init
	public convenience init(withServerCourse course: ServerCourse) {
		self.init()
		self.id = course.id
		self.name = course.name
		self.uuid = course.uuid
		self.rrule = course.rrule?.toRealmObject
		self.startTime = course.startTime
		self.endTime = course.endTime
		self.detailDescription = course.detailDescription
		self.referenceId = course.referenceId
		self.createdAt = course.createdAt
		self.updatedAt = course.updatedAt
		self.courseCredits = course.courseCredits ?? 0
		self.courseLecturer = course.courseLecturer
		self.courseURL = course.courseURL ?? ""
		self.courseCode = course.courseCode ?? ""
		self.courseRequired = course.courseRequired
		self.courseTerm = course.courseTerm ?? 0
		self.courseYear = course.courseYear ?? 0
		
		let subcourseObjects = SubcourseRealmObject.generate(withSubcourses: course.subcourses)
		self.subcourses.appendContentsOf(subcourseObjects)
	}
	
	/// Get all stored objects of ServerCourseRealmObject
	public class func getAllStoredObjects() -> [ServerCourseRealmObject]? {
		do {
			let realm = try Realm()
			return realm.objects(ServerCourseRealmObject.self).map { $0 }
		} catch {
			return nil
		}
	}
}

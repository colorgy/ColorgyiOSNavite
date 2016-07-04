//
//  SubcourseRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class SubcourseRealmObject: Object {
	
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var detailDescription: String?
	dynamic var rrule: String?
	dynamic var dtStart: String = ""
	dynamic var dtEnd: String = ""
	dynamic var createdAt: String = ""
	dynamic var updatedAt: String?
	
	dynamic var courseCredits: Int = 0
	dynamic var courseLecturer: String = ""
	dynamic var courseURL: String = ""
	dynamic var courseCode: String = ""
	dynamic var courseRequired: Bool = false
	dynamic var courseTerm: Int = 0
	dynamic var courseYear: Int = 0
	
}

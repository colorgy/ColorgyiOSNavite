//
//  ServerCourse.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

public class ServerCourse: Course {
	
	public override var description: String {
		return ""
	}
	
	public override func saveToRealm(complete: ((succeed: Bool) -> Void)?) {
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
//
//  EventRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

public class EventRealmObject: Object {
	
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var rrule: String?
	dynamic var dtStart: String = ""
	dynamic var dtEnd: String = ""
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var updatedAt: String?
	
}

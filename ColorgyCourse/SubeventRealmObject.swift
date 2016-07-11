//
//  SubeventRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class SubeventRealmObject: Object {
    
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var detailDescription: String?
	dynamic var rrule: RRuleRealmObject?
	dynamic var startTime: NSDate = NSDate()
	dynamic var endTime: NSDate = NSDate()
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
}

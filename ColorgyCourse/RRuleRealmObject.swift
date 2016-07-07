//
//  RRuleRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/7.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class RRuleRealmObject: Object {
    
	// MARK: - Parameters
	/// Start date of rrule.
	/// This is required.
	dynamic var dtStart: NSDate = NSDate()
	/// End date of rrule.
	/// This is required.
	dynamic var until: NSDate = NSDate()
	/// Gap between recurrence date rule, default to 1.
	/// This is required.
	dynamic var interval: Int32 = 1
	/// Frequency of date, default to Weekly.
	/// This is required.
	dynamic var frequency: String = "WEEKLY"
	/// Week start day of rrule, default to .MO
	/// This is required
	dynamic var weekStartDay: String = "MO"
	
	public convenience init(withRRule rrule: RRule) {
		self.init()
		self.dtStart = rrule.dtStart
		self.until = rrule.until
		self.interval = rrule.interval.int32
		self.frequency = rrule.frequency.rawValue
		self.weekStartDay = rrule.weekStartDay.rawValue
	}
	
	public var toRRule: RRule? {
		return RRule(withRealmObject: self)
	}
}

extension RRuleRealmObject {
	public class func getStoredRRuleRealmObjects() -> [RRuleRealmObject] {
		do {
			let realm = try Realm()
			return realm.objects(RRuleRealmObject.self).map { $0 }
		} catch {
			return []
		}
	}
	
	public class func getStoredRRuleRealmObjects(complete: ((objects: [RRuleRealmObject]) -> Void)?) {
		dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
			let objects = self.getStoredRRuleRealmObjects()
			dispatch_async(dispatch_get_main_queue(), { 
				complete?(objects: objects)
			})
		}
	}
}
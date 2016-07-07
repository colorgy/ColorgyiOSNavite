//
//  EventRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class EventRealmObject: Object {
	
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var rrule: RRuleRealmObject?
	dynamic var dtStart: NSDate = NSDate()
	dynamic var dtEnd: NSDate = NSDate()
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
	let subevents = List<SubeventRealmObject>()
	
}

extension EventRealmObject {
	public class func queryData(fromYear fromYear: Int, toYear: Int, complete: ((objects: [EventRealmObject]) -> Void)?) {
		autoreleasepool {
			var objects = [EventRealmObject]()
			let _fromYear = fromYear < toYear ? fromYear : toYear
			let _toYear = fromYear < toYear ? toYear : fromYear
			guard let fromDate = NSDate.create(dateOnYear: _fromYear, month: 1, day: 1) else {
				complete?(objects: objects)
				return
			}
			guard let toDate = NSDate.create(dateOnYear: _toYear, month: 12, day: 31) else {
				complete?(objects: objects)
				return
			}
			do {
				let realm = try Realm()
				objects = realm.objects(EventRealmObject.self).filter("dtStart <= %@ AND dtEnd >= %@", toDate, fromDate).map { $0 }
				complete?(objects: objects)
			} catch {
				complete?(objects: objects)
			}
		}
	}
}

extension Array where Element: EventRealmObject {
	public func querySubevent(fromDate fromDate: NSDate, to toDate: NSDate) {
		var objects = [SubeventRealmObject]()
		let _fromDate = (fromDate.isBefore(toDate) ? fromDate : toDate)
		let _toDate = (toDate.isAfterOrSame(with: fromDate) ? toDate : fromDate)
		do {
			let realm = try Realm()
			self
		} catch {
			
		}
	}
}
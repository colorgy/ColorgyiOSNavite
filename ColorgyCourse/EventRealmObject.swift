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
	dynamic var rrule: String?
	dynamic var dtStart: NSDate = NSDate()
	dynamic var dtEnd: NSDate = NSDate()
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
	let subevents = List<SubeventRealmObject>()
	
}

extension EventRealmObject {
	public class func queryData(fromYear fromYear: Int, toYear toYear: Int, complete: ((events: [Event]) -> Void)?) {
		autoreleasepool {
			var events = [Event]()
			let _fromYear = fromYear < toYear ? fromYear : toYear
			let _toYear = fromYear < toYear ? toYear : fromYear
			do {
				let realm = try Realm()
				let objects = realm.objects(EventRealmObject.self).filter("dtStart.year >= %@ AND dtEnd.year >= %@ AND dtStart.year <= %@ AND dtEnd.year <= %@", _fromYear, _fromYear, _toYear, _toYear).map { $0 }
				events = Event.generateEvents(withRealmObjects: objects)
				complete?(events: events)
			} catch {
				complete?(events: events)
			}
		}
	}
}
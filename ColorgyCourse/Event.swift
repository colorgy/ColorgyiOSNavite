//
//  Event.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Event {
	
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
	
	public private(set) var subevents: [Subevent]
	
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
		static let subevents = "sub_events"
	}
	
	// MARK: - Init
	
	/// Init with json
	public convenience init?(json: JSON) {
		let subevents = Subevent.generateSubevents(with: json)
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
			subevents: subevents)
	}
	
	/// Init with SubcourseRealmObject
	public convenience init?(withRealmObject object: EventRealmObject) {
		let subevents = Subevent.generateSubevnets(withRealmObjects: object.subevents.map { $0 })
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
			subevents: subevents)
	}
	
	/// Init with content of strings
	public convenience init?(id: String?, name: String?, uuid: String?, rrule: RRule?, startTime: String?, endTime: String?, detailDescription: String?, referenceId: String?, createdAt: String?, updatedAt: String?, subevents: [Subevent]) {
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
			subevents: subevents)
	}
	
	/// Init with contents
	public init?(id: String?, name: String?, uuid: String?, rrule: RRule?, startTime: NSDate?, endTime: NSDate?, detailDescription: String?, referenceId: String?, createdAt: NSDate?, updatedAt: NSDate?, subevents: [Subevent]) {
		
		guard let id = id else { return nil }
		guard let name = name else { return nil }
		guard let startTime = startTime else { return nil }
		guard let endTime = endTime else { return nil }
		guard let uuid = uuid else { return nil }
		guard let createdAt = createdAt else { return nil }
		
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
		
		self.subevents = subevents
	}
}

extension Event : CustomStringConvertible {
	public var description: String {
		return "Event: {\n\tid: \(id)\n\tname: \(name)\n\tuuid: \(uuid)\n\trrule: \(rrule)\n\tstartTime: \(startTime)\n\tendTime: \(endTime)\n\tdetailDescription: \(detailDescription)\n\treferenceId: \(referenceId)\n\tcreatedAt: \(createdAt)\n\tupdatedAt: \(updatedAt)\n\n\tsubevents: \(subevents)}"
	}
}

extension Event {
	public class func generateEvents(with json: JSON) -> [Event] {
		var events = [Event]()
		guard json.isArray else { return events }
		for (_, json) : (String, JSON) in json {
			if let event = Event(json: json) {
				events.append(event)
			}
		}
		return events
	}
	
	public class func generateEvents(withRealmObjects objects: [EventRealmObject]) -> [Event] {
		var events = [Event]()
		for object in objects {
			if let event = Event(withRealmObject: object) {
				events.append(event)
			}
		}
		return events
	}
}
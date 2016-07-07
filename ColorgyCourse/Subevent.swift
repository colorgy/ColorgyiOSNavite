//
//  Subevent.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Subevent {
	
	public private(set) var id: String
	public private(set) var name: String
	public private(set) var uuid: String
	public private(set) var detailDescription: String?
	public private(set) var rrule: RRule?
	public private(set) var dtStart: NSDate
	public private(set) var dtEnd: NSDate
	public private(set) var createdAt: NSDate
	public private(set) var updatedAt: NSDate?
	
	// MARK: - Keys
	struct Keys {
		static let id = "id"
		static let name = "name"
		static let uuid = "uuid"
		static let rrule = "rrule"
		static let dtStart = "dtstart"
		static let dtEnd = "dtend"
		static let detailDescription = "description"
		static let createdAt = "created_at"
		static let updatedAt = "updated_at"
	}
	
	// MARK: - Init
	
	/// Init with json
	public convenience init?(json: JSON) {
		let rrule = RRule(initWithRRuleString: <#T##String#>)
		self.init(
			id: json[Keys.id].string,
			name: json[Keys.name].string,
			uuid: json[Keys.uuid].string,
			rrule: json[Keys.rrule].string,
			dtStart: json[Keys.dtStart].string,
			dtEnd: json[Keys.dtEnd].string,
			detailDescription: json[Keys.detailDescription].string,
			createdAt: json[Keys.createdAt].string,
			updatedAt: json[Keys.updatedAt].string)
	}
	
	/// Init with realm object
	public convenience init?(withRealmObject object: SubeventRealmObject) {
		self.init(
			id: object.id,
			name: object.name,
			uuid: object.uuid,
			rrule: object.rrule,
			dtStart: object.dtStart,
			dtEnd: object.dtEnd,
			detailDescription: object.detailDescription,
			createdAt: object.createdAt,
			updatedAt: object.updatedAt)
	}
	
	/// Init with content of strings
	public convenience init?(id: String?, name: String?, uuid: String?, rrule: RRule?, dtStart: String?, dtEnd: String?, detailDescription: String?, createdAt: String?, updatedAt: String?) {
		// transform string into nsdate
		
		self.init(
			id: id,
			name: name,
			uuid: uuid,
			rrule: rrule,
			dtStart: NSDate.dateFrom(iso8601: dtStart),
			dtEnd: NSDate.dateFrom(iso8601: dtEnd),
			detailDescription: detailDescription,
			createdAt: NSDate.dateFrom(iso8601: createdAt),
			updatedAt: NSDate.dateFrom(iso8601: updatedAt))
	}
	
	/// Init with contents
	public init?(id: String?, name: String?, uuid: String?, rrule: RRule?, dtStart: NSDate?, dtEnd: NSDate?, detailDescription: String?, createdAt: NSDate?, updatedAt: NSDate?) {
		
		guard let id = id else { return nil }
		guard let name = name else { return nil }
		guard let dtStart = dtStart else { return nil }
		guard let dtEnd = dtEnd else { return nil }
		guard let uuid = uuid else { return nil }
		guard let createdAt = createdAt else { return nil }
		
		self.id = id
		self.name = name
		self.uuid = uuid
		self.rrule = rrule
		self.dtStart = dtStart
		self.dtEnd = dtEnd
		self.detailDescription = detailDescription
		self.createdAt = createdAt
		self.updatedAt = updatedAt
	}
	
}

extension Subevent : CustomStringConvertible {
	public var description: String {
		return "Subevent: {\n\t\tid: \(id)\n\t\tname: \(name)\n\t\tuuid: \(uuid)\n\t\trrule: \(rrule)\n\t\tdtStart: \(dtStart)\n\t\tdtEnd: \(dtEnd)\n\t\tdetailDescription: \(detailDescription)\n\t\tcreatedAt: \(createdAt)\n\t\tupdatedAt: \(updatedAt)\n}"
	}
}

extension Subevent {
	public class func generateSubevents(with json: JSON?) -> [Subevent] {
		var subevents = [Subevent]()
		guard let json = json where json.isArray else { return subevents }
		for (_, json) : (String, JSON) in json {
			if let subevent = Subevent(json: json) {
				subevents.append(subevent)
			}
		}
		return subevents
	}
	
	public class func generateSubevnets(withRealmObjects objects: [SubeventRealmObject]) -> [Subevent] {
		var subevents = [Subevent]()
		for object in objects {
			if let subevent = Subevent(withRealmObject: object) {
				subevents.append(subevent)
			}
		}
		return subevents
	}
}
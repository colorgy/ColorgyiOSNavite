//
//  Event.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Event: CustomStringConvertible {
	
	public private(set) var id: String
	public private(set) var name: String
	public private(set) var uuid: String
	public private(set) var rrule: String?
	public private(set) var dtStart: String
	public private(set) var dtEnd: String
	public private(set) var detailDescription: String?
	public private(set) var referenceId: String?
	public private(set) var createdAt: String
	public private(set) var updatedAt: String?
	
	public var description: String {
		return "Event: {}"
	}
	
	// MARK: - Keys
	struct Keys {
		static let id = "id"
		static let name = "name"
		static let uuid = "uuid"
		static let rrule = "rrule"
		static let dtStart = "dtstart"
		static let dtEnd = "dtend"
		static let detailDescription = "description"
		static let referenceId = "reference_id"
		static let createdAt = "created_at"
		static let updatedAt = "updated_at"
	}
	
	// MARK: - Init
	
	/// Init with json
	public convenience init?(json: JSON) {
		self.init(
			id: json[Keys.id].string,
			name: json[Keys.name].string,
			uuid: json[Keys.uuid].string,
			rrule: json[Keys.rrule].string,
			dtStart: json[Keys.dtStart].string,
			dtEnd: json[Keys.dtEnd].string,
			detailDescription: json[Keys.detailDescription].string,
			referenceId: json[Keys.referenceId].string,
			createdAt: json[Keys.createdAt].string,
			updatedAt: json[Keys.updatedAt].string)
	}
	
	/// Init with contents
	public init?(id: String?, name: String?, uuid: String?, rrule: String?, dtStart: String?, dtEnd: String?, detailDescription: String?, referenceId: String?, createdAt: String?, updatedAt: String?) {
		
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
		self.referenceId = referenceId
		self.createdAt = createdAt
		self.updatedAt = updatedAt
	}
}
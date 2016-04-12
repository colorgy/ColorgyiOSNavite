//
//  Organization.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Organization: CustomStringConvertible {
	
	// MARK: - Parameters
	public let code: String
	public let name: String
	public let shortName: String
	public let id: String
	public let type: String
	
	// MARK: - Key
	private struct OrganizationKey {
		static let code = "code"
		static let name = "name"
		static let shortName = "short_name"
		static let id = "id"
		static let type = "_type"
	}
	
	public var description: String {
		return "Organization: {\n\tcode = \(code)\n\tname = \(name)\n\tshortName = \(shortName)\n\tid = \(id)\n\ttype = \(type)\n}"
	}
	
	// MARK: - Init
	init?(json: JSON) {
		
		guard let code = json[OrganizationKey.code].string else { return nil }
		guard let name = json[OrganizationKey.name].string else { return nil }
		guard let shortName = json[OrganizationKey.shortName].string else { return nil }
		guard let id = json[OrganizationKey.id].string else { return nil }
		guard let type = json[OrganizationKey.type].string else { return nil }
		
		self.code = code
		self.name = name
		self.shortName = shortName
		self.id = id
		self.type = type
	}
	
	// MARK: - Generator
	class func generateOrganizationsWithJSON(json: JSON) -> [Organization] {
		var objects = [Organization]()
		
		// if is an array
		if json.isArray {
			for (_, json) : (String, JSON) in json {
				if let school = Organization(json: json) {
					objects.append(school)
				}
			}
		} else {
			// single element
			if let school = Organization(json: json) {
				objects.append(school)
			}
		}
	
		return objects
	}
}
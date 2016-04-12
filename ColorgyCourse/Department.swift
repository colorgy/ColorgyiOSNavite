//
//  Department.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Department : CustomStringConvertible {
	
	// MARK: - Parameters
	public let code: String
	public let name: String
	public let shortName: String
	public let id: String
	public let type: String
	
	// MARK: - Key
	private struct DepartmentKey {
		static let code = "code"
		static let name = "name"
		static let shortName = "short_name"
		static let id = "id"
		static let type = "_type"
	}
	
	public var description: String {
		return "Department: {\n\tcode = \(code)\n\tname = \(name)\n\tshortName = \(shortName)\n\tid = \(id)\n\ttype = \(type)\n}"
	}
	
	// MARK: - Init
	public init?(json: JSON) {
		
		guard let code = json[DepartmentKey.code].string else { return nil }
		guard let name = json[DepartmentKey.name].string else { return nil }
		guard let shortName = json[DepartmentKey.shortName].string else { return nil }
		guard let id = json[DepartmentKey.id].string else { return nil }
		guard let type = json[DepartmentKey.type].string else { return nil }
		
		self.code = code
		self.name = name
		self.shortName = shortName
		self.id = id
		self.type = type
	}
	
	// MARK: - Generator
	public class func generateDepartments(json: JSON) -> [Department] {
		var objects = [Department]()
		
		for (key, json) : (String, JSON) in json {
			if key == "departments" {
				if json.isArray {
					for (_, json) : (String, JSON) in json {
						if let department = Department(json: json) {
							objects.append(department)
						}
					}
				} else {
					if let department = Department(json: json) {
						objects.append(department)
					}
				}
			}
		}
		
		return objects
	}
}
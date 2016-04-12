//
//  ChatUser.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ChatUser {
	
	// MARK: - Parameters
	public let status: Int
	public let userId: String
	
	// MARK: - Init
	init?(json: JSON) {
		
		guard let userId = json["userId"].string else { return nil }
		guard let status = json["status"].int else { return nil }
		
		self.init(userId: userId, status: status)
	}
	
	init(userId: String, status: Int) {
		self.userId = userId
		self.status = status
	}
}
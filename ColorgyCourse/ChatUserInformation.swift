//
//  ChatUserInformation.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class ChatUserInformation: NSObject {
	
	// MARK: - Parameters
	// required
	public let status: Int
	public let avatarBlur2XURL: String?
	public let organizationCode: String
	public let id: String
	public let name: String
	// optional
	public let aboutConversation: String?
	public let aboutPassion: String?
	public let aboutHoroscope: String?
	public let aboutHabitancy: String?
	public let aboutExpertise: String?
	public let lastAnswer: String?
	public let lastAnsweredDate: String?
	
	override public var description: String {
		return "ChatUserInformation: {\n\tstatus -> \(status)\n\tavatarBlur2XURL -> \(avatarBlur2XURL)\n\torganizationCode -> \(organizationCode)\n\tid -> \(id)\n\tname -> \(name)\n\taboutConversation -> \(aboutConversation)\n\taboutPassion -> \(aboutPassion)\n\taboutHoroscope -> \(aboutHoroscope)\n\taboutHabitancy -> \(aboutHabitancy)\n\taboutExpertise -> \(aboutExpertise)\n\tlastAnswer -> \(lastAnswer)\n\tlastAnsweredDate -> \(lastAnsweredDate)\n}"
	}
	
	// MARK: - Init
	public convenience init?(json: JSON) {
		
		var _status: Int?
		var _avatarBlur2XURL: String?
		var _organizationCode: String?
		var _id: String?
		var _name: String?
		var _aboutConversation: String?
		var _aboutPassion: String?
		var _aboutHoroscope: String?
		var _aboutHabitancy: String?
		var _aboutExpertise: String?
		var _lastAnswer: String?
		var _lastAnsweredDate: String?
		
		_status = json["status"].number?.integerValue
		_avatarBlur2XURL = json["avatar_blur_2x_url"].string
		_organizationCode = json["organization_code"].string
		_id = json["id"].string
		_name = json["name"].string
		_aboutConversation = json["about"]["conversation"].string
		_aboutPassion = json["about"]["passion"].string
		_aboutHoroscope = json["about"]["horoscope"].string
		_aboutHabitancy = json["about"]["habitancy"].string
		_aboutExpertise = json["about"]["expertise"].string
		_lastAnswer = json["lastAnswer"].string
		_lastAnsweredDate = json["lastAnsweredDate"].string
		
		self.init(status: _status, avatarBlur2XURL: _avatarBlur2XURL, organizationCode: _organizationCode, id: _id, name: _name,aboutConversation: _aboutConversation, aboutPassion: _aboutPassion, aboutHoroscope: _aboutHoroscope, aboutHabitancy: _aboutHabitancy, aboutExpertise: _aboutExpertise, lastAnswer: _lastAnswer, lastAnsweredDate: _lastAnsweredDate)
	}
	
	private init?(status: Int?, avatarBlur2XURL: String?, organizationCode: String?, id: String?, name: String?, aboutConversation: String?, aboutPassion: String?, aboutHoroscope: String?, aboutHabitancy: String?, aboutExpertise: String?, lastAnswer: String?, lastAnsweredDate: String?) {

		// required
		guard status != nil else { return nil }
		guard id != nil else { return nil }
		guard organizationCode != nil else { return nil }
		guard name != nil else { return nil }
		
		self.status = status!
		self.id = id!
		self.organizationCode = organizationCode!
		self.name = name!
		self.avatarBlur2XURL = avatarBlur2XURL
		
		// optional
		self.aboutConversation = aboutConversation
		self.aboutPassion = aboutPassion
		self.aboutHoroscope = aboutHoroscope
		self.aboutHabitancy = aboutHabitancy
		self.aboutExpertise = aboutExpertise
		self.lastAnswer = lastAnswer
		self.lastAnsweredDate = lastAnsweredDate
		
		super.init()
	}
}
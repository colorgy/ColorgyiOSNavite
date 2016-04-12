//
//  Chatroom.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class Chatroom : NSObject {
	
	// MARK: - Paramters
	public let chatroomId: String
	public let socketId: String
	public let totalMessageLength: Int
	public let chatProgress: Int
	public let moreMessage: Bool
	public let targetAlias: String?
	public var othersNickName: String? {
		get {
			return targetAlias
		}
	}
	public let targetImage: String?
	public var othersProfileImage: String? {
		get {
			return targetImage
		}
	}
	
	override public var description: String {
		return "Chatroom: {\n\tchatroomId -> \(chatroomId)\n\tsocketId -> \(socketId)\n\ttotalMessageLength -> \(totalMessageLength)\n\tchatProgress -> \(chatProgress)\n\tmoreMessage -> \(moreMessage)\n\ttargetAlias -> \(targetAlias)\n\tothersNickName -> \(othersNickName)\n\ttargetImage -> \(targetImage)\n\tothersProfileImage -> \(othersProfileImage)\n}"
	}
	
	// MARK: - Init
	convenience init?(json: JSON) {
		
		var _chatroomId: String?
		var _socketId: String?
		var _totalMessageLength: Int?
		var _chatProgress: Int?
		var _moreMessage: Bool?
		var _targetAlias: String?
		var _targetImage: String?
		
		for (_, json) : (String, JSON) in json {
			let result = json["body"]["result"]
			_chatroomId = result["chatroomId"].string
			_socketId = result["socketId"].string
			_totalMessageLength = result["totalMessageLength"].int
			_chatProgress = result["chatProgress"].int
			_moreMessage = result["moreMessage"].bool
			_targetAlias = result["targetAlias"].string
			_targetImage = result["targetImage"].string
		}
		
		self.init(chatroomId: _chatroomId, socketId: _socketId, totalMessageLength: _totalMessageLength, chatProgress: _chatProgress, moreMessage: _moreMessage, targetAlias: _targetAlias, targetImage: _targetImage)
	}
	
	init?(chatroomId: String?, socketId: String?, totalMessageLength: Int?, chatProgress: Int?, moreMessage: Bool?, targetAlias: String?, targetImage: String?) {

		guard chatroomId != nil else { return nil }
		guard socketId != nil else { return nil }
		guard totalMessageLength != nil else { return nil }
		guard chatProgress != nil else { return nil }
		guard moreMessage != nil else { return nil }
		
		// required
		self.chatroomId = chatroomId!
		self.socketId = socketId!
		self.totalMessageLength = totalMessageLength!
		self.chatProgress = chatProgress!
		self.moreMessage = moreMessage!
		
		// optional
		self.targetAlias = targetAlias
		self.targetImage = targetImage
		
		super.init()
	}
}
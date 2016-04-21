//
//  ChatMessage.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class ChatMessage: NSObject {
	
	// MARK: - Parameters
	let id: String
	let type: String
	let content: String
	let userId: String
	let createdAt: TimeStamp
	let chatProgress: Int?
	
	// MARK: - Key
	public struct MessageType {
		static let Text = "text"
		static let Image = "image"
		static let Sticker = "sticker"
	}
	
	public struct ContentKey {
		static let Text = "text"
		static let Image = "imgSrc"
		static let Sticker = "stickerId"
	}
	
	override public var description: String { return "ChatMessage: {\n\tid => \(id)\n\ttype => \(type)\n\tcontent => \(content)\n\tuserId => \(userId)\n\tcreatedAt => \(createdAt)\n\tchatProgress => \(chatProgress)\n}" }
	
	// MARK: - Init
	convenience init?(onMessage json: JSON) {
		
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["data"]["type"].string != nil {
			type = json["data"]["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["data"]["content"]["text"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["data"]["content"]["imgSrc"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["data"]["content"]["stickerId"].string != nil {
				content = json["data"]["content"][ChatMessage.ContentKey.Sticker].string!
			}
		}
		
		if json["data"]["userId"].string != nil {
			userId = json["data"]["userId"].string!
		}
		if json["data"]["createdAt"].string != nil {
			createdAt = json["data"]["createdAt"].string!
		}
		chatProgress = json["data"]["chatProgress"].int
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: chatProgress)
	}
	
	init(fakedata id: String) {
		
		self.id = id
		self.type = ""
		self.content = ""
		self.userId = ""
		self.createdAt = TimeStamp()
		self.chatProgress = 0
		
		super.init()
	}
	
	convenience init?(onRequestingMoreMessage json: JSON) {
		
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["type"].string != nil {
			type = json["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["content"]["text"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["content"]["imgSrc"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["content"]["stickerId"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Sticker].string!
			}
		}
		
		if json["userId"].string != nil {
			userId = json["userId"].string!
		}
		if json["createdAt"].string != nil {
			createdAt = json["createdAt"].string!
		}
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: 1)
	}
	
	convenience init?(onConnect json: JSON) {
		
		var id: String?
		var type: String?
		var content: String?
		var userId: String?
		var createdAt: String?
		var chatProgress: Int?
		
		if json["id"].string != nil {
			id = json["id"].string!
		}
		if json["type"].string != nil {
			type = json["type"].string!
		}
		
		if type == ChatMessage.MessageType.Text {
			if json["content"]["text"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Text].string!
			}
		} else if type == ChatMessage.MessageType.Image {
			if json["content"]["imgSrc"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Image].string!
			}
		} else if type == ChatMessage.MessageType.Sticker {
			if json["content"]["stickerId"].string != nil {
				content = json["content"][ChatMessage.ContentKey.Sticker].string!
			}
		}
		
		if json["content"]["image"] != nil {
			print(json["content"]["image"])
		}
		if json["userId"].string != nil {
			userId = json["userId"].string!
		}
		if json["createdAt"].string != nil {
			createdAt = json["createdAt"].string!
		}
		chatProgress = json["data"]["chatProgress"].int
		
		self.init(id: id, type: type, content: content, userId: userId, createdAt: createdAt, chatProgress: chatProgress)
	}
	
	private init?(id: String?, type: String?, content: String?, userId: String?, createdAt: String?, chatProgress: Int?) {
		
		guard id != nil else { return nil }
		guard type != nil else { return nil }
		guard content != nil else { return nil }
		guard userId != nil else { return nil }
		guard createdAt != nil else { return nil }
		guard let createdAtTimeStamp = TimeStamp(timeStampString: createdAt!) else { return nil }
		
		self.id = id!
		self.type = type!
		self.content = content!
		self.userId = userId!
		self.createdAt = createdAtTimeStamp
		self.chatProgress = chatProgress
		
		super.init()
	}
	
	// MARK: - Generators
	public class func generateMessages(json: JSON) -> [ChatMessage] {
		var messages = [ChatMessage]()
		//		print(json)
		for (_, json) : (String, JSON) in json {
			if let message = ChatMessage(onMessage: json) {
				messages.append(message)
			}
		}
		return messages
	}
	
	class func generateMessagesOnRequestingMoreMessage(json: JSON) -> [ChatMessage] {
		var messages = [ChatMessage]()
		//		print(json)
		for (_, json) : (String, JSON) in json["messageList"] {
			if let message = ChatMessage(onRequestingMoreMessage: json) {
				messages.append(message)
			}
		}
		return messages
	}
	
	class func generateMessagesOnConnent(json: JSON, complete: (messages: [ChatMessage]) -> Void) {
		var messages = [ChatMessage]()
		dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
			if let (_, json) = json.first {
				//			print(json["body"]["result"]["messageList"].count)
				for (_, json) : (String, JSON) in json["body"]["result"]["messageList"] {
					if let message = ChatMessage(onConnect: json) {
						messages.append(message)
					}
				}
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					complete(messages: messages)
				})
			}
		}
	}
	
	/// Will check message's id, same message will have same id
	public override func isEqual(object: AnyObject?) -> Bool {
		if let object = object as? ChatMessage {
			return self.id == object.id
		} else {
			return false
		}
	}
}
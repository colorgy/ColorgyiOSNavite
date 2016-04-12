//
//  ColorgySocket.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SocketIOClientSwift
import SwiftyJSON

final public class ColorgySocket : NSObject {
	
	private let socket = SocketIOClient(socketURL: NSURL(string: "http://chat.colorgy.io:80")!, options: [.Log(false), .ForcePolling(true), .ConnectParams(["__sails_io_sdk_version":"0.11.0"]), .ReconnectWait(2)])
	public var chatroom: Chatroom?
	private var didConnectToSocketOnce: Bool = false
	
	func connectToServer(withParameters parameters: [String : NSObject]!, registerToChatroom: (chatroom: Chatroom) -> Void, withMessages: (messages: [ChatMessage]) -> Void, reconnectToServerWithMessages: (messages: [ChatMessage]) -> Void) {
		self.socket.on("connect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			self.socket.emitWithAck("post", parameters)(timeoutAfter: 10, callback: { (responseOnEmit) -> Void in
				
				print(responseOnEmit)
				
				dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) { () -> Void in
					if let _chatroom = Chatroom(json: JSON(responseOnEmit)) {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							self.chatroom = _chatroom
							registerToChatroom(chatroom: _chatroom)
						})
						
						if !self.didConnectToSocketOnce {
							ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), complete: { (messages) -> Void in
								// sort message with timestamp
								let sortedMessages = messages.sort({ (m1: ChatMessage, m2: ChatMessage) -> Bool in
									return m1.createdAt.timeIntervalSince1970() < m2.createdAt.timeIntervalSince1970()
								})
								// complete
								withMessages(messages: sortedMessages)
							})
							self.didConnectToSocketOnce = true
						} else {
							// reconnect to server
							ChatMessage.generateMessagesOnConnent(JSON(responseOnEmit), complete: { (messages) -> Void in
								// sort message with timestamp
								let sortedMessages = messages.sort({ (m1: ChatMessage, m2: ChatMessage) -> Bool in
									return m1.createdAt.timeIntervalSince1970() < m2.createdAt.timeIntervalSince1970()
								})
								// complete
								reconnectToServerWithMessages(messages: sortedMessages)
							})
						}
					}
				}
			})
		}
	}
	
	func onRecievingMessage(messagesRecieved messagesRecieved: (messages: [ChatMessage]) -> Void) {
		self.socket.on("chatroom") { (response, ack: SocketAckEmitter) -> Void in
			let json = JSON(response)
			if json["data"]["type"].string != "avatar" {
				let ms = ChatMessage.generateMessages(json)
				if ms.count > 0 {
					messagesRecieved(messages: ms)
				}
			}
		}
	}
	
	func onUpdateUserAvatar(updateAvatar: (user1: (id: String, imageId: String), user2: (id: String, imageId: String)) -> Void) {
		self.socket.on("chatroom") { (response, ack: SocketAckEmitter) -> Void in
			let _json = JSON(response)
			let json: JSON? = _json.isArray ? _json[0] : nil
			guard json != nil else { return }
			print(json)
			if json!["data"]["type"].string == "avatar" {
				let userId1 = json!["data"]["userId1"].string
				let userId2 = json!["data"]["userId2"].string
				let imageId1 = json!["data"]["imageId1"].string
				let imageId2 = json!["data"]["imageId2"].string
				
				guard userId1 != nil else { return }
				guard userId2 != nil else { return }
				guard imageId1 != nil else { return }
				guard imageId2 != nil else { return }
				
				let user1 = (userId1!, imageId1!)
				let user2 = (userId2!, imageId2!)
				
				updateAvatar(user1: user1, user2: user2)
			}
		}
	}
	
	func connect() {
		self.socket.connect()
	}
	
	func reconnect() {
		self.socket.reconnect()
	}
	
	func disconnect() {
		self.socket.disconnect()
	}
	
	func onError() {
		self.socket.on("error") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			print(response)
		}
	}
	
	func onDisconnect() {
		self.socket.on("disconnect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			print(response)
		}
	}
	
	func onReconnect() {
		self.socket.on("reconnect") { (response: [AnyObject], ack: SocketAckEmitter) -> Void in
			print(response)
		}
	}
	
	func sendTextMessage(message: String, withUserId userId: String) {
		if let chatroom = self.chatroom {
			let postData: [String : NSObject]! = [
				"method": "post",
				"headers": [],
				"data": [
					"chatroomId": chatroom.chatroomId,
					"userId": userId,
					"socketId": chatroom.socketId,
					"type": ChatMessage.MessageType.Text,
					"content": [ChatMessage.ContentKey.Text: message]
				],
				"url": "/chatroom/send_message"
			]
			//			print(postData)
			self.socket.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
				print(res)
			})
		}
	}
	
	func sendPhotoMessage(imageUrl: String, withUserId userId: String) {
		if let chatroom = self.chatroom {
			let postData: [String : NSObject]! = [
				"method": "post",
				"headers": [],
				"data": [
					"chatroomId": chatroom.chatroomId,
					"userId": userId,
					"socketId": chatroom.socketId,
					"type": ChatMessage.MessageType.Image,
					"content": [ChatMessage.ContentKey.Image: imageUrl]
				],
				"url": "/chatroom/send_message"
			]
			
			self.socket.emitWithAck("post", postData)(timeoutAfter: 10, callback: { (res) -> Void in
				print(res)
			})
		}
	}
}
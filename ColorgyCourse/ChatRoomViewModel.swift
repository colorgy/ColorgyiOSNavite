//
//  ChatRoomViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol ChatroomViewModelDelegate: class {
	func chatroomViewModelDidConnectToChatRoom()
	func chatroomViewModelDidRecieveMessages()
	func chatroomViewModelRecievedOneMessage()
}

final public class ChatroomViewModel {
	
	// MARK: - Parameters
	public weak var delegate: ChatroomViewModelDelegate?
	
	// MARK: Required
	/// **Need chatroomId to create chatroom**
	var chatroomId: String!
	/// **Need userId to create chatroom**
	var userId: String!
	/// **Need uuid to create chatroom**
	var uuid: String!
	/// **Need history chatroom to check blur percentage
	var historyChatroom: HistoryChatroom!
	
	// MARK: Socket data
	var chatroom: Chatroom?
	var messages: [ChatMessage]
	
	// MARK: Private
	private let socket: ColorgySocket
	
	// MARK: - Init
	public init(delegate: ChatroomViewModelDelegate?) {
		self.delegate = delegate
		self.socket = ColorgySocket()
		self.messages = [ChatMessage]()
	}
	
	// MARK: - Public Methods
	public func connectToChatRoom() {
		prepareForSocket()
	}
	
	// MARK: - Private Methods
	/// Register socket event and emit to connect to socket
	private func prepareForSocket() {
		guard let accessToken = ColorgyUserInformation.sharedInstance().userAccessToken else {
			print("fail to initialize chat room, no accesstoken")
			return
		}
		guard chatroomId != nil else {
			print("fail to initialize chat room, no chatroomId")
			return
		}
		guard userId != nil else {
			print("fail to initialize chat room, no userId")
			return
		}
		guard uuid != nil else {
			print("fail to initialize chat room, no uuid")
			return
		}
		
		// configure parameters
		let parameters = [
			"method": "post",
			"headers": [],
			"data": [
				"accessToken": accessToken,
				"chatroomId": chatroomId,
				"userId": userId,
				"uuid": uuid
			],
			"url": "/chatroom/establish_connection"
		]
		
		socket.connectToServer(withParameters: parameters, registerToChatroom: { (chatroom) in
			self.chatroom = chatroom
			}, withMessages: { (messages) in
				for m in messages {
					self.messages.append(m)
					self.delegate?.chatroomViewModelRecievedOneMessage()
				}
				self.delegate?.chatroomViewModelDidConnectToChatRoom()
			}, reconnectToServerWithMessages: { (messages) in
				print("reconnect to server")
		})
		
		socket.onRecievingMessage { (messages) in
			for m in messages {
				self.messages.append(m)
				self.delegate?.chatroomViewModelRecievedOneMessage()
			}
			self.delegate?.chatroomViewModelDidRecieveMessages()
		}
		
		socket.onUpdateUserAvatar { (user1, user2) in
			// TODO: update avatar
		}
		
		socket.connect()
	}
}
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
	var messageList: ChatMessageList
	
	// MARK: Private
	private let socket: ColorgySocket
	private let api: ColorgyChatAPI
	private var isRequestingForMoreMessage: Bool = false
	private var historyMessagesCount: Int = 0
	
	// MARK: Public 
	
	
	// MARK: - Init
	public init(delegate: ChatroomViewModelDelegate?) {
		self.delegate = delegate
		self.socket = ColorgySocket()
		self.messageList = ChatMessageList()
		self.api = ColorgyChatAPI()
	}
	
	// MARK: - Public Methods
	public func connectToChatRoom() {
		prepareForSocket()
	}
	
	public func sendTextMessage(message: String?) {
		guard let message = message else { return }
		guard let userId = userId else { return }
		socket.sendTextMessage(message, withUserId: userId)
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
					self.messageList.addMessage(m)
					self.delegate?.chatroomViewModelRecievedOneMessage()
				}
				self.historyMessagesCount = messages.count
				self.delegate?.chatroomViewModelDidConnectToChatRoom()
			}, reconnectToServerWithMessages: { (messages) in
				print("reconnect to server")
		})
		
		socket.onRecievingMessage { (messages) in
			for m in messages {
				self.messageList.addMessage(m)
				self.delegate?.chatroomViewModelRecievedOneMessage()
			}
			self.delegate?.chatroomViewModelDidRecieveMessages()
		}
		
		socket.onUpdateUserAvatar { (user1, user2) in
			// TODO: update avatar
		}
		
		socket.connect()
	}
	
	// MARK: Requesting More Message
	private func requestMoreMessage(complete: (() -> Void)?) {
		
		guard !isRequestingForMoreMessage, let chatroom = self.chatroom else {
			complete?()
			return
		}
		
		// begin requesting more mesage
		beginRequestingMoreMessage()
		
		// fire api
		api.checkUserAvailability({ (user) in
			self.api.moreMessage(user.userId, chatroom: chatroom, historyMessagesCount: self.historyMessagesCount, success: { (messages) in
				// add count from more message
				self.historyMessagesCount += messages.count
				// append messages to messageList
				messages.forEach({ (message: ChatMessage) in
					self.messageList.addMessage(message)
					self.delegate?.chatroomViewModelRecievedOneMessage()
				})
				self.finishRequestingMoreMessage()
				self.delegate?.chatroomViewModelDidRecieveMessages()
				complete?()
				}, failure: { (error, afError) in
					self.finishRequestingMoreMessage()
					complete?()
			})
			}, failure: { (error, afError) in
				self.finishRequestingMoreMessage()
				complete?()
		})
	}
	
	private func beginRequestingMoreMessage() {
		isRequestingForMoreMessage = true
	}
	
	private func finishRequestingMoreMessage() {
		isRequestingForMoreMessage = false
	}
}
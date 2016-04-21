//
//  ChatMessageList.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

class ChatMessageList {
	var messageList: [ChatMessage]
	
	init() {
		messageList = [ChatMessage]()
	}
	
	func addMessage(message:ChatMessage) {
		messageList.append(message)
	}
	
	// MARK: - Public Getter
	var count: Int {
		return messageList.count
	}
	
	// MARK: Subscript
	subscript(index: Int) -> ChatMessage {
		
		get {
			return messageList[index]
		}
		
		set {
			messageList[index] = newValue
		}
	}
}

extension ChatMessageList : SequenceType {
	typealias Generator = ChatMessageListGenerator
	
	func generate() -> Generator {
		return ChatMessageListGenerator(chatMessageList: self.messageList)
	}
}

class ChatMessageListGenerator : GeneratorType {
	typealias Element = ChatMessage
	
	var currentIndex: Int = 0
	var chatMessageList: [ChatMessage]?
	
	init(chatMessageList: [ChatMessage]) {
		self.chatMessageList = chatMessageList
	}
	
	func next() -> Element? {
		guard let list = chatMessageList else { return nil }
		
		if currentIndex < list.count {
			let element = list[currentIndex]
			currentIndex += 1
			return element
		} else {
			return nil
		}
	}
}
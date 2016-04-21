//
//  ChatMessageList.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class ChatMessageList {
	var messageList: [ChatMessage]
	
	public init() {
		messageList = [ChatMessage]()
	}
	
	public func addMessage(message:ChatMessage) {
		messageList.append(message)
	}
	
	// MARK: - Public Getter
	public var count: Int {
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
	public typealias Generator = ChatMessageListGenerator
	
	public func generate() -> Generator {
		return ChatMessageListGenerator(chatMessageList: self.messageList)
	}
}

public class ChatMessageListGenerator : GeneratorType {
	public typealias Element = ChatMessage
	
	var currentIndex: Int = 0
	var chatMessageList: [ChatMessage]?
	
	init(chatMessageList: [ChatMessage]) {
		self.chatMessageList = chatMessageList
	}
	
	public func next() -> Element? {
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
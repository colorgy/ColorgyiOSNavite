//
//  ChatRoomViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol ChatRoomViewModelDelegate: class {
	
}

final public class ChatRoomViewModel {
	
	// MARK: - Parameters
	public weak var delegate: ChatRoomViewModelDelegate?
	
	// MARK: - Init
	public init(delegate: ChatRoomViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Public Methods
	
	// MARK: - Private Methods
}
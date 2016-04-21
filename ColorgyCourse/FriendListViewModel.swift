//
//  FriendListViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol FriendListViewModelDelegate: class {
	
}

final public class FriendListViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: FriendListViewModelDelegate?
	public var historyChatrooms: [HistoryChatroom]
	public var hiList: [Hello]
	
	// MARK: - Init
	public init(delegate: FriendListViewModelDelegate?) {
		self.delegate = delegate
		self.historyChatrooms = [HistoryChatroom]()
		self.hiList = [Hello]()
	}
	
	// MARK: - Public Methods
	
	// MARK: - Private Methods
	
	
}
//
//  FriendListViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol FriendListViewModelDelegate: class {
	// reload part
	func friendListViewModelReloadHiList()
	func friendListViewModelReloadFriendList()
	func friendListViewModelFailToReloadHiList(error: ChatAPIError, afError: AFError?)
	func friendListViewModelFailToReloadFriendList(error: ChatAPIError, afError: AFError?)
}

final public class FriendListViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: FriendListViewModelDelegate?
	public private(set) var historyChatrooms: [HistoryChatroom]
	public private(set) var hiList: [Hello]
	// MARK: Private
	private let api: ColorgyChatAPI
	private var loadingFriendTimer: NSTimer?
	private let reloadTime: NSTimeInterval = 16.0
	
	// MARK: - Init
	public init(delegate: FriendListViewModelDelegate?) {
		self.delegate = delegate
		self.historyChatrooms = [HistoryChatroom]()
		self.hiList = [Hello]()
		self.api = ColorgyChatAPI()
	}
	
	// MARK: - Public Methods
	public func startLoadingFriend() {
		loadingFriendTimer = NSTimer(timeInterval: reloadTime, target: self, selector: #selector(reloadChatroom), userInfo: nil, repeats: true)
		loadingFriendTimer?.fire()
		if loadingFriendTimer != nil {
			NSRunLoop.currentRunLoop().addTimer(loadingFriendTimer!, forMode: NSRunLoopCommonModes)
		}
	}
	
	public func stopLoadingFriend() {
		loadingFriendTimer?.invalidate()
		loadingFriendTimer = nil
	}
	
	// MARK: - Private Methods
	@objc private func reloadChatroom() {
		autoreleasepool {
			reloadFriend()
			reloadHi()
		}
	}
	
	@objc private func reloadFriend() {
		api.getHistoryTarget(gender: Gender.Unspecified, page: 0, success: { (targets) in
			self.historyChatrooms = targets
			self.delegate?.friendListViewModelReloadFriendList()
			}, failure: { (error, afError) in
				self.delegate?.friendListViewModelFailToReloadFriendList(error, afError: afError)
		})
	}
	
	@objc private func reloadHi() {
		api.getHiList(success: { (hiList) in
			self.hiList = hiList
			self.delegate?.friendListViewModelReloadHiList()
			}, failure: { (error, afError) in
				self.delegate?.friendListViewModelFailToReloadHiList(error, afError: afError)
		})
	}
	
}
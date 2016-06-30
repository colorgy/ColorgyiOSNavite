//
//  NotificationSettingsViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol NotificationSettingsViewModelDelegate: class {
	
}

final public class NotificationSettingsViewModel {
	
	// MARK: - Parameters
	public weak var delegate: NotificationSettingsViewModelDelegate?
	
	// MARK: - Init
	public init(delegate: NotificationSettingsViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Methods
	public func turnCourseNotification(on: Bool) {
		print(#file, #function, #line, on)
	}
	
	public func turnRollCallNotification(on: Bool) {
		print(#file, #function, #line, on)
	}
	
	public func turnSystemNotification(on: Bool) {
		print(#file, #function, #line, on)
	}
	
	public func turnGreetingsNotification(on: Bool) {
		print(#file, #function, #line, on)
	}
}
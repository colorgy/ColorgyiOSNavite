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
		
	}
	
	public func turnRollCallNotification(on: Bool) {
		
	}
	
	public func turnSystemNotification(on: Bool) {
		
	}
	
	public func turnGreetingsNotification(on: Bool) {
		
	}
}
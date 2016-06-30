//
//  PrivacySettingsViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol PrivacySettingsViewModelDelegate: class {
	
}

final public class PrivacySettingsViewModel {
	
	// MARK: - Parameters
	public weak var delegate: PrivacySettingsViewModelDelegate?
	
	// MARK: - Init
	public init(delegate: PrivacySettingsViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Methods
	public func turnPublicPersonalPage(on: Bool) {
		print(#file, #function, #line, on)
	}
	
	public func turnPaticipateClassmatesWall(on: Bool) {
		print(#file, #function, #line, on)
	}
	
}
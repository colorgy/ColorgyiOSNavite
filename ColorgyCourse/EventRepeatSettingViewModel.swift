//
//  EventRepeatSettingViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol EventRepeatSettingViewModelDelegate: class {
	
}

final public class EventRepeatSettingViewModel {
	
	public weak var delegate: EventRepeatSettingViewModelDelegate?
	public private(set) var repeatOptions: [RepeatOption]
	
	public struct RepeatOption {
		var title: String
	}
	
	public init(delegate: EventRepeatSettingViewModelDelegate?) {
		self.delegate = delegate
		self.repeatOptions = []
		configureRepeatOptions()
	}
	
	private func configureRepeatOptions() {
		let titles = ["每天", "每週", "隔週", "每月", "每年", "永不"]
		titles.forEach({ repeatOptions.append(RepeatOption(title: $0)) })
	}
}
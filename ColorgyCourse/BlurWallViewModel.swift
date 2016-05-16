//
//  BlurWallViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol BlurWallViewModelDelegate: class {
	func blurWallViewModel(failToLoadWall error: ChatAPIError, afError: AFError?)
	func blurWallViewModel(updateWallWithGender gender: Gender, andUpdatedTargets targets: [AvailableTarget])
}

final public class BlurWallViewModel {
	
	public weak var delegate: BlurWallViewModelDelegate?
	private let chatAPI: ColorgyChatAPI
	public private(set) var unspecifiedTargets: [AvailableTarget]
	public private(set) var maleTargets: [AvailableTarget]
	public private(set) var femaleTargets: [AvailableTarget]
	
	public init(delegate: BlurWallViewModelDelegate?) {
		self.delegate = delegate
		self.chatAPI = ColorgyChatAPI()
		self.unspecifiedTargets = []
		self.maleTargets = []
		self.femaleTargets = []
	}
	
	public func loadWallWithGender(gender: Gender) {
		chatAPI.getAvailableTarget(gender: gender, page: 0, success: { (targets) in
			switch gender {
			case .Male:
				self.maleTargets = targets
			case .Female:
				self.femaleTargets = targets
			case .Unspecified:
				self.unspecifiedTargets = targets
			}
			self.delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargets: targets)
			}, failure: { (error, afError) in
				self.delegate?.blurWallViewModel(failToLoadWall: error, afError: afError)
		})
	}
}
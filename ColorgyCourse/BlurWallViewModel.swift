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
	private var currentUnspecifiedPage: Int = 0
	private var currentMalePage: Int = 0
	private var currentFemalePage: Int = 0
	
	public init(delegate: BlurWallViewModelDelegate?) {
		self.delegate = delegate
		self.chatAPI = ColorgyChatAPI()
		self.unspecifiedTargets = []
		self.maleTargets = []
		self.femaleTargets = []
	}
	
	public func loadWallWithGender(gender: Gender) {
		requestMoreTargets(gender, page: 0, success: { (targets) in
			
			self.delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargets: targets)
			}, failure: { (error, afError) in
				self.delegate?.blurWallViewModel(failToLoadWall: error, afError: afError)
		})
	}
	
	private func requestMoreTargets(gender: Gender, page: Int, success: ((targets: [AvailableTarget]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		chatAPI.getAvailableTarget(gender: gender, page: page, success: { (targets) in
			success?(targets: targets)
			}, failure: { (error, afError) in
				failure?(error: error, afError: afError)
		})
	}
	
	private func updateTargetsWith(targets: [AvailableTarget], andGender gender: Gender) {
		switch gender {
		case .Male:
			self.maleTargets = targets
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargets: <#T##[AvailableTarget]#>)
		case .Female:
			self.femaleTargets = targets
		case .Unspecified:
			self.unspecifiedTargets = targets
		}
	}
	
	
}
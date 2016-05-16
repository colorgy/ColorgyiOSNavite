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
	func blurWallViewModel(failToRequestMoreData error: ChatAPIError, afError: AFError?)
	func blurWallViewModel(updateWallWithGender gender: Gender, andUpdatedTargetList targetList: AvailableTargetList)
}

final public class BlurWallViewModel {
	
	public weak var delegate: BlurWallViewModelDelegate?
	private let chatAPI: ColorgyChatAPI
	public private(set) var unspecifiedTargets: AvailableTargetList
	public private(set) var maleTargets: AvailableTargetList
	public private(set) var femaleTargets: AvailableTargetList
	private var currentUnspecifiedPage: Int = 0
	private var currentMalePage: Int = 0
	private var currentFemalePage: Int = 0
	
	public init(delegate: BlurWallViewModelDelegate?) {
		self.delegate = delegate
		self.chatAPI = ColorgyChatAPI()
		self.unspecifiedTargets = AvailableTargetList()
		self.maleTargets = AvailableTargetList()
		self.femaleTargets = AvailableTargetList()
	}
	
	public func loadWallWithGender(gender: Gender) {
		let page = pageOfGender(gender)
		requestMoreTargets(gender, page: page, success: { (targets) in
			self.updateTargetsWith(targets, andGender: gender)
			}, failure: { (error, afError) in
				self.delegate?.blurWallViewModel(failToLoadWall: error, afError: afError)
		})
	}
	
	public func requestMoreTarget(gender: Gender) {
		let page = pageOfGender(gender)
		requestMoreTargets(gender, page: page, success: { (targets) in
			self.updateTargetsWith(targets, andGender: gender)
			}, failure: { (error, afError) in
				self.delegate?.blurWallViewModel(failToRequestMoreData: error, afError: afError)
		})
	}
	
	private func pageOfGender(gender: Gender) -> Int {
		switch gender {
		case .Male:
			return currentMalePage
		case .Female:
			return currentFemalePage
		case .Unspecified:
			return currentUnspecifiedPage
		}
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
			maleTargets.addTargets(targets)
			currentMalePage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: maleTargets)
		case .Female:
			femaleTargets.addTargets(targets)
			currentFemalePage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: femaleTargets)
		case .Unspecified:
			unspecifiedTargets.addTargets(targets)
			currentUnspecifiedPage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: unspecifiedTargets)
		}
	}
	
	
}
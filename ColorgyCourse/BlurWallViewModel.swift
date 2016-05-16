//
//  BlurWallViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol BlurWallViewModelDelegate: class {
	func blurWallViewModel(failToRequestMoreData error: ChatAPIError, afError: AFError?)
	func blurWallViewModel(updateWallWithGender gender: Gender, andUpdatedTargetList targetList: AvailableTargetList)
}

final public class BlurWallViewModel {
	
	// MARK: - Parameters
	/// Delegate of this view model
	public weak var delegate: BlurWallViewModelDelegate?
	/// Access to chat api
	private let chatAPI: ColorgyChatAPI
	/// Unspecified Target List
	public private(set) var unspecifiedTargetList: AvailableTargetList
	/// Male Target List
	public private(set) var maleTargetList: AvailableTargetList
	/// Female Target List
	public private(set) var femaleTargetList: AvailableTargetList
	private var currentUnspecifiedPage: Int = 0
	private var currentMalePage: Int = 0
	private var currentFemalePage: Int = 0
	
	// MARK: - Init
	public init(delegate: BlurWallViewModelDelegate?) {
		self.delegate = delegate
		self.chatAPI = ColorgyChatAPI()
		self.unspecifiedTargetList = AvailableTargetList()
		self.maleTargetList = AvailableTargetList()
		self.femaleTargetList = AvailableTargetList()
	}
	
	// MARK: - Request 
	/// Request more target with given gender
	public func requestMoreTarget(gender: Gender) {
		let page = pageOfGender(gender)
		requestMoreTargets(gender, page: page, success: { (targets) in
			self.updateTargetListWith(targets, andGender: gender)
			}, failure: { (error, afError) in
				self.delegate?.blurWallViewModel(failToRequestMoreData: error, afError: afError)
		})
	}
	
	/// Public access to the reload target.
	///
	/// Will reload the specified gender.
	public func reloadTarget(gender: Gender) {
		resetPageCountAndListWithGender(gender)
		requestMoreTarget(gender)
	}
	
	// MARK: - Getter
	
	/// Get the current page where we are at by the given gender
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
	
	/// reset the page to 0 and clear list by the given gender
	private func resetPageCountAndListWithGender(gender: Gender) {
		switch gender {
		case .Male:
			currentMalePage = 0
			maleTargetList.clearList()
		case .Female:
			currentFemalePage = 0
			femaleTargetList.clearList()
		case .Unspecified:
			currentUnspecifiedPage = 0
			unspecifiedTargetList.clearList()
		}
	}
	
	/// Request more targets
	/// - parameters: 
	///		- gender: male, female or unspecified
	///		- page: which page you are going to get
	private func requestMoreTargets(gender: Gender, page: Int, success: ((targets: [AvailableTarget]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		chatAPI.getAvailableTarget(gender: gender, page: page, success: { (targets) in
			success?(targets: targets)
			}, failure: { (error, afError) in
				failure?(error: error, afError: afError)
		})
	}
	
	/// Update target list by given targets and gender.
	/// Will add targets to specified gender list.
	/// After adding targets to target list, will call the delegation method and increase the page count.
	private func updateTargetListWith(targets: [AvailableTarget], andGender gender: Gender) {
		switch gender {
		case .Male:
			maleTargetList.addTargets(targets)
			currentMalePage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: maleTargetList)
		case .Female:
			femaleTargetList.addTargets(targets)
			currentFemalePage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: femaleTargetList)
		case .Unspecified:
			unspecifiedTargetList.addTargets(targets)
			currentUnspecifiedPage += 1
			delegate?.blurWallViewModel(updateWallWithGender: gender, andUpdatedTargetList: unspecifiedTargetList)
		}
	}
	
	
}
//
//  ColorgyChatContext.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public enum ColorgyChatContextError: ErrorType {
	case NoUserId
	case NoStatus
}

final public class ColorgyChatContext {
	
	// MARK: - Parameters
	// MARK: Auth
	public private(set) var userId: String?
	public private(set) var status: Int?
	// MARK: Data
	public private(set) var unspecifiedTargets: AvailableTargetList
	public private(set) var maleTargets: AvailableTargetList
	public private(set) var femaleTargets: AvailableTargetList
	private var currentUnspecifiedPage: Int = 0
	private var currentMalePage: Int = 0
	private var currentFemalePage: Int = 0
	
	/// **Singleton** of ColorgyChatContext
	///
	/// Will get the only instance of refresh center
	class func sharedInstance() -> ColorgyChatContext {
		
		struct Static {
			static let instance: ColorgyChatContext = ColorgyChatContext()
		}
		
		return Static.instance
	}
	
	private init() {
		unspecifiedTargets = AvailableTargetList()
		maleTargets = AvailableTargetList()
		femaleTargets = AvailableTargetList()
	}
	
	/// Call this at app launch
	public class func initialize() {
		promiseToCheckUserAvailability()
	}
	
	/// Will get user info on chat server
	private class func promiseToCheckUserAvailability() {
		ColorgyChatAPI().checkUserAvailability({ (user) in
			ColorgyChatContext.sharedInstance().userId = user.userId
			ColorgyChatContext.sharedInstance().status = user.status
			}, failure: { (error, afError) in
				print(error, afError)
				autoreleasepool({
					if ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState != .Revoke {
						let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
						dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
							self.promiseToCheckUserAvailability()
						})
					}
				})
		})
	}
}
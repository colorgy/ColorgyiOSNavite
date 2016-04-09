//
//  ColorgyRefreshCenter.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

/// Specify the state of refresh token
public enum RefreshTokenState {
	/// Token is currently refershing
	case Refreshing
	/// Token is currently not refershing
	case NotRefreshing
}

/// Specify the error while refreshing access & refresh token
public enum RefreshingError: ErrorType {
	/// No Refresh token currently
	case NoRefreshToken
	/// Fail to parse result from server, token will expired
	case FailToParseResponse
	/// Network curently Unavailable
	case NetworkUnavailable
	/// There is a request refreshing access token
	case TokenStillRefreshing
}

/// **ColorgyRefreshCenter**
/// 
/// This is a independent refresh center. This center works independently. Will not be affected by other api calls.
/// **Usage:**
/// 1. Start a background worker while app launch
/// 2. start a background worker while app enter foreground
/// 3. Stop background worker while app enter background
final public class ColorgyRefreshCenter {
	
	// MARK: - Parameters
	/// Refresh Center's currnet refresh state
	private var refreshState: RefreshTokenState
	
	/// background worker's timer
	private var backgroundWorker: NSTimer?
	
	// MARK: - init
	
	/// **Singleton** of ColorgyRefreshCenter
	/// 
	/// Will get the only instance of refresh center
	class func sharedInstance() -> ColorgyRefreshCenter {
		
		struct Static {
			static let instance: ColorgyRefreshCenter = ColorgyRefreshCenter()
		}
		
		return Static.instance
	}
	
	private init() {
		self.refreshState = RefreshTokenState.NotRefreshing
	}
	
	/// **Initialization**
	/// Call this during app setup
	public class func initialization() {
		// start monitoring
		AFNetworkReachabilityManager.sharedManager().startMonitoring()
	}
	
	// MARK: - Public Getter
	/// Used to get a new access token from server
	var refreshToken: String? {
		return ColorgyUserInformation.sharedInstance().userRefreshToken
	}
	
	/// Used to get a access to server, retrieve some data
	var accessToken: String? {
		return ColorgyUserInformation.sharedInstance().userAccessToken
	}
	
	/// Public refresh state getter
	var currentRefreshState: RefreshTokenState {
		get {
			return refreshState
		}
	}
	
	
	
	
	// MARK: - Reachability
	/// **Reachability**
	///
	/// Check network first before firing any api request
	///
	/// - returns: Bool - network availability
	private class func networkAvailable() -> Bool {
		let reachabilityManager = AFNetworkReachabilityManager.sharedManager()
		
		// get current status
		let networkStatus =
			(reachabilityManager.networkReachabilityStatus != .NotReachable
				|| reachabilityManager.networkReachabilityStatus != .Unknown)
		
		return networkStatus
	}
	
	/// Call this method to refresh current access token
	///
	/// This method will get called once. After calling this method, it will automatically lock itself.
	/// Firing two request will cause refresh token to get wrong.
	/// A refresh token can be use **only once**.
	public class func refreshAccessToken(success success: (() -> Void)?, failure: ((error: RefreshingError, AFError: AFError?) -> Void)?) {
		
		// check network first
		guard networkAvailable() else {
			failure?(error: RefreshingError.NetworkUnavailable, AFError: nil)
			return
		}
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		guard let refreshToken = ColorgyRefreshCenter.sharedInstance().refreshToken else {
			failure?(error: RefreshingError.NoRefreshToken, AFError: nil)
			return
		}
		
		let parameters = [
			"grant_type": "refresh_token",
			// 應用程式ID application id, in colorgy server
			"client_id": "ad2d3492de7f83f0708b5b1db0ac7041f9179f78a168171013a4458959085ba4",
			"client_secret": "d9de77450d6365ca8bd6717bbf8502dfb4a088e50962258d5d94e7f7211596a3",
			"refresh_token": refreshToken
		]
		
		// check if not refreshing
		guard ColorgyRefreshCenter.sharedInstance().currentRefreshState == .NotRefreshing else {
			failure?(error: RefreshingError.TokenStillRefreshing, AFError: nil)
			return
		}
		
		// lock
		ColorgyRefreshCenter.sharedInstance().lockWhileRefreshingToken()
		
		manager.POST("https://colorgy.io/oauth/token?", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			guard let response = response else {
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				return
			}
			// TODO: Success
			let json = JSON(response)
			guard let result = ColorgyLoginResult(json: json) else {
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				return
			}
			ColorgyUserInformation.saveLoginResult(result)
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
			success?()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				let aferror = AFError(operation: operation, error: error)
				failure?(error: RefreshingError.NetworkUnavailable, AFError: aferror)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		})
	}
	
	// MARK: - State Handler
	/// Change current refresh state
	private func lockWhileRefreshingToken() {
		self.refreshState = .Refreshing
	}
	
	/// Change current refresh state
	private func unlockWhenFinishRefreshingToken() {
		self.refreshState = .NotRefreshing
	}
	
	// MARK: - Time Remaining of A Token
	/// Will return if token is still available, and its remaining time.
	///
	///	time less than 0 means that you need to refresh the token
	public class func refreshTokenAliveTime() -> (remainingTime: Double, stillAlive: Bool) {
		
		// 7000 second is closed to 2 hrs
		let aliveTime: Double = 7000;
		
		guard let tokenCreatedDate = ColorgyUserInformation.sharedInstance().tokenCreatedDate else { return (-1, false) }
		
		let now = NSDate()
		
		let timeSinceTokenCreated = now.timeIntervalSinceDate(tokenCreatedDate)
		
		if timeSinceTokenCreated > aliveTime {
			// token might be expired
			return (aliveTime - timeSinceTokenCreated, false)
		} else {
			return (aliveTime - timeSinceTokenCreated, true)
		}
	}
	
	// MARK: - Retry Handler
	/// Call this method and will PROMISE giving you a new access token
	///
	/// BUT! If any error occur from server, such as parse result failure, server external or internal error, token will become nil
	public class func retryUntilTokenIsAvailable() {
		
		// stop when refresh token is revoke
		
		// check if token expried or not
		// if its NOT alive, refresh fired!
		guard !ColorgyRefreshCenter.refreshTokenAliveTime().stillAlive else { return }
		// dont fire is token is refreshing, only fire the request when needed.
		guard ColorgyRefreshCenter.sharedInstance().currentRefreshState == RefreshTokenState.NotRefreshing else { return }
		// fire the refresh request
		ColorgyRefreshCenter.refreshAccessToken(success: {
			print("ok")
			}, failure: { (error, AFError) in
			if error == RefreshingError.NetworkUnavailable {
				// try again
				let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 2.0))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
					ColorgyRefreshCenter.retryUntilTokenIsAvailable()
                })
			} else {
				// TODO: fatal error
			}
		})
	}
	
	/// This is refresh center's background job, put this you want in it
	///
	/// This method will check available time every 30 seconds.
	@objc private class func backgroundJob() {
		print(ColorgyRefreshCenter.refreshTokenAliveTime().remainingTime)
		if !ColorgyRefreshCenter.refreshTokenAliveTime().stillAlive {
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
		}
	}
	
	/// Start background worker
	public class func startBackgroundWorker() {
		autoreleasepool {
			ColorgyRefreshCenter.sharedInstance().backgroundWorker = NSTimer(timeInterval: 30.0, target: self, selector: #selector(ColorgyRefreshCenter.backgroundJob), userInfo: nil, repeats: true)
			ColorgyRefreshCenter.sharedInstance().backgroundWorker?.fire()
			if let worker = ColorgyRefreshCenter.sharedInstance().backgroundWorker {
				NSRunLoop.currentRunLoop().addTimer(worker, forMode: NSRunLoopCommonModes)
			}
		}
	}
	
	/// Stop background worker
	public class func stopBackgroundWorker() {
		ColorgyRefreshCenter.sharedInstance().backgroundWorker?.invalidate()
	}
	
	// MARK: - Background Hanlder
	/// Call this while entering background
	///
	/// While entering background:
	/// - Will lock the refreshing state
	/// - Will stop background worker
	public class func enterBackground() {
		// while app enter background
		// set the token to need to check available
		// lock it, check again while app enter foreground again
		ColorgyRefreshCenter.sharedInstance().lockWhileRefreshingToken()
		
		// stop background worker
		ColorgyRefreshCenter.stopBackgroundWorker()
	}
	
	/// Call this while entering foreground
	///
	/// While entering foreground:
	/// - Will **try** to unlock the refreshing state
	/// - Will start background worker
	public class func enterForeground() {
		// to see if token has expired
		if ColorgyRefreshCenter.refreshTokenAliveTime().stillAlive {
			// if available, unlock
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		} else {
			// need to refresh
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
		}
	
		// start background worker
		ColorgyRefreshCenter.startBackgroundWorker()
	}
	
	public func yo() {
		if ColorgyRefreshCenter.sharedInstance().currentRefreshState == .NotRefreshing {
			ColorgyRefreshCenter.sharedInstance().lockWhileRefreshingToken()
		} else {
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		}
	}
	
	
	
	
	
	
	
	
	
	
}
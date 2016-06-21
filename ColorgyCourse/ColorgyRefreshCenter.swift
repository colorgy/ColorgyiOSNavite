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
	/// Token is still working
	case Active
	/// Token is expired, need to refresh
	case NeedToRefresh
	/// Token is no longer working, need to login again
	case Revoke
}

/// Specify the state of refreshing job
public enum RefreshingState {
	/// Token is currently refershing
	case Refreshing
	/// Determining if need to refresh
	case NeedToCheckRefreshRequirment
	/// Token is currently not refershing
	case NotRefreshing
}

/// Specify the error while refreshing access & refresh token
public enum RefreshingError: ErrorType {
	/// No Refresh token currently
	case NoRefreshToken
	/// Fail to parse result from server, token will expired
	case FailToParseResponse
	/// Fail to connect to server
	case APIConnectionFail
	/// Network curently Unavailable
	case NetworkUnavailable
	/// There is a request refreshing access token
	case TokenStillRefreshing
}

/// **ColorgyRefreshCenter**
///
/// This is a independent refresh center. This center works independently. Will not be affected by other api calls.
///
/// **Usage:**
/// 1. Initialize while app launch
/// 2. start a background worker while app enter foreground
/// 3. Stop background worker while app enter background
final public class ColorgyRefreshCenter {
	
	// MARK: - Parameters
	/// Refresh Center's currnet refresh state
	private var refreshingState: RefreshingState
	
	/// background worker's timer
	private var backgroundWorker: NSTimer?
	
	public let rootURL: String = "http://staging.colorgy.io"
	
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
		self.refreshingState = RefreshingState.NotRefreshing
	}
	
	/// **Initialization**
	/// Call this during app setup
	public class func initialize() {
		
		// start monitoring
		AFNetworkReachabilityManager.sharedManager().startMonitoring()
		
		// lock state first
		ColorgyRefreshCenter.sharedInstance().lockToCheckRefreshRequirment()
		
		// check token if expired
		if ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState == .Active {
			// if still work, unlock api
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		} else {
			// if expired
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
		}
		
		// check if accesstoken is still working
		ColorgyRefreshCenter.checkAccessToken { (tokenStillWorking) in
			if !tokenStillWorking {
				// if not working, refresh token
				ColorgyRefreshCenter.retryUntilTokenIsAvailable()
			}
			print("token working? \(tokenStillWorking)")
		}

		// start background job
		ColorgyRefreshCenter.startBackgroundWorker()
	}
	
	// MARK: - Public Getter
	/// Used to get a new access token from server
	public var refreshToken: String? {
		return ColorgyUserInformation.sharedInstance().userRefreshToken
	}
	
	/// Used to get a access to server, retrieve some data
	public var accessToken: String? {
		return ColorgyUserInformation.sharedInstance().userAccessToken
	}
	
	/// Public refreshing state getter
	public var currentRefreshingState: RefreshingState {
		get {
			return refreshingState
		}
	}
	
	/// Public refresh token state getter
	public var currentRefreshTokenState: RefreshTokenState {
		get {
			return ColorgyRefreshCenter.refreshTokenRemainingTime().currentState
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
			"client_id": ColorgyConfig.clientID,
			"client_secret": ColorgyConfig.clientSecret,
			"refresh_token": refreshToken
		]
		
		// refreshing state must not be refreshing, other state is ok
		guard ColorgyRefreshCenter.sharedInstance().currentRefreshingState != .Refreshing else {
			failure?(error: RefreshingError.TokenStillRefreshing, AFError: nil)
			return
		}
		
		// TODO: may have 2 refresh job at a time!!!
		// TODO: 1 job at a time in afnetworking.
		// lock
		ColorgyRefreshCenter.sharedInstance().lockWhileRefreshingToken()
		
		manager.POST("\(sharedInstance().rootURL)/oauth/token?", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			guard let response = response else {
				// Fail to parse response, need to revoke refesh token
				ColorgyRefreshCenter.revokeRefreshToken()
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				return
			}
			// TODO: Success
			let json = JSON(response)
			guard let result = ColorgyLoginResult(json: json) else {
				// Fail to parse response, need to revoke refesh token
				ColorgyRefreshCenter.revokeRefreshToken()
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				return
			}
			ColorgyUserInformation.saveLoginResult(result)
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
			print("Successfully refresh access token")
			success?()
			return
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				// Fail to parse response, need to revoke refesh token
				ColorgyRefreshCenter.revokeRefreshToken()
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				let aferror = AFError(operation: operation, error: error)
				failure?(error: RefreshingError.APIConnectionFail, AFError: aferror)
				return
		})
	}
	
	// MARK: - Refreshing State Handler
	/// Change current refresh state
	private func lockToCheckRefreshRequirment() {
		self.refreshingState = .NeedToCheckRefreshRequirment
	}
	
	/// Change current refresh state
	private func lockWhileRefreshingToken() {
		self.refreshingState = .Refreshing
	}
	
	/// Change current refresh state
	private func unlockWhenFinishRefreshingToken() {
		self.refreshingState = .NotRefreshing
	}
	
	// MARK: - Refresh Token State Helper
	/// If refresh token is failure to get,
	///
	/// revoke the state of refresh token
	public class func revokeRefreshToken() {
		ColorgyUserInformation.revokeRefreshCenterTokenState()
		stopBackgroundWorker()
		// sent a global revoke notification
		NSNotificationCenter.defaultCenter().postNotificationName(ColorgyAppNotification.RefreshTokenRevokedNotification, object: nil)
	}
	
	/// After login to colorgy,
	///
	/// active the refresh token for further usage
	public class func activeRefreshToken() {
		ColorgyUserInformation.activeRefreshCenterTokenState()
		// open it while refresh token is again available
		ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		
		startBackgroundWorker()
	}
	
	// MARK: - Time Remaining of A Token
	/// Will return if token is still available, and its remaining time.
	///
	/// time less than 0 means that you need to refresh the token
	public class func refreshTokenRemainingTime() -> (remainingTime: Double, currentState: RefreshTokenState) {
		
		// 172800 seconds is 2 days
		// 172000 second is closed to 2 days
		let aliveTime: Double = 172000;
		
		// make sure refresh token is not revoked
		guard ColorgyUserInformation.sharedInstance().refreshTokenState != .Revoke else { return  (-1, RefreshTokenState.Revoke) }
		
		// make sure refresh token has a created date
		guard let tokenCreatedDate = ColorgyUserInformation.sharedInstance().tokenCreatedDate else { return (-1, RefreshTokenState.Revoke) }
		
		let now = NSDate()
		
		let timeSinceTokenCreated = now.timeIntervalSinceDate(tokenCreatedDate)
		
		if timeSinceTokenCreated > aliveTime {
			// token might be expired
			return (aliveTime - timeSinceTokenCreated, RefreshTokenState.NeedToRefresh)
		} else {
			return (aliveTime - timeSinceTokenCreated, RefreshTokenState.Active)
		}
	}
	
	// MARK: - Retry Handler
	/// Call this method and will PROMISE giving you a new access token
	///
	/// BUT! If any error occur from server, such as parse result failure, server external or internal error, token will become nil
	public class func retryUntilTokenIsAvailable() {
		
		autoreleasepool {
			// stop when refresh token is revoke
			guard ColorgyUserInformation.sharedInstance().refreshTokenState != .Revoke else { return }
			// check if token expried or not
			// remaining time of a token must smaller than 0, expired token needs to refresh
			guard ColorgyRefreshCenter.refreshTokenRemainingTime().currentState == .NeedToRefresh else { return }
			// dont fire is token is refreshing, only fire the request when needed.
			guard ColorgyRefreshCenter.sharedInstance().currentRefreshingState != RefreshingState.Refreshing else { return }
			// fire the refresh request
			ColorgyRefreshCenter.refreshAccessToken(success: {
				print("ok")
				}, failure: { (error, AFError) in
					if error == RefreshingError.NetworkUnavailable {
						// try again
						let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))
						dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
							ColorgyRefreshCenter.retryUntilTokenIsAvailable()
						})
					} else {
						// TODO: fatal error
						// stop when refresh token is revoke
					}
			})
		}
	}
	
	/// This is refresh center's background job, put this you want in it
	///
	/// This method will check available time every 30 seconds.
	@objc private class func backgroundJob() {
		print("Refresh token remaining time:", ColorgyRefreshCenter.refreshTokenRemainingTime().remainingTime, "seconds")
		print("State:", ColorgyUserInformation.sharedInstance().refreshTokenState)
		let tokenState = ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState
		if tokenState == .NeedToRefresh {
			// if token expired
			// refresh token
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
		} else if tokenState == .Revoke {
			// if token is revoked, stop job
			ColorgyRefreshCenter.stopBackgroundWorker()
		}
	}
	
	/// Start background worker
	public class func startBackgroundWorker() {
		// First invalidate previous one
		ColorgyRefreshCenter.sharedInstance().backgroundWorker?.invalidate()
		// then create a new one
		ColorgyRefreshCenter.sharedInstance().backgroundWorker = NSTimer(timeInterval: 300, target: self, selector: #selector(ColorgyRefreshCenter.backgroundJob), userInfo: nil, repeats: true)
		ColorgyRefreshCenter.sharedInstance().backgroundWorker?.fire()
		if let worker = ColorgyRefreshCenter.sharedInstance().backgroundWorker {
			NSRunLoop.currentRunLoop().addTimer(worker, forMode: NSRunLoopCommonModes)
		}
	}
	
	/// Stop background worker
	public class func stopBackgroundWorker() {
		ColorgyRefreshCenter.sharedInstance().backgroundWorker?.invalidate()
	}
	
	/// Check access token
	private class func checkAccessToken(complete: (tokenStillWorking: Bool) -> Void) {
		// check user email api
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		guard let accessToken = ColorgyRefreshCenter.sharedInstance().accessToken else {
			complete(tokenStillWorking: false)
			return
		}
		
		let url = "\(ColorgyRefreshCenter.sharedInstance().rootURL)/api/v2/me/emails.json?access_token=\(accessToken)"
		
		manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
			complete(tokenStillWorking: true)
			}, failure: { (operaion: NSURLSessionDataTask?, error: NSError) in
				complete(tokenStillWorking: false)
		})
	}
	
	/// If you get any 401 error from server,
	///
	/// Call this method and will check access token for you,
	///
	/// Will refresh token if needed
	public class func notify401UnautherizedErrorGet() {
		checkAccessToken { (tokenStillWorking) in
			if !tokenStillWorking {
				// token no longer working
				ColorgyRefreshCenter.retryUntilTokenIsAvailable()
			}
		}
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
		ColorgyRefreshCenter.sharedInstance().lockToCheckRefreshRequirment()
		
		// stop background worker
		ColorgyRefreshCenter.stopBackgroundWorker()
	}
	
	/// Call this while entering foreground
	///
	/// While entering foreground:
	/// - Will **try** to unlock the refreshing state
	/// - Will start background worker
	public class func enterForeground() {
		
		// check if accesstoken is still working
		ColorgyRefreshCenter.checkAccessToken { (tokenStillWorking) in
			print(tokenStillWorking)
			if !tokenStillWorking {
				// if not working, refresh token
				ColorgyRefreshCenter.retryUntilTokenIsAvailable()
			}
		}
		
		// to see if token has expired
		if ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState == .Active {
			// if available, unlock
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		} else {
			// need to refresh
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
		}
  
		// start background worker
		ColorgyRefreshCenter.startBackgroundWorker()
	}
	
	
	
	
	
	
	
	
	
	
	
}
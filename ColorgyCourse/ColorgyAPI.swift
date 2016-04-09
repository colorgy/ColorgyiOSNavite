//
//  ColorgyAPIHandler.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

/// API error while calling me api
public enum APIMeError: ErrorType {
	/// Cannot parse the result from server
	case FailToParseResult
	/// Network is currently unavailable
	case NetworkUnavailable
	/// No access token
	case NoAccessToken
	/// URL is invalid
	case InvalidURLString
	/// Fail to get api from server, parse AFError to get the detail description
	case APIConnectionFailure
	/// API currently unavailable, refresh token might be refreshing...
	case APIUnavailable
}

/// API error while calling api
public enum APIError: ErrorType {
	/// Cannot parse the result from server
	case FailToParseResult
	/// Network is currently unavailable
	case NetworkUnavailable
	/// No access token
	case NoAccessToken
	/// URL is invalid
	case InvalidURLString
	/// Fail to get api from server, parse AFError to get the detail description
	case APIConnectionFailure
	/// API currently unavailable, refresh token might be refreshing...
	case APIUnavailable
	/// User has no organization code
	case NoOrganization
}

/// **Colorgy API**
/// 
/// All request to server starts here.
/// 
/// You must initialize everytime you want to use it. You can cancel all operation separately, since you have separate manager.
final public class ColorgyAPI : NSObject {
	
	// MARK: - Parameters
	/// You can cancel all operation with this manager
	public let manager: AFHTTPSessionManager
	
	// MARK: - Init
	/// initializer
	override public init() {
		manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		super.init()
	}
	
	/// public access token getter
	private var accessToken: String? {
		get {
			return ColorgyRefreshCenter.sharedInstance().accessToken
		}
	}
	
	// MARK: - Helper
	/// This Method will help you to wrap qos queue for you
	private func qosBlock(block: () -> Void) {
		let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
		dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
			block()
		})
	}
	
	/// This Method will help you to wrap qos queue for you
	private func mainBlock(block: () -> Void) {
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			block()
		})
	}
	
	/// This depends on Refresh center
	/// Will lock if token is refreshing
	/// - returns:
	///   - True: If token is available
	///   - False: Time out, no network might cause this problem
	private func allowAPIAccessing() -> Bool {
		
		var retryCounter = 5
		
		while retryCounter > 0 {
			// decrease counter
			retryCounter -= 1
			// check if available
			if ColorgyRefreshCenter.sharedInstance().currentRefreshState == RefreshTokenState.NotRefreshing {
				// if token is not refreshing, allow api accessing
				return true
			}
			// wait for 3 seconds
			NSThread.sleepForTimeInterval(3.0)
		}
		
		return false
	}
	
	/// **Reachability**
	///
	/// Check network first before firing any api request
	///
	/// - returns: Bool - network availability
	private func networkAvailable() -> Bool {
		let reachabilityManager = AFNetworkReachabilityManager.sharedManager()
		
		// get current status
		let networkStatus =
			(reachabilityManager.networkReachabilityStatus != .NotReachable
				|| reachabilityManager.networkReachabilityStatus != .Unknown)
		
		return networkStatus
	}
	
	// MARK: - User API
	
	/// You can simply get Me API using this.
	///
	/// - returns:
	///   - result: ColorgyAPIMeResult?, you can store it.
	///   - error: An error if you got one, then handle it.
	public func me(success: ((result: ColorgyAPIMeResult) -> Void)?, failure: ((error: APIMeError, AFError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				failure?(error: APIMeError.NetworkUnavailable, AFError: nil)
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIMeError.APIUnavailable, AFError: nil)
				})
				return
			}
			
			print("getting me API")
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIMeError.NoAccessToken, AFError: nil)
				})
				return
			}
			let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIMeError.InvalidURLString, AFError: nil)
				})
				return
			}
			
			// then start job
			self.manager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
				// will pass in a json, then generate a result
				guard let response = response else {
					self.mainBlock({
						failure?(error: APIMeError.FailToParseResult, AFError: nil)
					})
					return
				}
				let json = JSON(response)
				guard let result = ColorgyAPIMeResult(json: json) else {
					self.mainBlock({
						failure?(error: APIMeError.FailToParseResult, AFError: nil)
					})
					return
				}
				// store
				ColorgyUserInformation.saveAPIMeResult(result)
				// success
				self.mainBlock({
					success?(result: result)
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
					// then handle response
					let aferror = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIMeError.APIConnectionFailure, AFError: aferror)
					})
			})
		}
	}
	
	// MARK: - course API
	/// Get courses from server.
	///
	/// - parameters:
	///   - count: Pass the count you want to download. nil~ for all course.
	/// - returns: A parsed [CourseRawDataObject]? array. Might be nil or 0 element.
	public func getSchoolCourseData(count: Int?, year: Int, term: Int, success: ((courses: [Course]) -> Void)?, process: (() -> Void)?, failure: ((error: APIError, AFError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, AFError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, AFError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, AFError: nil)
				})
				return
			}
			
			guard let organization = ColorgyUserInformation.sharedInstance().userOrganization else {
				self.mainBlock({
					failure?(error: APIError.NoOrganization, AFError: nil)
				})
				return
			}
			
			let coursesCount = count ?? 20000
			let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, AFError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					let rawData = CourseRawDataObject.generateObjects(json)
					let courses = Course.generateCourseArrayWithRawDataObjects(rawData)
					self.mainBlock({
						success?(courses: courses)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, AFError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, AFError: nil)
					})
					return
			})
		}
	}
}
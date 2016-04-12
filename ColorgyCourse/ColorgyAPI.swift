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
	/// Internal preparation fail, might be uuid generate fail or something, chech inside
	case InternalPreparationFail
}

public protocol ColorgyAPIDelegate : class {
	func colorgyAPI(operationCountUpdated operationCount: Int)
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
	private var pointer: UnsafeMutablePointer<Void> = nil
	public weak var delegate: ColorgyAPIDelegate?
	
	// MARK: - Init
	/// initializer
	override public init() {
		manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		super.init()
		manager.operationQueue.addObserver(self, forKeyPath: "operationCount", options: [], context: pointer)
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
	
	// MARK: - Operation Count Observer
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let keyPath = keyPath, let object = object {
			if object.isEqual(self.manager.operationQueue) && keyPath == "operationCount" {
				delegate?.colorgyAPI(operationCountUpdated: self.manager.operationQueue.operationCount)
			} else {
				super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			}
		}
		else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	
	// MARK: - User API
	
	/// You can simply get Me API using this.
	///
	/// **Causion** Will save result for you
	/// - returns:
	///   - result: ColorgyAPIMeResult?, you can store it.
	///   - error: An error if you got one, then handle it.
	public func me(success success: ((result: ColorgyAPIMeResult) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				failure?(error: APIError.NetworkUnavailable, afError: nil)
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			print("getting me API")
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			// then start job
			self.manager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
				// will pass in a json, then generate a result
				guard let response = response else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
					return
				}
				let json = JSON(response)
				guard let result = ColorgyAPIMeResult(json: json) else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
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
						failure?(error: APIError.APIConnectionFailure, afError: aferror)
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
	public func getSchoolCourseData(count: Int?, year: Int, term: Int, success: ((courses: [Course]) -> Void)?, process: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			guard let organization = ColorgyUserInformation.sharedInstance().userOrganization else {
				self.mainBlock({
					failure?(error: APIError.NoOrganization, afError: nil)
				})
				return
			}
			
			let coursesCount = count ?? 20000
			let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
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
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let aferror = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: aferror)
					})
					return
			})
		}
	}
	
	/// Get school/orgazination period data
	///
	/// You can get school period data
	public func getSchoolPeriodData(organization: String, success: ((periodData: [PeriodRawData]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock { 
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/period_data.json?access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					let rawData = PeriodRawData.generatePeiordRawData(json) ?? PeriodRawData.generateFakePeiordRawData(nil)
					self.mainBlock({ 
						success?(periodData: rawData)
					})
				} else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let aferror = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: aferror)
					})
			})
		}
	}
	
	// MARK: - Push Notification Device Token
	/// Push notification device token to server. Use PUT, will update if already exist, will create if not exist.
	public func PUTPushNotificationDeviceToken(success success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}

			
			// pushing device token to server needs a unique uuid,
			// so must generate one
			// will return true if nothing is wrong when generating uuid
			guard ColorgyUserInformation.generateDeviceUUID() else {
				self.mainBlock({
					failure?(error: APIError.InternalPreparationFail, afError: nil)
				})
				return
			}
			
			// prevent not getting uuid
			guard let uuid = ColorgyUserInformation.sharedInstance().deviceUUID else {
				self.mainBlock({
					failure?(error: APIError.InternalPreparationFail, afError: nil)
				})
				return
			}
			
			// get push notificatoin token 
			guard let token = ColorgyUserInformation.sharedInstance().pushNotificationToken else {
				self.mainBlock({
					failure?(error: APIError.InternalPreparationFail, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			// need uuid, device name, device type, device token
			let parameters = [
				"user_device": [
					"type": "ios",
					"name": UIDevice.currentDevice().name,
					"device_id": "\(token)"
				]
			]

			self.manager.PUT(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: afError)
					})
					return
					
			})
		}
	}
	
	/// Get all the token stored in server
	public func GETAllStoredDeviceToken(success success: ((tokens: [(name: String, uuid: String)]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/me/devices.json?access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					// initialize a cache to store tokens
					var storedTokens = [(name: String, uuid: String)]()
					for (_, json) : (String, JSON) in json {
						if let name = json["name"].string, let uuid = json["uuid"].string {
							storedTokens.append((name, uuid))
						}
					}
					self.mainBlock({
						success?(tokens: storedTokens)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	/// Delete a uuid and push notification token set.
	public func DELETEPushNotificationDeviceUUID(uuid: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	
	// MARK: - Course API
	/// Get a specific course raw data object using course code.
	/// Will just return a single data object.
	/// Not an array
	///
	/// - parameters: 
	///		- code: A specific course code.
	/// - returns: courseRawDataObject: A single CourseRawDataObject?, might be nil.
	public func GETCourseRawObjectWithCourseCode(code: String, success: ((object: CourseRawDataObject?) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			// check user's organization
			guard let school = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.mainBlock({
					failure?(error: APIError.NoOrganization, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/courses/\(code).json?access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					let rawDataObject = CourseRawDataObject(json: json)
					self.mainBlock({
						success?(object: rawDataObject)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	/// Get users who enroll in specific course.
	/// Server will return a UserCourseObject.
	///
	/// - parameters: 
	///		- code: A course code.
	/// - returns: userCourseObjects: A [UserCourseObject]? array, might be nil.
	public func GETStudentsInSpecificCourse(code: String, success: ((relationships: [StudnetAndCourseRelationshipObject]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				self.mainBlock({
					failure?(error: APIError.NetworkUnavailable, afError: nil)
				})
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: APIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.mainBlock({
					failure?(error: APIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Bcourse_code%5D=\(code)&&&&&&&&&access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.mainBlock({
					failure?(error: APIError.InvalidURLString, afError: nil)
				})
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					let relationships = StudnetAndCourseRelationshipObject.generateRelationObjects(json)
					self.mainBlock({
						success?(relationships: relationships)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: APIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.mainBlock({
						failure?(error: APIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	
	
	
	
	
	
	
	
}
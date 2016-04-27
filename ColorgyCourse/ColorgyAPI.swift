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
	/// User has no user id
	case NoUserId
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
	public override init() {
		manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		super.init()
		manager.operationQueue.addObserver(self, forKeyPath: "operationCount", options: [], context: pointer)
	}
	
	// MARK: - Helper
	/// private access token getter
	private var accessToken: String? {
		get {
			return ColorgyRefreshCenter.sharedInstance().accessToken
		}
	}
	
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
	
	/// This method will help you handle failure callback
	private func handleFailure(failure: ((error: APIError, afError: AFError?) -> Void)?, error: APIError, afError: AFError?) {
		mainBlock {
			failure?(error: error, afError: afError)
		}
		return
	}
	
	/// Handle network unavailable condition
	private func handleNetworkUnavailable(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.NetworkUnavailable, afError: nil)
	}
	
	/// Handle fail to parse result condition
	private func handleFailToParseResult(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.FailToParseResult, afError: nil)
	}
	
	/// Handle no access token condition
	private func handleNoAccessToken(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.NoAccessToken, afError: nil)
	}
	
	/// Handle invalid url condition
	private func handleInvalidURL(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.InvalidURLString, afError: nil)
	}
	
	/// Handle API connection failure condition
	private func handleAPIConnectionFailure(failure: ((error: APIError, afError: AFError?) -> Void)?, afError: AFError?) {
		handleFailure(failure, error: APIError.APIConnectionFailure, afError: afError)
	}
	
	/// Handle API unavailable condition
	private func handleAPIUnavailable(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.APIUnavailable, afError: nil)
	}
	
	/// Handle no organization condition
	private func handleNoOrganization(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.NoOrganization, afError: nil)
	}
	
	/// Handle no user id condition
	private func handleNoUserId(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.NoUserId, afError: nil)
	}
	
	/// Handle internal preparation failure condition
	private func handleInternalPreparationFailure(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.InternalPreparationFail, afError: nil)
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
			if ColorgyRefreshCenter.sharedInstance().currentRefreshingState == RefreshingState.NotRefreshing {
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
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			// then start job
			self.manager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
				// will pass in a json, then generate a result
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				guard let result = ColorgyAPIMeResult(json: json) else {
					self.handleFailToParseResult(failure)
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
					self.handleAPIConnectionFailure(failure, afError: aferror)
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
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			guard let organization = ColorgyUserInformation.sharedInstance().userOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			
			let coursesCount = count ?? 20000
			let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/courses.json?per_page=\(String(coursesCount))&&&filter%5Byear%5D=\(year)&filter%5Bterm%5D=\(term)&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&access_token=\(accesstoken)"
			
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let rawData = CourseRawDataObject.generateObjects(json)
				let courses = Course.generateCourseArrayWithRawDataObjects(rawData)
				self.mainBlock({
					success?(courses: courses)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let aferror = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: aferror)
			})
		}
	}
	
	/// Get school/orgazination period data
	///
	/// You can get school period data
	public func getSchoolPeriodData(organization: String, success: ((periodData: [PeriodRawData]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/\(organization.lowercaseString)/period_data.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let rawData = PeriodRawData.generatePeiordRawData(json) ?? PeriodRawData.generateFakePeiordRawData(nil)
				self.mainBlock({
					success?(periodData: rawData)
				})
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
	public func putPushNotificationDeviceToken(success success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			
			// pushing device token to server needs a unique uuid,
			// so must generate one
			// will return true if nothing is wrong when generating uuid
			guard ColorgyUserInformation.generateDeviceUUID() else {
				self.handleInternalPreparationFailure(failure)
				return
			}
			// prevent not getting uuid
			guard let uuid = ColorgyUserInformation.sharedInstance().deviceUUID else {
				self.handleInternalPreparationFailure(failure)
				return
			}
			// get push notificatoin token
			guard let token = ColorgyUserInformation.sharedInstance().pushNotificationToken else {
				self.handleInternalPreparationFailure(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
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
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
					
			})
		}
	}
	
	/// Get all the token stored in server
	public func getAllStoredDeviceToken(success success: ((tokens: [(name: String, uuid: String)]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/devices.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
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
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Delete a uuid and push notification token set.
	public func deletePushNotificationDeviceUUID(uuid: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/devices/\(uuid).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
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
	///   - code: A specific course code.
	/// - returns: courseRawDataObject: A single CourseRawDataObject?, might be nil.
	public func getCourseRawObjectWithCourseCode(code: String, success: ((object: CourseRawDataObject) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			// check user's organization
			guard let school = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/\(school.lowercaseString)/courses/\(code).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let rawDataObject = CourseRawDataObject(json: JSON(response)) else {
					self.handleFailToParseResult(failure)
					return
				}
				self.mainBlock({
					success?(object: rawDataObject)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Get users who enroll in specific course.
	/// Server will return a UserCourseObject.
	///
	/// - parameters:
	///   - code: A course code.
	/// - returns: userCourseObjects: A [UserCourseObject]? array, might be nil.
	public func getStudentsInSpecificCourse(code: String, success: ((ownerships: [CourseOwnershipObject]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Bcourse_code%5D=\(code)&&&&&&&&&access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let ownerships = CourseOwnershipObject.generateOwnerShipObjects(json)
				self.mainBlock({
					success?(ownerships: ownerships)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	
	/// You can simply get a user info API using this.
	///
	/// - returns:
	///   - result: ColorgyAPIMeResult?, you can store it.
	///   - error: An error if you got one, then handle it.
	public func getUserInfo(userId: String, success: ((user: ColorgyAPIUserResult) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/users/\(userId).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let user = ColorgyAPIUserResult(json: JSON(response)) else {
					self.handleFailToParseResult(failure)
					return
				}
				// must success to parse user result
				self.mainBlock({
					success?(user: user)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Get self courses from server.
	///
	/// - returns: ownerships: A [CourseOwnershipObject] array
	public func getMeCourses(success success: ((ownerships: [CourseOwnershipObject]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			guard let organization = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			guard let userId = ColorgyUserInformation.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userId)&filter%5Bcourse_organization_code%5D=\(organization)&&&&&&&access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				// TODO: remove let json = JSON(XXX)
				let ownerships = CourseOwnershipObject.generateOwnerShipObjects(JSON(response))
				self.mainBlock({
					success?(ownerships: ownerships)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Get a specific courses from server.
	///
	/// If userid is not a Int string, then server will just return [ ] empty array.
	///
	/// - parameters:
	///   - userid: A specific user id
	/// - returns: ownerships: A [CourseOwnershipObject] array
	public func getUserCoursesWithUserId(userId: String, success: ((ownerships: [CourseOwnershipObject]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			guard let organization = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/user_courses.json?filter%5Buser_id%5D=\(userId)&filter%5Bcourse_organization_code%5D=\(organization)&&&&&&&access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let ownerships = CourseOwnershipObject.generateOwnerShipObjects(JSON(response))
				self.mainBlock({
					success?(ownerships: ownerships)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: Store / Delete Course on Server
	/// Store course to server
	public func storeCourseToServer(courseCode: String, year: Int, term: Int, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			guard let organization = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			guard let userId = ColorgyUserInformation.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			let uuid = "\(userId)-\(year)-\(term)-\(organization.uppercaseString)-\(courseCode)"
			let parameters = ["user_courses":
				[
					"course_code": courseCode,
					"course_organization_code": organization.uppercaseString,
					"year": year,
					"term": term
				]
			]
			let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.PUT(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Delete course on server
	public func deleteCourseOnServer(courseCode: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			//
			// get all course on server
			// deleteing a course on server needs an uuid
			// so we must get it from server
			//
			self.getMeCourses(success: { (ownerships) in
				// loop through all ownerships, check and delete here
				for ownership in ownerships where ownership.courseCode == courseCode {
					let uuid = ownership.uuid
					// prepare for delete url
					let url = "https://colorgy.io:443/api/v1/me/user_courses/\(uuid).json?access_token=\(accesstoken)"
					guard url.isValidURLString else {
						self.handleInvalidURL(failure)
						return
					}
					
					// start delete job
					self.manager.DELETE(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
						self.mainBlock({
							success?()
						})
						return
						}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
							let afError = AFError(operation: operation, error: error)
							self.handleAPIConnectionFailure(failure, afError: afError)
							return
					})
				}
				}, failure: { (error, afError) in
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: - Get Organization and Department Data
	
	/// Get available Organization on server
	public func getOrganizations(success success: ((organizations: [Organization]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/organizations.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let organizations = Organization.generateOrganizationsWithJSON(JSON(response))
				self.mainBlock({
					success?(organizations: organizations)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Get departments on server
	public func getDepartments(organization: String, success: ((departments: [Department]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/organizations/\(organization.uppercaseString).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let departments = Department.generateDepartments(JSON(response))
				self.mainBlock({
					success?(departments: departments)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: - Update User Information
	/// Update user organization, department, year
	public func updateUserOrganization(organization: String, department: String, year: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = ["user":
				[
					"unconfirmed_organization_code": organization,
					"unconfirmed_department_code": department,
					"unconfirmed_started_year": year
				]
			]
			
			self.manager.PATCH(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: - Privacy Setting
	/// Get self privacy setting
	public func getMePrivacySetting(success success: ((isTimeTablePublic: Bool) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/user_table_settings.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
//				var isTimeTablePublic = false
//				if json.isArray {
//					if let visibility = json[0]["courses_table_visibility"].bool {
//						isTimeTablePublic = visibility
//					}
//				} else {
//					if let visibility = json["courses_table_visibility"].bool {
//						isTimeTablePublic = visibility
//					}
//				}
				// TODO: 測式這個function
				let isTimeTablePublic = (json.isArray ? json[0]["courses_table_visibility"].bool : json["courses_table_visibility"].bool) ?? false
				self.mainBlock({
					success?(isTimeTablePublic: isTimeTablePublic)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Get self privacy setting
	public func getUserPrivacySetting(userId: Int, success: ((isTimeTablePublic: Bool) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard userId > 0 else {
				self.handleFailToParseResult(failure)
				return
			}
			let url = "https://colorgy.io/api/v1/user_table_settings/\(userId).json"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				// TODO: 測式這個function
				let isTimeTablePublic = (json.isArray ? json[0]["courses_table_visibility"].bool : json["courses_table_visibility"].bool) ?? false
				self.mainBlock({
					success?(isTimeTablePublic: isTimeTablePublic)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// PATCH privacy setting
	public func patchMEPrivacySetting(turnIt on: Bool, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			guard let userId = ColorgyUserInformation.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/user_table_settings/\(userId).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"user_table_settings": [
					"courses_table_visibility": on
				]
			]
			
			self.manager.PATCH(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: - Report
	/// Post a feedback to server
	public func postFeedbackToServer(userEmail: String, feedbackType: String, feedbackDescription: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/user_app_feedbacks.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let osVersion = NSProcessInfo.processInfo().operatingSystemVersion
			let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
			let parameters = ["user_app_feedbacks":
				[
					"user_email": userEmail,
					"type": feedbackType,
					"description": feedbackDescription,
					"device_type": "ios",
					"device_manufacturer": "Apple",
					"device_os_verison": "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)",
					"app_verison": appVersion ?? "unknown version"
				]
			]
			
			self.manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	
	/// Post a new to server
	public func postNewEmailToServer(email: String, success: ((emails: [(id: Int, email: String)]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/emails.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = ["user_email":
				[
					"email": email
				]
			]
			
			self.manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				print(json)
				var emails = [(id: Int, email: String)]()
				if let id = json["id"].int, let email = json["email"].string {
					emails.append((id, email))
				}
				self.mainBlock({
					success?(emails: emails)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// get self emails on server
	public func getMeEmailsOnServer(success: ((emails: [(id: Int, email: String)]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me/emails.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				print(json)
				var emails = [(id: Int, email: String)]()
				for (_, json) in json {
					if let id = json["id"].int, let email = json["email"].string {
						emails.append((id, email))
					}
				}
				self.mainBlock({
					success?(emails: emails)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Update user iamge
	public func patchUserImage(avatar: String, avatar_crop_x: CGFloat, avatar_crop_y: CGFloat, avatar_crop_w: CGFloat, avatar_crop_h: CGFloat, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = ["user":
				[
					"avatar": avatar,
					"avatar_crop_x": Float(avatar_crop_x),
					"avatar_crop_y": Float(avatar_crop_y),
					"avatar_crop_w": Float(avatar_crop_w),
					"avatar_crop_h": Float(avatar_crop_h)
				]
			]
			
			self.manager.PATCH(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// Update user image
	public func updateUserImage(image: UIImage, cropRect: CGRect, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			
			// encode image to base64 string
			guard let base64String = image.base64String else {
				self.handleInternalPreparationFailure(failure)
				return
			}
			
			let imageString = "data:image/png;base64,\(base64String)"
			
			self.patchUserImage(imageString, avatar_crop_x: cropRect.origin.x, avatar_crop_y: cropRect.origin.y, avatar_crop_w: cropRect.size.width, avatar_crop_h: cropRect.size.height, success: {
				self.mainBlock({
					success?()
				})
				}, failure: { (error, afError) in
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	// MARK: - Register A New User
	public func registerNewUser(name: String, email: String, password: String, passwordConfirm: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			let url = "https://colorgy.io/api/v1/sign_up"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"user": [
					"name": name,
					"email": email,
					"password": password,
					"password_confirmation": passwordConfirm
				]
			]
			
			self.manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	// MARK: - Chat related API
	/// Can check which school is available to chat feature
	public func chatAvailableOrganization(organization: String, success: ((isAvailable: Bool) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "https://colorgy.io:443/api/v1/available_org/\(organization.uppercaseString).json?access_token=\(accesstoken)"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				self.mainBlock({
					success?(isAvailable: json["available"].boolValue)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
}
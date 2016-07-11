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
	/// User has no organization code
	case NoOrganization
	/// User has no user id
	case NoUserId
	/// Internal preparation fail, might be uuid generate fail or something, chech inside
	case InternalPreparationFail
	/// Fail to download content, eg. fail to download courses list
	case FailToDownloadContent
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
	
	private let rootURL: String = "\(ColorgyConfig.serverURL)/api/v2"
	
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
			return ColorgyUserInformation.sharedInstance().userAccessToken
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
	
	/// Handle fail to download content condition
	private func handleFailToDownloadContent(failure: ((error: APIError, afError: AFError?) -> Void)?) {
		handleFailure(failure, error: APIError.FailToDownloadContent, afError: nil)
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
	
	// MARK: - Access Token
	private func setManager(new accessToken: String) {
		manager.requestSerializer.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/me"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}

			self.setManager(new: accesstoken)
			// then start job
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
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
	
	/// Update user's organization code.
	public func updateOrganization(withCode code: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/me"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"user": [
					"unconfirmed_organization_code": code.uppercaseString
				]
			]
			
			self.setManager(new: accesstoken)
			self.manager.PATCH(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				// success
				self.mainBlock({
					success?()
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let aferror = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: aferror)
			})
		}
	}
	
	// MARK: - Register A New User
	public func registerNewUser(with email: String, phoneNumber: String, password: String, passwordConfirm: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			let url = "\(self.rootURL)/users/sign_up"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"user": [
					"email": email,
					"password": password,
					"password_confirmation": passwordConfirm,
					"unconfirmed_mobile": phoneNumber
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
			})
		}
	}
	
	// MARK: - Validate Phone
	/// Request a sms.
	/// This method will send a sms validation code to the given number.
	public func requestSMS(with number: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/me/mobile"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"mobile": number
			]
			
			self.setManager(new: accesstoken)
			print(accesstoken, #file, #function)
			
			self.manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	/// Validation mobile number with given validation code.
	public func validateMobile(with validationCode: String, success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/me/mobile_confirm"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"confirmation_token": validationCode
			]
			
			self.setManager(new: accesstoken)
			
			self.manager.PATCH(url, parameters: parameters, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				self.mainBlock({
					success?()
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	// MARK: - Organization
	
	/// Get all organization from server
	public func getOrganizations(success: ((organizations: [Organization]) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/organizations"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.setManager(new: accesstoken)
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let organizations = Organization.generateOrganizationsWithJSON(json)
				self.mainBlock({
					success?(organizations: organizations)
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	// MARK: - Calendars
	
	/// Get user's all calendars
	public func getCalendars(success: (() -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			let url = "\(self.rootURL)/me/calendars"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			self.setManager(new: accesstoken)
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				print(json)
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	// MARK: - Enroll Courses
	
	/// Get current semester's course list.
	public func getCoursesList(success: ((courseList: CourseList) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		let semester = Semester.currentSemesterAndYear()
		getCoursesList(of: semester.year, andTerm: semester.term, success: success, failure: failure)
	}
	
	/// Get a semester's course list
	public func getCoursesList(of year: Int, andTerm term: Int, success: ((courseList: CourseList) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard let accesstoken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			guard let school = ColorgyUserInformation.sharedInstance().userActualOrganization else {
				self.handleNoOrganization(failure)
				return
			}
			let url = "\(self.rootURL)/organizations/\(school)/courses"
			guard url.isValidURLString else {
				self.handleInvalidURL(failure)
				return
			}
			
			let parameters = [
				"year": year,
				"term": term
			]
			
			self.setManager(new: accesstoken)
			self.manager.GET(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				print(#function, #line, json)
				self.courses(contentOf: json["s3_url"].string, success: success, failure: failure)
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
			})
		}
	}
	
	/// Download the courses content of given url, will transform into objects.
	public func courses(contentOf url: String?, success: ((courseList: CourseList) -> Void)?, failure: ((error: APIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			handleNetworkUnavailable(failure)
			return
		}
		guard let url = url where url.isValidURLString else {
			self.handleInvalidURL(failure)
			return
		}

		qosBlock {
			autoreleasepool({
				if let coursesData = NSData(contentsOfURL: url.url!) {
					let json = JSON(data: coursesData)
					let courses = Course.generateCourses(with: json)
					let courseList = CourseList()
					courseList.add(courses)
					self.mainBlock({ 
						success?(courseList: courseList)
					})
				} else {
					self.handleFailToDownloadContent(failure)
				}
			})
		}
	}
	
	
	// MARK: - Create Courses
}
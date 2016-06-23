//
//  ColorgyLogin.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import AFNetworking
import SwiftyJSON

public enum FacebookLoginError: ErrorType {
	case CancelLoginFacebook
	case FailLoginToFacebook
}

/// Error while login to colorgy.
public enum ColorgyLoginError: ErrorType {
	case FailToParseResult
	case InvalidUsername
	case PasswordLessThan8Charater
	case InvalidURL
	case APIConnectionFailure
}

/// Login starts here
final public class ColorgyLogin {
	
	// MARK: - Parameters
	private static let rootURL: String = "\(ColorgyConfig.serverURL)/oauth/token"
	
	// MARK: - Helper
	/// This Method will help you to wrap qos queue for you
	private class func qosBlock(block: () -> Void) {
		let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
		dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
			block()
		})
	}
	
	/// This Method will help you to wrap qos queue for you
	private class func mainBlock(block: () -> Void) {
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			block()
		})
	}
	
	
	/// This method will help you handle failure condition
	private class func failureHelper(block: ((error: ColorgyLoginError, afError: AFError?) -> Void)?, error: ColorgyLoginError, afError: AFError?) {
		mainBlock { 
			block?(error: error, afError: afError)
		}
		return
	}
	
	private class func successHelper(block: ((result: ColorgyLoginResult) -> Void)?, result: ColorgyLoginResult) {
		mainBlock {
			block?(result: result)
		}
		return
	}
	
	/// Handle the response returned from afnetworking
	private class func handleResonse(response: AnyObject?, success: ((result: ColorgyLoginResult) -> Void)?, failure: ((error: ColorgyLoginError, afError: AFError?) -> Void)?) {
		guard let response = response else {
			failureHelper(failure, error: ColorgyLoginError.FailToParseResult, afError: nil)
			return
		}
		let json = JSON(response)
		guard let result = ColorgyLoginResult(json: json) else {
			failureHelper(failure, error: ColorgyLoginError.FailToParseResult, afError: nil)
			return
		}
		// store
		ColorgyUserInformation.saveLoginResult(result)
		// active refresh token
		ColorgyRefreshCenter.activeRefreshToken()
		// success
		successHelper(success, result: result)
	}
	
	// MARK: Login
	/// get Facebook Access Token
	public class func getFacebookAccessToken(success success: ((token: String) -> Void)?, failure: ((error: FacebookLoginError) -> Void)?) {
		let manager = FBSDKLoginManager()
		manager.logInWithReadPermissions(["email"], fromViewController: nil) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
			mainBlock({
				if error != nil {
					print(error.localizedDescription)
					failure?(error: FacebookLoginError.FailLoginToFacebook)
				} else if result.isCancelled {
					// canceled
					failure?(error: FacebookLoginError.CancelLoginFacebook)
				} else {
					// ok
					if let token = result?.token?.tokenString {
						success?(token: token)
					} else {
						failure?(error: FacebookLoginError.FailLoginToFacebook)
					}
				}
			})
		}
	}
	
	/// Login in to Colorgy with fb token
	public class func loginToColorgyWithFacebookToken(token: String, success: ((result: ColorgyLoginResult) -> Void)?, failure: ((error: ColorgyLoginError, afError: AFError?) -> Void)?) {
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.requestSerializer.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
		manager.responseSerializer = AFJSONResponseSerializer()
		
		let parameters = [
			"grant_type": "password",
			// 應用程式ID application id, in colorgy server
			"client_id": ColorgyConfig.clientID,
			"client_secret": ColorgyConfig.clientSecret,
			"username": "facebook:access_token",
			"password": token,
			"scope": "public account identity offline_access write"
		]
		
		let url = rootURL
		
		guard url.isValidURLString else {
			failureHelper(failure, error: ColorgyLoginError.InvalidURL, afError: nil)
			return
		}
		
		manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			handleResonse(response, success: success, failure: failure)
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				let aferror = AFError(operation: operation, error: error)
				failureHelper(failure, error: ColorgyLoginError.APIConnectionFailure, afError: aferror)
		})
	}
	
	/// Login colorgy using username and password.
	/// Username here can be email and mobile.
	public class func loginToColorgy(with username: String, password: String, success: ((result: ColorgyLoginResult) -> Void)?, failure: ((error: ColorgyLoginError, afError: AFError?) -> Void)?) {
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.requestSerializer.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
		manager.responseSerializer = AFJSONResponseSerializer()
		
		let parameters = [
			"grant_type": "password",
			"client_id": ColorgyConfig.clientID,
			"client_secret": ColorgyConfig.clientSecret,
			"username": username,
			"password": password,
			"scope": "public account identity offline_access write"
		]
		
		guard username.isValidEmail || username.isValidMobileNumber else {
			failureHelper(failure, error: ColorgyLoginError.InvalidUsername, afError: nil)
			return
		}
		guard password.characters.count >= 8 else {
			failureHelper(failure, error: ColorgyLoginError.PasswordLessThan8Charater, afError: nil)
			return
		}
		let url = rootURL
		guard url.isValidURLString else {
				failureHelper(failure, error: ColorgyLoginError.InvalidURL, afError: nil)
			return
		}
		
		manager.POST(url, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
			handleResonse(response, success: success, failure: failure)
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
				let afError = AFError(operation: operation, error: error)
				failureHelper(failure, error: ColorgyLoginError.APIConnectionFailure, afError: afError)
		})
	}
}
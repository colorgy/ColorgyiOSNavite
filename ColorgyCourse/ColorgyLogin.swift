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

public enum ColorgyFacebookLoginError: ErrorType {
	case CancelLoginFacebook
	case FailLoginToFacebook
	case FailToGenerateToken
}

public enum ColorgyLoginError: ErrorType {
	case FailToParseResult
	case NetworkError
}

/// Login starts here
final public class ColorgyLogin {
	
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
	
	// MARK: Login
	/// get Facebook Access Token
	public class func getFacebookAccessToken(success success: ((token: String) -> Void)?, failure: ((error: ColorgyFacebookLoginError) -> Void)?) {
		let manager = FBSDKLoginManager()
		manager.logInWithReadPermissions(["email"], fromViewController: nil) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
			if error != nil {
				print(error.localizedDescription)
				mainBlock({ 
					failure?(error: ColorgyFacebookLoginError.FailLoginToFacebook)
				})
			} else if result.isCancelled {
				// canceled
				mainBlock({
					failure?(error: ColorgyFacebookLoginError.CancelLoginFacebook)
				})
			} else {
				// ok
				mainBlock({
					if let token = result?.token?.tokenString {
						success?(token: token)
					} else {
						failure?(error: ColorgyFacebookLoginError.FailLoginToFacebook)
					}
				})
			}
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
			"client_id": "ad2d3492de7f83f0708b5b1db0ac7041f9179f78a168171013a4458959085ba4",
			"client_secret": "d9de77450d6365ca8bd6717bbf8502dfb4a088e50962258d5d94e7f7211596a3",
			"username": "facebook:access_token",
			"password": token,
			"scope": "public account offline_access"
		]
		
		manager.POST("https://colorgy.io/oauth/token", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			guard let response = response else {
				mainBlock({
					failure?(error: ColorgyLoginError.FailToParseResult, afError: nil)
				})
				return
			}
			let json = JSON(response)
			guard let result = ColorgyLoginResult(json: json) else {
				mainBlock({
					failure?(error: ColorgyLoginError.FailToParseResult, afError: nil)
				})
				return
			}
			// store
			ColorgyUserInformation.saveLoginResult(result)
			// success
			mainBlock({
				success?(result: result)
			})
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				mainBlock({
					let aferror = AFError(operation: operation, error: error)
					failure?(error: ColorgyLoginError.NetworkError, afError: aferror)
				})
		})
	}
}
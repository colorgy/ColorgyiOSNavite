//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFNetworking

/// Chat API error while calling api
public enum ChatAPIError: ErrorType {
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

public protocol ColorgyChatAPIDelegate: class {
	func colorgyChatAPI(operationCountUpdated: Int)
}

final public class ColorgyChatAPI: NSObject {
	
	private let serverURL = "http://chat.colorgy.io"
	
	// MARK: - Parameters
	public let manager: AFHTTPSessionManager
	private var pointer: UnsafeMutablePointer<Void> = nil
	public weak var delegate: ColorgyChatAPIDelegate?
	
	// MARK: - Init
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
				delegate?.colorgyChatAPI(self.manager.operationQueue.operationCount)
			} else {
				super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			}
		}
		else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	// MARK: - Methods
	
	///上傳聊天室照片：
	///
	///用途：單純一個end-point以供照片上傳
	///使用方式：
	///
	///1. 傳一個http post給/upload/upload_chat_image，將圖片檔案放在file這個參數內
	///2. 伺服器會回傳圖片位置到result這個參數內
	public func uploadImage(image: UIImage, success: ((result: String) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				failure?(error: ChatAPIError.NetworkUnavailable, afError: nil)
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: ChatAPIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let compressedImageData = UIImageJPEGRepresentation(image, 0.1) else {
				self.mainBlock({
					failure?(error: ChatAPIError.InternalPreparationFail, afError: nil)
				})
				return
			}
			
			self.manager.POST(self.serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData) in
				formData.appendPartWithFileData(compressedImageData, name: "file", fileName: "file", mimeType: "image/jpeg")
				}, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
					if let response = response {
						let json = JSON(response)
						if let result = json["result"].string {
							self.mainBlock({
								success?(result: result)
							})
							return
						} else {
							self.mainBlock({
								failure?(error: ChatAPIError.FailToParseResult, afError: nil)
							})
							return
						}
					} else {
						self.mainBlock({
							failure?(error: ChatAPIError.FailToParseResult, afError: nil)
						})
						return
					}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					self.mainBlock({
						let afError = AFError(operation: operation, error: error)
						failure?(error: ChatAPIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	///檢查使用者狀態：(simple test passed)
	///
	///用途：在一打開聊天功能時，第一件事就是檢查他是不是已經登入過並且認證完成，如果成功的話會回傳在聊天系統裡面的userId。若是第一次登入，也會創建一個user並且回傳id。
	///使用方式：
	///
	///1. 傳一個http post給/users/check_user_available，參數包含使用者的uuid、accessToken
	///2. 如果成功，回傳使用者的id以及status
	public func checkUserAvailability(success: ((user: ChatUser) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.mainBlock({
				failure?(error: ChatAPIError.NetworkUnavailable, afError: nil)
			})
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.mainBlock({
					failure?(error: ChatAPIError.APIUnavailable, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoAccessToken, afError: nil)
				})
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/check_user_available", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					if let user = ChatUser(json: json) {
						self.mainBlock({
							success?(user: user)
						})
						return
					} else {
						self.mainBlock({
							failure?(error: ChatAPIError.FailToParseResult, afError: nil)
						})
						return
					}
				} else {
					self.mainBlock({
						failure?(error: ChatAPIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					self.mainBlock({
						let afError = AFError(operation: operation, error: error)
						failure?(error: ChatAPIError.APIConnectionFailure, afError: afError)
					})
					return
			})
		}
	}
	
	
	
	
	
	

	
	
	
	
	
	
	
}
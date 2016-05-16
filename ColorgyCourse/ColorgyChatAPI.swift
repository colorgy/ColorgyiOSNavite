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
	/// User has no user uuid
	case NoUserUUID
	/// Internal preparation fail, might be uuid generate fail or something, chech inside
	case InternalPreparationFail
	/// **fatal error* No user id failure, need to load user id
	case NoUserId
}

public enum NameStatus: String {
	case Ok = "ok"
	case AlreadyExists = "exists"
}

public enum Gender: String {
	case Male = "male"
	case Female = "female"
	case Unspecified = "unspecified"
}

public enum HiStatus: String {
	case Pending = "pending"
	case Accepted = "accepted"
	case Rejected = "rejected"
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
	
	/// Handle FailToParseResult condition
	private func handleFailToParseResult(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.FailToParseResult, afError: nil)
		}
		return
	}
	
	/// Handle NetworkUnavailable condition
	private func handleNetworkUnavailable(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NetworkUnavailable, afError: nil)
		}
		return
	}
	
	/// Handle NoAccessToken condition
	private func handleNoAccessToken(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoAccessToken, afError: nil)
		}
		return
	}
	
	/// Handle InvalidURLString condition
	private func handleInvalidURLString(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.InvalidURLString, afError: nil)
		}
		return
	}
	
	/// Handle APIConnectionFailure condition
	private func handleAPIConnectionFailure(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?, afError: AFError?) {
		mainBlock {
			failure?(error: ChatAPIError.APIConnectionFailure, afError: afError)
		}
		return
	}
	
	/// Handle APIUnavailable condition
	private func handleAPIUnavailable(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.APIUnavailable, afError: nil)
		}
		return
	}
	
	/// Handle NoOrganization condition
	private func handleNoOrganization(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoOrganization, afError: nil)
		}
		return
	}
	
	/// Handle NoUserUUID condition
	private func handleNoUserUUID(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoUserUUID, afError: nil)
		}
		return
	}
	
	/// Handle InternalPreparationFail condition
	private func handleInternalPreparationFail(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.InternalPreparationFail, afError: nil)
		}
		return
	}
	
	/// Handle NoUserId condition
	private func handleNoUserId(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoUserId, afError: nil)
		}
		return
	}
	
	/// This depends on Refresh center
	/// Will lock if token is refreshing
	/// - returns:
	///   - True: If token is available
	///   - False: Time out, no network might cause this problem
	private func allowAPIAccessing() -> Bool {
		
		var retryCounter = 30
		
		while retryCounter > 0 {
			// decrease counter
			retryCounter -= 1
			// check if available
			if ColorgyRefreshCenter.sharedInstance().currentRefreshingState == RefreshingState.NotRefreshing {
				// if token is not refreshing, allow api accessing
				return true
			}
			// wait for 3 seconds
			NSThread.sleepForTimeInterval(0.5)
		}
		
		return false
	}
	
	/// This depends on Chat Conext
	/// Will lock if user is still not available
	/// - returns:
	///   - True: If user is available
	///   - False: Time out, no network might cause this problem
	private func chatContextUserIdAvailable() -> Bool {
		
		var retryCounter = 5
		
		while retryCounter > 0 {
			// decrease counter
			retryCounter -= 1
			// check if available
			
			if ColorgyChatContext.sharedInstance().userId != nil {
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
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let compressedImageData = UIImageJPEGRepresentation(image, 0.1) else {
				self.handleInternalPreparationFail(failure)
				return
			}
			
			self.manager.POST(self.serverURL + "/upload/upload_chat_image", parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData) in
				formData.appendPartWithFileData(compressedImageData, name: "file", fileName: "file", mimeType: "image/jpeg")
				}, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
					guard let response = response, let result = JSON(response)["result"].string else {
						self.handleFailToParseResult(failure)
						return
					}
					self.mainBlock({
						success?(result: result)
					})
					return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
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
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/check_user_available", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let user = ChatUser(json: JSON(response)) else {
					self.handleFailToParseResult(failure)
					return
				}
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
	
	///檢查使用者暱稱：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更檢查使用者暱稱
	///使用方式：
	///
	///1. 傳一個http post給/users/check_name_exists，參數包含使用者的name
	///2. 回傳json：{ result: 'ok' }或者json：{ result: 'exists' }、狀態皆為200
	public func checkNameExists(name name: String, success: ((status: NameStatus) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			let parameters = [
				"name": name
			]
			
			self.manager.POST(self.serverURL + "/users/check_name_exists", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				self.mainBlock({ 
					if json["result"].string == NameStatus.Ok.rawValue {
						success?(status: NameStatus.Ok)
					} else if json["result"].string == NameStatus.AlreadyExists.rawValue {
						success?(status: NameStatus.AlreadyExists)
					} else {
						self.handleFailToParseResult(failure)
					}
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///更新使用者名稱：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更新使用者名稱
	///使用方式：
	///
	///1. 傳一個http post給/users/update_name，參數包含使用者的name、userId、 uuid、accessToken
	public func updateName(name name: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"name": name,
				"userId": userId,
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/update_name", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///更新使用者資料：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來更新使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/update_about，參數包含使用者的about、userId、 uuid、accessToken
	public func updateAbout(horoscope horoscope: String?, school: String?, habitancy: String?, conversation: String?, passion: String?, expertise: String?, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"about": [
					"horoscope": (horoscope ?? ""), //星座
					"school": (school ?? ""), //學校
					"habitancy": (habitancy ?? ""), //居住地
					"conversation": (conversation ?? ""), //想聊的話題
					"passion": (passion ?? ""), //現在熱衷的事情
					"expertise": (expertise ?? "") //專精的事情
				],
				"userId": userId,
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/update_about", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///更新使用者大頭貼，更新使用者的驗證狀態：
	///
	///用途：因為資料庫不同，需要在上傳大頭貼後，或者使用者收到信件驗證後跟chat server確認更新的資料
	///使用方式：
	///
	///1. 傳一個http post給/users/update_from_core，參數包含使用者的 uuid、accessToken
	public func updateFromCore(success success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/update_from_core", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///取得使用者資料（是自己）：
	///
	///用途：給 app 一個 web API endpoint 來取得使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/me，參數包括使用者的 uuid, accessToken
	///2. 回傳使用者的基本資料，包括status, name, about, lastAnswer, avatar_url
	public func me(success success: ((userInformation: ChatMeUserInformation) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/me", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let userInformation = ChatMeUserInformation(json: JSON(response)) else {
					self.handleFailToParseResult(failure)
					return
				}
				self.mainBlock({
					success?(userInformation: userInformation)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///取得使用者資料（不是自己的使用者）：
	///
	///用途：給 app 一個 web API endpoint 來取得使用者的相關訊息（星座，興趣等等）
	///使用方式：
	///
	///1. 傳一個http post給/users/get_user，參數包含使用者的userId
	///2. 回傳使用者的公開詳細資料，包含使用者的status,name,about,lastAnsweredDate,lastAnswer,avatar_blur_2x_url(預設就是都是最模糊的),organization_code
	public func getUser(success success: ((userInformation: ChatUserInformation) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken
			]
			
			self.manager.POST(self.serverURL + "/users/get_user", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let userInformation = ChatUserInformation(json: JSON(response)) else {
					self.handleFailToParseResult(failure)
					return
				}
				self.mainBlock({
					success?(userInformation: userInformation)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///舉報使用者：
	///
	///用途：給 app 一個 web API endpoint 來舉報使用者
	///使用方式：
	///
	///1. 傳一個http post給/report/report_user，參數包含uuid, accessToken,  userId, targetId, type,reason
	public func reportUser(targetId targetId: String, type: String?, reason: String?, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"targetId": targetId,
				"type": type ?? "",
				"reason": reason ?? ""
			]
			
			self.manager.POST(self.serverURL + "/report/report_user", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	
	///封鎖使用者：
	///
	///用途：給 app 一個 web API endpoint 來封鎖使用者，之後在得到聊天室列表將會得不到被封鎖的人。進不去過去的聊天室，也收不到任何聊天室的訊息（單方面）。
	///使用方式：
	///
	///1. 傳一個http post給/users/block_user，參數包含uuid,accessToken, userId,targetId
	///2. 回傳200即代表已經封鎖
	public func blockUser(targetId targetId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters  = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"targetId": targetId
			]
			
			self.manager.POST(self.serverURL + "/users/block_user", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	
	///取得聊天室列表：(simple test passed)
	///
	///用途：給 app 一個 web API endpoint 來封鎖使用者，之後在得到聊天室列表將會得不到被封鎖的人。進不去過去的聊天室，也收不到任何聊天室的訊息（單方面）。
	///使用方式：
	///
	///1. 傳一個http post給/users/get_available_target，參數包含gender,uuid,accessToken,userId,page，page從零開始，0,1,2,3,4,5...一直到回傳為空陣列為止
	///2. 如果成功，回傳的資料包括id,name, about,lastAnswer,avatar_blur_2x_url,一次會回傳20個
	public func getAvailableTarget(gender gender: Gender, page: Int, success: ((targets: [AvailableTarget]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"gender": gender.rawValue,
				"page": page.stringValue
			]
			
			self.manager.POST(self.serverURL + "/users/get_available_target", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let targets = AvailableTarget.generateAvailableTarget(json)
				self.mainBlock({
					success?(targets: targets)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///取得最新問題：
	///
	///用途：取得最新問題以及最新問題的date，此處的date會用在回答問題的api call中。
	///使用方式：
	///
	///1. 傳一個http get給/questions/get_question
	///2. 成功的會會回傳最新的問題以及date參數
	public func getQuestion(success success: (((date: String?, question: String?)) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			self.manager.GET(self.serverURL + "/questions/get_question", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				self.mainBlock({
					success?((json["date"].string, json["question"].string))
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///回答問題：
	///
	///用途：回傳當日（或者最新）問題的答案給伺服器，如果不是最新會回傳錯誤。
	///使用方式：
	///
	///1. 傳一個http post給/users/answer_question，參數包含uuid,accessToken, userId,date(format:yyyymmdd),answer
	public func answerQuestion(answer answer: String, date: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"date": date,
				"answer": answer
			]
			
			self.manager.POST(self.serverURL + "/users/answer_question", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	// MARK: - Hi / Hello
	///檢查打招呼：(simple test passed)
	///
	///用途：檢查是否已經打過招呼。如果有打過回傳打招呼的結果。
	///使用方式：
	///
	///1. 傳一個http post給/hi/check_hi，參數包含的userId,targetId,uuid,accessToken
	///2. 回傳打招呼的結果，有兩種狀況可以繼續打招呼：(1) 從沒打過招呼 (2) 被拒絕可以再打一次，兩者的結果都是一樣的status 200：{ result: 'ok, you can say hi' }，若是已經(1)打過招呼然後成功過 (2)打過招呼還在等候回應，回傳status 200：{ result: 'already said hi' }
	public func checkHi(targetId targetId: String, success: ((canSayHi: Bool, whoSaidHi: String?, chatroomId: String?) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"targetId": targetId
			]
			
			self.manager.POST(self.serverURL + "/hi/check_hi", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				let chatroomId: String? = json["chatroomId"].string
				self.mainBlock({
					if json["result"].string == "already said hi" {
						// can't say hi, return false
						success?(canSayHi: false, whoSaidHi: "you already said hi", chatroomId: chatroomId)
						return
					} else if json["result"].string == "ok, you can say hi" {
						// can say hi, return true
						success?(canSayHi: true, whoSaidHi: nil, chatroomId: nil)
						return
					} else if json["result"].string == "target already said hi" {
						success?(canSayHi: false, whoSaidHi: "He/She already said hi", chatroomId: chatroomId)
						return
					} else {
						self.handleFailToParseResult(failure)
						return
					}
				})
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///打招呼：(simple test passed)
	///
	///用途：與特定的使用者打招呼，如果以打過招呼就直接進入聊天室即可。
	///使用方式：
	///
	///1. 傳一個http post給/hi/say_hi，參數包含使用者的userId,uuid, accessToken,targetId,message
	///2. 與一個陌生人打招呼
	public func sayHi(targetId targetId: String, message: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			guard userId != targetId else {
				self.handleInternalPreparationFail(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"targetId": targetId,
				"message": message
			]
			
			self.manager.POST(self.serverURL + "/hi/say_hi", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///取得打招呼列表：(simple test passed)
	///
	///用途：取得被打招呼列表
	///使用方式：
	///
	///1. 傳一個http post給/hi/get_list，參數包含使用者的userId,uuid,accessToken
	///2. 回傳被打過招呼的列表
	public func getHiList(success success: ((hiList: [Hello]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId
			]
			
			self.manager.POST(self.serverURL + "/hi/get_list", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					let hiList = Hello.generateHiList(json)
					self.mainBlock({
						success?(hiList: hiList)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: ChatAPIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	private func handleHi(suburl: String, hiId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"hiId": hiId
			]
			
			self.manager.POST(self.serverURL + "/hi/accept_hi", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///接受打招呼：(simple test passed)
	///
	///用途：接受一個打招呼
	///使用方式：
	///
	///1. 傳一個http post給/hi/accept_hi，參數包含使用者的userId,uuid, accessToken,hiId
	///2. 必須要是target才能傳送這個request，會產生一個空的聊天室，回傳status 200
	public func acceptHi(hiId hiId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		let suburl = "/hi/accept_hi"
		handleHi(suburl, hiId: hiId, success: success, failure: failure)
	}
	
	///拒絕打招呼：(simple test passed)
	///
	///用途：拒絕一個打招呼
	///使用方式：
	///
	///1. 傳一個http post給/hi/reject_hi，參數包含使用者的userId,uuid, accessToken,hiId
	///2. 必須要是target才能傳送這個request，會將一個打招呼的status更改為rejected
	public func rejectHi(hiId hiId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		let suburl = "/hi/reject_hi"
		handleHi(suburl, hiId: hiId, success: success, failure: failure)
	}
	
	// MARK: -
	public func acceptHiWithHistoryChatroomId(hiId hiId: String, success: ((chatroomId: String) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"hiId": hiId
			]
			
			self.manager.POST(self.serverURL + "/hi/accept_hi", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					if let chatroomId =  json["chatroomId"].string {
						self.mainBlock({
							success?(chatroomId: chatroomId)
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
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///檢查是否回答過最新問題：
	///
	///用途：在顯示問題之前需要先檢查是否回答過最新問題
	///使用方式：
	///
	///1. 傳一個http post給/users/check_answered_latest，參數包含uuid,accessToken,userId
	///2. 成功的會會回傳{ result: 'answered' }以及{ result: 'not answered'  }
	public func checkAnsweredLatestQuestion(success success: ((answered :Bool) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId
			]
			
			self.manager.POST(self.serverURL + "/users/check_answered_latest", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					if json["result"].string == "answered" {
						self.mainBlock({
							success?(answered: true)
						})
						return
					} else if json["result"].string == "not answered" {
						self.mainBlock({
							success?(answered: false)
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
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///取得好友列表：
	///
	///用途：給 app 一個 web API endpoint 來得到過去聊天過的使用者
	///使用方式：
	///
	///1. 傳一個http post給/users/get_history_target，參數包含gender,uuid,accessToken,userId,page，page從零開始，0,1,2,3,4,5...一直到回傳為空陣列為止
	///2. 如果成功，回傳的資料包括id,name, about,lastAnswer,avatar_blur_2x_url,一次會回傳20個
	public func getHistoryTarget(gender gender: Gender, page: Int, success: ((targets: [HistoryChatroom]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.mainBlock({
					failure?(error: ChatAPIError.NoUserId, afError: nil)
				})
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"gender": gender.rawValue,
				"page": page.stringValue
			]
			
			self.manager.POST(self.serverURL + "/users/get_history_target", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response else {
					self.handleFailToParseResult(failure)
					return
				}
				let json = JSON(response)
				var targets = HistoryChatroom.generateHistoryChatrooms(json)
				targets.sortInPlace { $0.lastContentTime.timeIntervalSince1970() > $1.lastContentTime.timeIntervalSince1970() }
				self.mainBlock({
					success?(targets: targets)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///刪除聊天室：
	///
	///用途：提供一個刪除聊天室的api，而聊天室將會從此從自己的聊天列表消失
	///使用方式：
	///
	///1. 傳一個http post給/users/remove_chatroom，參數包括：uuid,accessToken,userId,chatroomId
	///2. 若成功的話，會回傳一個{ result: success }
	public func removeChatroom(chatroomId chatroomId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		let suburl = "/users/remove_chatroom"
		handleChatroom(suburl, chatroomId: chatroomId, success: success, failure: failure)
	}
	
	private func handleChatroom(suburl: String, chatroomId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"chatroomId": chatroomId
			]
			
			self.manager.POST(self.serverURL + suburl, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response where JSON(response)["result"].string == "success" else {
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
	
	///離開聊天室：
	///
	///用途：提供一個離開聊天室的api，對方將會收到一個來自系統的訊息，而聊天室將會從此從自己的聊天列表消失
	///使用方式：
	///
	///1. 傳一個http post給/chatroom/leave_chatroom，參數包括：uuid,accessToken,userId,chatroomId
	///2. 若成功的話，會回傳一個{ result: success }
	public func leaveChatroom(chatroomId chatroomId: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		let suburl = "/chatroom/leave_chatroom"
		handleChatroom(suburl, chatroomId: chatroomId, success: success, failure: failure)
	}
	
	///更新對方稱呼：
	///
	///用途：更新對方的暱稱，並不會讓對方知道
	///使用方式：
	///
	///1. 傳一個http post給/chatroom/update_target_alias，參數包括uuid,accessToken,userId,chatroomId,alias
	///2. 若成功之後的establish connection後就會回傳對方的alias
	public func updateOthersNickName(chatroomId chatroomId: String, nickname: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"chatroomId": chatroomId,
				"alias": nickname
			]
			
			self.manager.POST(self.serverURL + "/chatroom/update_target_alias", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
	
	///得到更多聊天訊息：
	///
	///用途：取得聊天室過去的訊息
	///使用方式：
	///
	///1. 傳一個http post給/chatroom/more_message，參數包含使用者的userId, uuid,accessToken,chatroomId,從頭數過來的offset
	///2. 比如說你想要拿到第51~75則訊息，offset設定為50即可
	public func moreMessage(chatroom chatroom: Chatroom, historyMessagesCount: Int, success: ((messages: [ChatMessage]) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			print("history message count \(historyMessagesCount)")
			// get 25 messages everytime, -1 because of starting from 0
			let offset = chatroom.totalMessageLength - historyMessagesCount - 25
			print(offset)
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"chatroomId": chatroom.chatroomId,
				"offset": offset >= 0 ? offset : 0
			]
			
			self.manager.POST(self.serverURL + "/chatroom/more_message", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				if let response = response {
					let json = JSON(response)
					var ms = ChatMessage.generateMessagesOnRequestingMoreMessage(json)
					ms = ms.sort({ (m1: ChatMessage, m2: ChatMessage) -> Bool in
						return m1.createdAt.timeIntervalSince1970() > m2.createdAt.timeIntervalSince1970()
					})
					print("getting \(ms.count) messages")
					print("historyMessagesCount \(historyMessagesCount)")
					print("total length \(chatroom.totalMessageLength)")
					print("slicing")
					if (historyMessagesCount + ms.count) > chatroom.totalMessageLength {
						print("need slicing")
						let countsNeedToSlice = (historyMessagesCount + ms.count) - chatroom.totalMessageLength
						for _ in 1...countsNeedToSlice {
							ms.removeFirst()
						}
					}
					self.mainBlock({
						success?(messages: ms)
					})
					return
				} else {
					self.mainBlock({
						failure?(error: ChatAPIError.FailToParseResult, afError: nil)
					})
					return
				}
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	/// email_hints : Get data of email_hints
	public func GetEmailHints(organizationCode organizationCode: String, success: ((response: String) -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			let url = "https://colorgy.io:443/api/v1/email_hints/\(organizationCode).json"
			
			self.manager.GET(url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
				guard let response = response, let res = JSON(response)["hint"].string else {
					self.handleFailToParseResult(failure)
					return
				}
				print(res)
				print("get hint OK")
				self.mainBlock({
					success?(response: res)
				})
				return
				}, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
					let afError = AFError(operation: operation, error: error)
					self.handleAPIConnectionFailure(failure, afError: afError)
					return
			})
		}
	}
	
	///    更新使用者狀態
	///
	///    用途：給 app 一個 web API endpoint 來更新使用者狀態
	///    使用方式：
	///
	///    1. 傳一個http post給/users/update_user_status，參數包含使用者的status、 uuid、accessToken
	public func updateUserStatus(status status: String, success: (() -> Void)?, failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		
		guard networkAvailable() else {
			self.handleNetworkUnavailable(failure)
			return
		}
		
		qosBlock {
			guard self.allowAPIAccessing() else {
				self.handleAPIUnavailable(failure)
				return
			}
			
			guard self.chatContextUserIdAvailable() else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let userId = ColorgyChatContext.sharedInstance().userId else {
				self.handleNoUserId(failure)
				return
			}
			
			guard let uuid = ColorgyUserInformation.sharedInstance().userUUID else {
				self.handleNoUserUUID(failure)
				return
			}
			
			guard let accessToken = self.accessToken else {
				self.handleNoAccessToken(failure)
				return
			}
			
			let parameters = [
				"uuid": uuid,
				"accessToken": accessToken,
				"userId": userId,
				"status": status
			]
			
			self.manager.POST(self.serverURL + "/users/update_user_status", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
}
//
//  ColorgyChatAPIErrorHandler.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

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

final public class ColorgyChatAPIErrorHandler {
	
	public init() {
		
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
	
	// MARK: - Handler
	/// Handle FailToParseResult condition
	public func handleFailToParseResult(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.FailToParseResult, afError: nil)
		}
	}
	
	/// Handle NetworkUnavailable condition
	public func handleNetworkUnavailable(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NetworkUnavailable, afError: nil)
		}
	}
	
	/// Handle NoAccessToken condition
	public func handleNoAccessToken(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoAccessToken, afError: nil)
		}
	}
	
	/// Handle InvalidURLString condition
	public func handleInvalidURLString(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.InvalidURLString, afError: nil)
		}
	}
	
	/// Handle APIConnectionFailure condition
	public func handleAPIConnectionFailure(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?, afError: AFError?) {
		mainBlock {
			failure?(error: ChatAPIError.APIConnectionFailure, afError: afError)
		}
	}
	
	/// Handle APIUnavailable condition
	public func handleAPIUnavailable(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.APIUnavailable, afError: nil)
		}
	}
	
	/// Handle NoOrganization condition
	public func handleNoOrganization(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoOrganization, afError: nil)
		}
	}
	
	/// Handle NoUserUUID condition
	public func handleNoUserUUID(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoUserUUID, afError: nil)
		}
	}
	
	/// Handle InternalPreparationFail condition
	public func handleInternalPreparationFail(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.InternalPreparationFail, afError: nil)
		}
	}
	
	/// Handle NoUserId condition
	public func handleNoUserId(failure: ((error: ChatAPIError, afError: AFError?) -> Void)?) {
		mainBlock {
			failure?(error: ChatAPIError.NoUserId, afError: nil)
		}
	}
}
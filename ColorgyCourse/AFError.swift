//
//  AFError.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

/// **AFError** is used to check AFNetworking's error state code and response body
final public class AFError: NSObject {
	
	// MARK: - Parameters
	/// Status code of this error, might be 403, 401, 502.....
	public let statusCode: Int?
	/// Response body of this error
	public let responseBody: JSON?
	
	override public var description: String { return "AFError:{\n\tstatusCode: \(statusCode)\n\tresponseBody: \(responseBody)\n" }
	
	// MARK: - Init
	public init(operation: NSURLSessionDataTask?, error: NSError) {
		self.statusCode = AFNetworkingErrorParser.statusCode(operation)
		self.responseBody = AFNetworkingErrorParser.responseBody(error)
		if let statusCode = self.statusCode where statusCode == 401 {
			// 401 is not authed, tell refresh center to check the token
			ColorgyRefreshCenter.notify401UnautherizedErrorGet()
		}
	}
}
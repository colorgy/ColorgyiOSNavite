//
//  AFError.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

/// **AFError** is used to check AFNetworking's erro state code and response body
final public class AFError: NSObject {
	
	let statusCode: Int?
	let responseBody: String?
	
	override public var description: String { return "AFError:{\n\tstatusCode: \(statusCode)\n\tresponseBody: \(responseBody)\n" }
	
	init(operation: NSURLSessionDataTask?, error: NSError) {
		self.statusCode = AFNetworkingErrorParser.statusCode(operation)
		self.responseBody = AFNetworkingErrorParser.responseBody(error)
	}
}
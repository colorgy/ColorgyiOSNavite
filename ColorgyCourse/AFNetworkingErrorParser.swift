//
//  AFNetworkingErrorParser.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import AFNetworking

class AFNetworkingErrorParser {
	
	/// 可以拿到 Status Code
	class func statusCode(operation: NSURLSessionDataTask?) -> Int? {
		return (operation?.response as? NSHTTPURLResponse)?.statusCode
	}
	
	/// 可以拿到 response body
	class func responseBody(error: NSError) -> String? {
		
		guard let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
			// fail to get data
			return nil
		}
		
		// temp message
		var message = String()
		
		do {
			message = try "\(NSJSONSerialization.JSONObjectWithData(data, options: []))"
		} catch {
			return nil
		}
		
		return message
	}
}
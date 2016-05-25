//
//  AFNetworkingErrorParser.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

final public class AFNetworkingErrorParser {
	
	/// 可以拿到 Status Code
	public class func statusCode(operation: NSURLSessionDataTask?) -> Int? {
		return (operation?.response as? NSHTTPURLResponse)?.statusCode
	}
	
	/// 可以拿到 response body
	public class func responseBody(error: NSError) -> JSON? {
		
		guard let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
			// fail to get data
			return nil
		}
		
		do {
			let j = try NSJSONSerialization.JSONObjectWithData(data, options: [])
			return JSON(j)
		} catch {
			return nil
		}
	}
}
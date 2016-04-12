//
//  StringExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension String {
	
	/// To check if this is a valid url string
	var isValidURLString: Bool {
		return (NSURL(string: self) != nil)
	}
	
	/// To get a Int value from this string
	var intValue: Int? {
		return Int(self)
	}
	
	/// Encode the string, will return a utf8 encoded string.
	/// 
	/// If fail to generate a encoded string, will return a uuid string
	var uuidEncode: String {
		if let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
			return ("\(data)").stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "")
		} else {
			return NSUUID().UUIDString
		}
	}
}
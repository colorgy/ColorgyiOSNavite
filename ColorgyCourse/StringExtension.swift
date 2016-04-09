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
}
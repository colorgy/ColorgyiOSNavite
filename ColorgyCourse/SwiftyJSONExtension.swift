//
//  SwiftyJSONExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import SwiftyJSON

extension JSON {
	
	/// To check if this json is an array.
	var isArray: Bool {
		return self.type == .Array
	}
	
	/// To check if this json is an unknown type.
	var isUnknownType: Bool {
		if self.type == Type.Unknown {
			return true
		}
		return false
	}
}
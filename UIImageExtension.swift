//
//  UIImageExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension UIImage {
	
	var base64String: String? {
		return UIImagePNGRepresentation(self)?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
	}
}
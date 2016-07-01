//
//  StringExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

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
	
	/// Check if this string is an valid email string
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluateWithObject(self)
	}
	
	/// Check if this string is an valid mobile number string
	var isValidMobileNumber: Bool {
		let mobileRegex = "09\\d{8}"
		let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
		return mobileTest.evaluateWithObject(self)
	}
	
	/// Return a NSURL if the string is a valid url string
	var url: NSURL? {
		return NSURL(string: self)
	}
	
	/// Get charater at index
	func charaterAtIndex(index: Int) -> String? {
		guard index < self.characters.count else { return nil }
		let startIndex = self.startIndex.advancedBy(index)
		let range = startIndex...startIndex
		return self[range]
	}

	/// get preferred text width by given font size
	func preferredTextWidth(constraintByFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(size)])
		let constraintRect = CGSize(width: CGFloat.max, height: size)
		let boundingBox = attrString.boundingRectWithSize(constraintRect, options: .UsesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
	
	/// Get preferred text height by given width
	func preferredTextHeight(withConstrainedWidth width: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(size)])
		let constraintRect = CGSize(width: width, height: CGFloat.max)
		let boundingBox = attrString.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.height)
	}
	
	/// Get preferred text width by given height
	func preferredTextWidth(withConstrainedHeight height: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(size)])
		let constraintRect = CGSize(width: CGFloat.max, height: height)
		let boundingBox = attrString.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
	
	/// Transform string into secret dot text
	var dottedString: String {
		let count = self.characters.count
		var dottedString = ""
		for _ in 1...count {
			dottedString += "●"
		}
		return dottedString
	}
	
	
}
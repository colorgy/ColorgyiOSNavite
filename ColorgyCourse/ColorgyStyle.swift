//
//  ColorgyStyle.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

// font
extension UIFont {
	
	static var contentTextFont: UIFont {
		return UIFont.systemFontOfSize(16.0)
	}
	
	static var titleTextFont: UIFont {
		return UIFont.boldSystemFontOfSize(18.0)
	}
}

// text color

// tint color

// textfield
// label

extension UILabel {
	
	func setFontAsContentTextFont() {
		self.font = UIFont.contentTextFont
	}
	
	func setFontAsTitleTextFont() {
		self.font = UIFont.titleTextFont
	}
}

extension UITextField {
	
	func setFontAsContentTextFont() {
		self.font = UIFont.contentTextFont
	}
}

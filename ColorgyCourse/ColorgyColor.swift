//
//  ColorgyColor.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

struct ColorgyColor {
	static let MainOrange = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1)
	static let BackgroundColor = UIColor(red:0.980,  green:0.969,  blue:0.961, alpha:1)
	static let waterBlue = UIColor(red:0,  green:0.812,  blue:0.894, alpha:1)
	static let grayContentTextColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
	static let NavigationbarTitleColor = UIColor(red: 59/255.0, green: 58/255.0, blue: 59/255.0, alpha: 1)
	static let TextColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
}

extension UIColor {
	func withAlpha(alpha: CGFloat) -> UIColor {
		guard let CIColor = self.coreImageColor else { return self }
		
		let r = CIColor.red
		let g = CIColor.green
		let b = CIColor.blue
		
		return UIColor(red: r, green: g, blue: b, alpha: alpha)
	}
	
	var coreImageColor: CoreImage.CIColor? {
		return CoreImage.CIColor(color: self)
	}
}
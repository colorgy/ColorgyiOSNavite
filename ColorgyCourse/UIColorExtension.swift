//
//  UIColorExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

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
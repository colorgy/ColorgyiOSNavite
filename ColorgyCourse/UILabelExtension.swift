//
//  UILabelExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
	/// Get preferred text width according to font size.
	func preferredTextWidthConstraintByFontSize() -> CGFloat {
		guard let text = self.text else { return 0 }
		return text.preferredTextWidth(constraintByFontSize: self.font.pointSize)
	}
	
	/// Update label's width according to its font size and its text.
	func updateWidthToPreferredSizeByFontSize() {
		self.frame.size.width = self.preferredTextWidthConstraintByFontSize()
	}
}
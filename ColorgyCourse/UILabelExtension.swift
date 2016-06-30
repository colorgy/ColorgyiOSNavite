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
	func preferredTextWidthConstraintByFontSize(size: CGFloat) -> CGFloat {
		guard let text = self.text else { return 0 }
		return text.preferredTextWidth(constraintByFontSize: self.font.pointSize)
	}
}
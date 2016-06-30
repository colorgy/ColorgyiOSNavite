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
	var textWidth: CGFloat {
		guard let attrString = self.text as? NSAttributedString else { return 0 }
		let constraintRect = CGSize(width: CGFloat.max, height: self.font.pointSize)
		let boundingBox = attrString.boundingRectWithSize(constraintRect, options: .UsesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
}
//
//  NumerExtensions.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
	var DoubleValue: Double {
		return Double(self)
	}
}

extension Double {
	var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
	
	var RadianValue: Double {
		return (M_PI * self / 180.0)
	}
}

extension Int {
	var DoubleValue: Double {
		return Double(self)
	}
	
	var stringValue: String {
		return String(self)
	}
	
	var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
	
	func times(block: (index: Int) -> Void) {
		guard self >= 0 else { return }
		for index in 0..<self {
			block(index: index)
		}
	}
}
//
//  CreateEventColorCellDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol CreateEventColorCellDelegate: class {
	func createEventColorCellNeedsExpand()
	func createEventColorCell(needsCollapseWithSelectedColor color: UIColor?)
}
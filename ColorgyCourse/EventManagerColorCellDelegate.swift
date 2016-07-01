//
//  EventManagerColorCellDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

public protocol EventManagerColorCellDelegate: class {
	func eventManagerColorCellNeedsExpand()
	func eventManagerColorCell(needsCollapseWithSelectedColor color: UIColor?)
}
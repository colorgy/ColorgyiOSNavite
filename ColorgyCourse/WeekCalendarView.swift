//
//  WeekCalendarView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class WeekCalendarView: UIView {
	
	// for calendar view
	private var weekContainerView: UIScrollView!
	private var weekContentView: UIView!
	private let itemHeight: CGFloat = 54.0
	
	// for side bar
	private var sidebarContainerView: UIScrollView!
	private var sidebarContentView: UIView!
	private let sidebarWidth: CGFloat = 44.0
	
	// for header
	private var headerContainerView: UIScrollView!
	private var headerContentView: UIView!
	private let headerHeight: CGFloat = 44.0
	
	// for month
	private var monthLabel: UILabel!
	
	// MARK: - Init
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureWeekContainerView() {
		let weekContainerWidth = bounds.width - sidebarWidth
		let weekContainerHeight = bounds.height
		let itemSize = weekContainerWidth / 5
	}
	
	

}

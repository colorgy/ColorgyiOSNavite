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
	
	// MARK: - Public Parameters
	public var days: [Int] = [0,1,2,3,4,5,6] {
		didSet {
			updateDateLabels()
		}
	}
	private var dateLabels: [UILabel] = []
	
	// MARK: - Event
	public var events: [Event] = [] {
		didSet {
			updateEvents()
		}
	}
	
	private var itemSize: CGFloat {
		return weekContainerView.bounds.width / 5
	}
	
	private var calendarHeight: CGFloat {
		return weekContainerView.contentSize.height
	}
	
	// MARK: - Init
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureWeekContainerView()
		configureSidebar()
		configureHeader()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureWeekContainerView() {
		let weekContainerWidth = bounds.width - sidebarWidth
		let weekContainerHeight = bounds.height - headerHeight
		let itemSize = weekContainerWidth / 5
		weekContainerView = UIScrollView()
		weekContainerView.frame.size = CGSize(width: weekContainerWidth, height: weekContainerHeight)
		weekContainerView.contentSize = CGSize(width: itemSize * 7, height: itemSize * 24)
		
		let contentView = UIView()
		contentView.frame.size = weekContainerView.contentSize
		contentView.backgroundColor = ColorgyColor.BackgroundColor
		for line in 0...48 {
			let seperator = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: weekContainerView.contentSize.width, height: 2.0)))
			seperator.center.y = line.CGFloatValue * (itemSize / 2)
			seperator.backgroundColor = UIColor.whiteColor()
			contentView.addSubview(seperator)
		}
		weekContentView = contentView.resizableSnapshotViewFromRect(contentView.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		weekContainerView.addSubview(weekContentView)
		weekContainerView.bounces = false
		weekContainerView.delegate = self
		
		weekContainerView.frame.origin = CGPoint(x: sidebarWidth, y: headerHeight)

		addSubview(weekContainerView)
	}
	
	func configureSidebar() {
		let sidebarContainerHeight = weekContainerView.bounds.height
		let sidebarContentHeight = weekContentView.bounds.height
		let itemSize = weekContainerView.bounds.width / 5
		sidebarContainerView = UIScrollView()
		sidebarContainerView.frame.size = CGSize(width: sidebarWidth, height: sidebarContainerHeight)
		sidebarContainerView.frame.origin.y = headerHeight
		sidebarContainerView.backgroundColor = UIColor.whiteColor()
		sidebarContainerView.contentSize = CGSize(width: sidebarWidth, height: sidebarContentHeight)
		
		addSubview(sidebarContainerView)
		
		let contentView = UIView()
		contentView.frame.size = sidebarContainerView.contentSize
		for (index, _time) in ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"].enumerate() {
			// 00:00 ~ 24:00
			let timeLabel = UILabel()
			timeLabel.frame.size.width = 100
			timeLabel.frame.size.height = 13
			timeLabel.font = UIFont.systemFontOfSize(12)
			timeLabel.textAlignment = .Center
			timeLabel.textColor = ColorgyColor.TextColor
			timeLabel.text = "\(_time):00"
			timeLabel.center.x = contentView.bounds.midX
			timeLabel.center.y = itemSize * (index + 1).CGFloatValue
			
			contentView.addSubview(timeLabel)
		}
		
		sidebarContentView = contentView.resizableSnapshotViewFromRect(contentView.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		
		sidebarContainerView.addSubview(sidebarContentView)
		sidebarContainerView.userInteractionEnabled = false
	}
	
	func configureHeader() {
		let headerContainerWidth = weekContainerView.bounds.width
		let headerContentWidth = weekContentView.bounds.width
		let itemSize = weekContainerView.bounds.width / 5
		headerContainerView = UIScrollView()
		headerContainerView.frame.size = CGSize(width: headerContainerWidth, height: headerHeight)
		headerContainerView.backgroundColor = UIColor.whiteColor()
		headerContainerView.frame.origin.x = sidebarWidth
		headerContainerView.contentSize = CGSize(width: headerContentWidth, height: headerHeight)
		
		addSubview(headerContainerView)
		
		let contentView = UIView()
		contentView.frame.size = headerContainerView.contentSize
		for (index, weekday) in ["週一","週二","週三","週四","週五","週六","週日"].enumerate() {
			let dateLabel = UILabel()
			dateLabel.textAlignment = .Center
			dateLabel.frame.size = CGSize(width: 40, height: 13)
			dateLabel.text = "\(index)"
			dateLabel.textColor = ColorgyColor.TextColor
			dateLabel.center.x = itemSize * (index.CGFloatValue + 0.5)
			dateLabel.center.y = contentView.center.y / 2
			dateLabels.append(dateLabel)
			contentView.addSubview(dateLabel)
			
			let weekdayLabel = UILabel()
			weekdayLabel.textAlignment = .Center
			weekdayLabel.frame.size = CGSize(width: 40, height: 13)
			weekdayLabel.text = weekday
			weekdayLabel.textColor = ColorgyColor.TextColor
			weekdayLabel.center.x = itemSize * (index.CGFloatValue + 0.5)
			weekdayLabel.center.y = contentView.center.y * 1.5
			contentView.addSubview(weekdayLabel)
		}
		
		headerContainerView.addSubview(contentView)
	}
	
	private func updateDateLabels() {
		guard days.count == 7 else { return }
		for (index, day) in days.enumerate() {
			dateLabels[index].text = "\(day)"
		}
	}

	private func updateEvents() {
		print(#file, #function, "need implement")
	}
	
	private func pointOfX(date: NSDate) -> Int {
		let ya = (date.weekday - 1 - 1) % 7
		if ya < 0 {
			return 6
		}
		return ya
	}
	
	private func pointOnWeekViewOfDate(date: NSDate) -> CGFloat {
		let minutes = (date.hour * 60 + date.minute).DoubleValue
		let minutesOf24Hours = 24 * 60.DoubleValue
		return (minutes / minutesOf24Hours).CGFloatValue * calendarHeight
	}
	
	// MARK: - Helper
	public func scrollToCurrentTime() {
		let now = NSDate()
		let y = pointOnWeekViewOfDate(now) - itemSize
		let x = pointOfX(now).CGFloatValue * itemSize
		print(x,y)
		let fuckY = max(0, min(y, calendarHeight - weekContainerView.frame.height))
		weekContainerView.setContentOffset(CGPoint(x: min(x, itemSize * 2), y: fuckY), animated: true)
	}
}

extension WeekCalendarView : UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView == weekContainerView {
			sidebarContainerView.contentOffset.y = weekContainerView.contentOffset.y
			headerContainerView.contentOffset.x = weekContainerView.contentOffset.x
		}
	}
}

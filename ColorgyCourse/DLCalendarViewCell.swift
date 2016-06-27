//
//  DLCalendarViewCell.swift
//  MonthCalender
//
//  Created by David on 2016/5/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class DLCalendarViewCell: UICollectionViewCell {
	
	private var dateLabel: UILabel!
	private var dateDetailLabel: UILabel!
	private var todayShapeLayer: CAShapeLayer?
	
	var calendar: DLCalendarView?
	var currentCalenderDate: NSDate?
	var date: NSDate! {
		didSet {
			updateUI()
		}
	}
	var dateDetailText: String! = "yoyo"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		dateLabel = UILabel()
		dateLabel.textAlignment = .Center
		dateLabel.font = UIFont.systemFontOfSize(14)
		dateLabel.frame.size.height = 17
		
		dateDetailLabel = UILabel()
		dateDetailLabel.textAlignment = .Center
		dateDetailLabel.font = UIFont.systemFontOfSize(12)
		dateDetailLabel.frame.size.height = 14
		
		addSubview(dateLabel)
		addSubview(dateDetailLabel)
	}
	
	func updateUI() {
		updateTitleText()
		updateDetailLabel()
		updateTodayLayer()
	}
	
	func updateTitleText() {
		dateLabel.text = calendar != nil ? "\(calendar!.dayOfDate(date))" : " "
		dateLabel.sizeToFit()
		dateLabel.center = CGPoint(x: bounds.midX, y: bounds.midY * 0.7)
		// change color of title
		changeTitleColor()
	}
	
	func updateDetailLabel() {
		dateDetailLabel.text = dateDetailText
		dateDetailLabel.sizeToFit()
		dateDetailLabel.center = CGPoint(x: bounds.midX, y: bounds.midY * 1.4)
	}
	
	func updateTodayLayer() {
		if isToday() {
			let diameter = min(bounds.height, bounds.width) * 0.7
			todayShapeLayer = CAShapeLayer()
			todayShapeLayer?.frame = CGRect(x: (bounds.width - diameter) / 2, y: (bounds.height - diameter) / 2, width: diameter, height: diameter)
			todayShapeLayer?.path = UIBezierPath(ovalInRect: todayShapeLayer!.bounds).CGPath
			todayShapeLayer?.fillColor = calendar?.todayColor.CGColor
			
			todayShapeLayer?.borderColor = UIColor.clearColor().CGColor
			todayShapeLayer?.borderWidth = 1.0
			
			layer.insertSublayer(todayShapeLayer!, below: dateLabel.layer)
			
			dateLabel.textColor = calendar?.selectedDateTextColor
			todayShapeLayer?.hidden = false
			
			if containsToday() {
				performOnselectingToday()
			}
		} else {
			todayShapeLayer?.hidden = true
		}
	}
	
	func performSelect() {
		
		if let calendar = calendar where calendar.selectedDates.contains(date) {
			if isToday() {
				performOnselectingToday()
			} else {
//				performOnselect()
			}
		} else {
			if isToday() {
				performDeselectingToday()
			} else {
				performDeselect()
			}
		}
	}
	
	func performOnselectingToday() {
		// animation part
		let group = CAAnimationGroup()
		let animationDuration = 0.2
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = 1.0
		scale.toValue = 0.8
		scale.duration = animationDuration
		scale.fillMode = kCAFillModeForwards
		scale.removedOnCompletion = false
		
		group.duration = animationDuration
		group.animations = [scale]
		group.fillMode = kCAFillModeForwards
		group.removedOnCompletion = false
		
		todayShapeLayer?.addAnimation(group, forKey: nil)
	}
	
	func performDeselectingToday() {
		// animation part
		let group = CAAnimationGroup()
		let animationDuration = 0.2
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = 0.8
		scale.toValue = 1.2
		scale.duration = animationDuration/4*3
		scale.fillMode = kCAFillModeForwards
		scale.removedOnCompletion = false
		
		let scaleDown = CABasicAnimation(keyPath: "transform.scale")
		scaleDown.fromValue = 1.2
		scaleDown.toValue = 1.0
		scaleDown.duration = animationDuration/4
		scaleDown.beginTime = animationDuration/4*3
		scaleDown.fillMode = kCAFillModeForwards
		scaleDown.removedOnCompletion = false
		
		group.duration = animationDuration
		group.animations = [scale, scaleDown]
		group.fillMode = kCAFillModeForwards
		group.removedOnCompletion = false
		
		todayShapeLayer?.addAnimation(group, forKey: nil)
	}
	
	func performDeselect() {
		UIView.animateWithDuration(0.1) {
			self.changeTitleColor()
		}
	}
	
	func changeTitleColor() {
		if let calendar = calendar {
			if isToday() {
				dateLabel.textColor = calendar.selectedDateTextColor
			} else if calendar.selectedDates.contains(date) {
				dateLabel.textColor = calendar.selectedDateTextColor
			} else if sameMonth() {
				dateLabel.textColor = calendar.thisMonthTextColor
			} else {
				dateLabel.textColor = calendar.otherMonthTextColor
			}
		}
	}
	
	func isToday() -> Bool {
		let now = NSDate()
		if let calendar = calendar {
			if calendar.dayOfDate(date) == calendar.dayOfDate(now) {
				if calendar.monthOfDate(date) == calendar.monthOfDate(now) {
					if calendar.yearOfDate(date) == calendar.yearOfDate(now) {
						return true
					}
				}
			}
		}
		return false
	}
	
	func containsToday() -> Bool {
		let now = NSDate()
		if let calendar = calendar {
			for _date in calendar.selectedDates {
				if calendar.dayOfDate(_date) == calendar.dayOfDate(now) {
					if calendar.monthOfDate(_date) == calendar.monthOfDate(now) {
						if calendar.yearOfDate(_date) == calendar.yearOfDate(now) {
							return true
						}
					}
				}
			}
		}
		return false
	}
	
	func sameMonth() -> Bool {
		if let currentCalenderDate = currentCalenderDate where calendar?.monthOfDate(date) == calendar?.monthOfDate(currentCalenderDate) {
			return true
		}
		return false
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	public override func prepareForReuse() {
		super.prepareForReuse()
		CATransaction.setDisableActions(true)
		todayShapeLayer?.hidden = true
	}
	
}

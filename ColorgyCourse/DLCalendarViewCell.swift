//
//  DLCalendarViewCell.swift
//  MonthCalender
//
//  Created by David on 2016/5/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class DLCalendarViewCell: UICollectionViewCell {
	
	private var titleLabel: UILabel!
	private var didSelectedShapeLayer: CAShapeLayer?
	private var todayShapeLayer: CAShapeLayer?
	
	var calendar: DLCalendarView?
	var currentCalenderDate: NSDate?
	var date: NSDate! {
		didSet {
			updateUI()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		titleLabel = UILabel()
		titleLabel.textAlignment = .Center
		titleLabel.font = UIFont.systemFontOfSize(14)
		titleLabel.frame.size.height = 17
		
		addSubview(titleLabel)
		
		// layer
		let diameter = min(bounds.height, bounds.width) * 0.7
		didSelectedShapeLayer = CAShapeLayer()
		didSelectedShapeLayer?.frame = CGRect(x: (bounds.width - diameter) / 2, y: (bounds.height - diameter) / 2, width: diameter, height: diameter)
		didSelectedShapeLayer?.path = UIBezierPath(ovalInRect: didSelectedShapeLayer!.bounds).CGPath
		didSelectedShapeLayer?.fillColor = calendar?.selectedColor.CGColor
		
		didSelectedShapeLayer?.borderColor = UIColor.clearColor().CGColor
		didSelectedShapeLayer?.borderWidth = 1.0
		
		layer.insertSublayer(didSelectedShapeLayer!, below: titleLabel.layer)
	}
	
	func updateUI() {
		updateTitleText()
		updateTodayLayer()
		updateDidSelectLayer()
	}
	
	func updateTitleText() {
		titleLabel.text = calendar != nil ? "\(calendar!.dayOfDate(date))" : " "
		titleLabel.sizeToFit()
		titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
		// change color of title
		changeTitleColor()
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
			
			layer.insertSublayer(todayShapeLayer!, below: titleLabel.layer)
			
			titleLabel.textColor = calendar?.selectedDateTextColor
			todayShapeLayer?.hidden = false
			
			if containsToday() {
				performOnselectingToday()
			}
		} else {
			todayShapeLayer?.hidden = true
		}
	}
	
	func updateDidSelectLayer() {
		
		didSelectedShapeLayer?.fillColor = calendar?.selectedColor.CGColor
		
		if let calendar = calendar where calendar.selectedDates.contains(date) {
			didSelectedShapeLayer?.hidden = false
		} else {
			didSelectedShapeLayer?.hidden = true
		}
	}
	
	func performSelect() {
		
		if let calendar = calendar where calendar.selectedDates.contains(date) {
			if isToday() {
				performOnselectingToday()
			} else {
				performOnselect()
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
		
		didSelectedShapeLayer?.hidden = false
		
		// animation part
		let group2 = CAAnimationGroup()
		let animationDuration2 = 0.2
		
		let scale2 = CABasicAnimation(keyPath: "transform.scale")
		scale2.fromValue = 1.0
		scale2.toValue = 1.3
		scale2.duration = animationDuration2/4*3
		scale2.fillMode = kCAFillModeForwards
		scale2.removedOnCompletion = false
		
		let scaleDown2 = CABasicAnimation(keyPath: "transform.scale")
		scaleDown2.fromValue = 1.3
		scaleDown2.toValue = 1.0
		scaleDown2.duration = animationDuration2/4
		scaleDown2.beginTime = animationDuration2/4*3
		scaleDown2.fillMode = kCAFillModeForwards
		scaleDown2.removedOnCompletion = false
		
		group2.duration = animationDuration2
		group2.animations = [scale2, scaleDown2]
		group2.fillMode = kCAFillModeForwards
		group2.removedOnCompletion = false
		
		didSelectedShapeLayer?.addAnimation(group2, forKey: nil)
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
		
		didSelectedShapeLayer?.hidden = true
	}
	
	func performOnselect() {
		didSelectedShapeLayer?.hidden = false
		
		// animation part
		let group = CAAnimationGroup()
		let animationDuration = 0.2
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = 0.0
		scale.toValue = 1.2
		scale.duration = animationDuration/4*3
		
		let scaleDown = CABasicAnimation(keyPath: "transform.scale")
		scaleDown.fromValue = 1.2
		scaleDown.toValue = 1.0
		scaleDown.duration = animationDuration/4
		scaleDown.beginTime = animationDuration/4*3
		
		group.duration = animationDuration
		group.animations = [scale, scaleDown]
		
		didSelectedShapeLayer?.addAnimation(group, forKey: nil)
		
		// text color
		UIView.animateWithDuration(animationDuration) { 
			self.changeTitleColor()
		}
	}
	
	func performDeselect() {
		didSelectedShapeLayer?.hidden = true
		
		UIView.animateWithDuration(0.1) {
			self.changeTitleColor()
		}
	}
	
	func changeTitleColor() {
		if let calendar = calendar {
			if isToday() {
				titleLabel.textColor = calendar.selectedDateTextColor
			} else if calendar.selectedDates.contains(date) {
				titleLabel.textColor = calendar.selectedDateTextColor
			} else if sameMonth() {
				titleLabel.textColor = calendar.thisMonthTextColor
			} else {
				titleLabel.textColor = calendar.otherMonthTextColor
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
		didSelectedShapeLayer?.hidden = true
		todayShapeLayer?.hidden = true
	}
    
}

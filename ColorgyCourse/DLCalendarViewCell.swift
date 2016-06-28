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
	private let dateLabelMoveUpScale: CGFloat = 0.7
	private var dateDetailLabel: UILabel!
	private var selectedShapeLayer: CAShapeLayer?
	
	public var calendar: DLCalendarView? {
		didSet {
			configureShapeLayer()
		}
	}
	public var currentCalenderMonth: NSDate?
	public var date: NSDate! {
		didSet {
			updateUI()
		}
	}
	public var dateDetailText: String! = "yoyo"
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		dateLabel = UILabel()
		dateLabel.textAlignment = .Center
		dateLabel.font = UIFont.systemFontOfSize(14)
		dateLabel.frame.size.height = 17
		
		dateDetailLabel = UILabel()
		dateDetailLabel.textAlignment = .Center
		dateDetailLabel.font = UIFont.systemFontOfSize(10)
		dateDetailLabel.frame.size.height = 14
		dateDetailLabel.frame.size.width = frame.width
		dateDetailLabel.center = CGPoint(x: bounds.midX, y: bounds.midY * 1.4)
		
		addSubview(dateLabel)
		addSubview(dateDetailLabel)
	}
	
	private func configureShapeLayer() {
		configureTodayLayer()
		dateDetailLabel.textColor = calendar?.specialDateColor
	}
	
	private func updateUI() {
		updateTitleText()
		updateDetailLabelText()
		updateSelectionState()
	}
	
	private func updateTitleText() {
		dateLabel.text = calendar != nil ? "\(date.day)" : " "
		dateLabel.sizeToFit()
		dateLabel.center = CGPoint(x: bounds.midX, y: bounds.midY * dateLabelMoveUpScale)
	}
	
	private func updateDetailLabel() {
		dateDetailLabel.text = dateDetailText
	}
	
	private func updateSelectionState() {
		
		if let calendar = calendar where calendar.selectedDates.contains(date) {
			onselectedState()
		} else {
			deselectedState()
		}
	}
	
	private func configureTodayLayer() {
		let diameter = min(bounds.height, bounds.width) * 0.5
		if selectedShapeLayer == nil {
			selectedShapeLayer = CAShapeLayer()
		}
		selectedShapeLayer?.frame = CGRect(x: (bounds.width - diameter) / 2,
		                                   y: (bounds.height - diameter) / 2 - bounds.midY * (1 - dateLabelMoveUpScale),
		                                   width: diameter,
		                                   height: diameter)
		selectedShapeLayer?.path = UIBezierPath(ovalInRect: selectedShapeLayer!.bounds).CGPath
		selectedShapeLayer?.fillColor = calendar?.todayColor.CGColor
		
		selectedShapeLayer?.borderColor = UIColor.clearColor().CGColor
		selectedShapeLayer?.borderWidth = 1.0
		
		layer.insertSublayer(selectedShapeLayer!, below: dateLabel.layer)
		
		selectedShapeLayer?.hidden = true
	}
	
	public func performSelect(complete complete: (() -> Void)?) {
		
		if let calendar = calendar where calendar.selectedDates.contains(date) {
			// selected
			performOnselectingDate()
			animateOnselectingDateTextColor()
		} else {
			// deselected
			performDeselectingDate()
			animateDeselectingDateTextColor()
		}
		
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.2))
		dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
			complete?()
		})
	}
	
	private func performOnselectingDate() {
		
		selectedShapeLayer?.hidden = false
		
		// animation part
		let group = CAAnimationGroup()
		let animationDuration = 0.2
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = 0.0
		scale.toValue = 1.0
		scale.duration = animationDuration
		scale.fillMode = kCAFillModeForwards
		scale.removedOnCompletion = false
		
		group.duration = animationDuration
		group.animations = [scale]
		group.fillMode = kCAFillModeForwards
		group.removedOnCompletion = false
		
		selectedShapeLayer?.addAnimation(group, forKey: nil)
	}
	
	private func performDeselectingDate() {
		selectedShapeLayer?.hidden = true
	}
	
	private func animateOnselectingDateTextColor() {
		UIView.animateWithDuration(0.2) {
			self.dateLabel.textColor = self.calendar?.selectedDateTextColor
		}
	}
	
	private func animateDeselectingDateTextColor() {
		UIView.animateWithDuration(0.2) {
			self.dateLabel.textColor = self.isToday() ? self.calendar?.todayColor : self.calendar?.normalContentTextColor
		}
	}
	
	private func onselectedState() {
		selectedShapeLayer?.hidden = false
		self.dateLabel.textColor = self.calendar?.selectedDateTextColor
	}
	
	private func deselectedState() {
		selectedShapeLayer?.hidden = true
		self.dateLabel.textColor = self.isToday() ? self.calendar?.todayColor : self.calendar?.normalContentTextColor
	}

	private func isToday() -> Bool {
		return date == NSDate()
	}
	
	private func containsToday() -> Bool {
		let now = NSDate()
		if let calendar = calendar {
			for _date in calendar.selectedDates {
				if _date == now {
					return true
				}
			}
		}
		return false
	}
	
	private func sameMonth() -> Bool {
		if let currentCalenderMonth = currentCalenderMonth where date.month == currentCalenderMonth.month {
			return true
		}
		return false
	}
	
	private func updateDetailLabelText() {
		
		guard let calendar = calendar else {
			return
		}
		
		let before = NSDate()
		if calendar.specialDates.contains(date) {
			// if its special date, update the content.
			dateDetailText = "搶到票"
			dateDetailLabel.textColor = calendar.specialDateColor
		} else if date.day == 1 {
			// if not special date, but its first date of month, update text
			dateDetailText = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"][date.month - 1]
			dateDetailLabel.textColor = calendar.normalContentTextColor
		} else {
			// reset text
			dateDetailText = ""
		}
		let a = -before.timeIntervalSinceNow*1000
		print("\(a) ms")
		
		updateDetailLabel()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	public override func prepareForReuse() {
		super.prepareForReuse()
		CATransaction.setDisableActions(true)
		selectedShapeLayer?.hidden = true
	}
	
}

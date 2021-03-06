//
//  CreateEventAddChildEventCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol EventManagerAddChildEventCellDelegate: class {
	func eventManagerAddChildEventCellAddChildEventButtonClicked()
}

final public class EventManagerAddChildEventCell: UITableViewCell {
	
	@IBOutlet weak var addDateButton: UIButton!
	public weak var delegate: EventManagerAddChildEventCellDelegate?
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		selectionStyle = .None
		
		addDateButton.tintColor = ColorgyColor.MainOrange
		addDateButton.layer.cornerRadius = 2.0
		addDateButton.layer.borderColor = ColorgyColor.MainOrange.CGColor
		addDateButton.layer.borderWidth = 1.5
		addDateButton.setTitle("繼續新增時段", forState: UIControlState.Normal)
		addDateButton.addTarget(self, action: #selector(EventManagerAddChildEventCell.addChildEventButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		backgroundColor = UIColor.clearColor()
	}
	
	@objc private func addChildEventButtonClicked() {
		delegate?.eventManagerAddChildEventCellAddChildEventButtonClicked()
	}
}

//
//  CreateEventAddChildEventCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol CreateEventAddChildEventCellDelegate: class {
	func createEventAddDateCellAddChildEventButtonClicked()
}

final public class CreateEventAddChildEventCell: UITableViewCell {
	
	@IBOutlet weak var addDateButton: UIButton!
	public weak var delegate: CreateEventAddChildEventCellDelegate?
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		selectionStyle = .None
		
		addDateButton.tintColor = ColorgyColor.MainOrange
		addDateButton.layer.cornerRadius = 2.0
		addDateButton.layer.borderColor = ColorgyColor.MainOrange.CGColor
		addDateButton.layer.borderWidth = 1.5
		addDateButton.setTitle("繼續新增時段", forState: UIControlState.Normal)
		addDateButton.addTarget(self, action: #selector(CreateEventAddChildEventCell.addDateButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		backgroundColor = UIColor.clearColor()
	}
	
	@objc private func addDateButtonClicked() {
		delegate?.createEventAddDateCellAddChildEventButtonClicked()
	}
}

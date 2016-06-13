//
//  CreateEventAddDateTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol CreateEventAddDateCellDelegate: class {
	func createEventAddDateCellAddDateButtonClicked()
}

final public class CreateEventAddDateCell: UITableViewCell {
	
	@IBOutlet weak var addDateButton: UIButton!
	public weak var delegate: CreateEventAddDateCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectionStyle = .None
		
		addDateButton.tintColor = ColorgyColor.MainOrange
		addDateButton.layer.cornerRadius = 2.0
		addDateButton.layer.borderColor = ColorgyColor.MainOrange.CGColor
		addDateButton.layer.borderWidth = 1.5
		addDateButton.addTarget(self, action: #selector(CreateEventAddDateCell.addDateButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
    }

	@objc private func addDateButtonClicked() {
		delegate?.createEventAddDateCellAddDateButtonClicked()
	}
}

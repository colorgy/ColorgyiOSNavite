//
//  CreateEventRepeatedCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class CreateEventRepeatedCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var repeatSwitch: UISwitch!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.text = "重複"
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		
		contentLabel.text = "永不"
		contentLabel.textColor = ColorgyColor.TextColor
		
		repeatSwitch.on = false
		
		selectionStyle = .None
    }

}

//
//  SettingsSexPickerCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsSexPickerCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var boyButton: UIButton!
	@IBOutlet weak var girlButton: UIButton!
	@IBOutlet weak var otherButton: UIButton!
	
	enum Sex: String {
		case Boy = "Boy"
		case Girl = "Girl"
		case Other = "Other"
	}

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		let buttons = [boyButton, girlButton, otherButton]
		buttons.forEach { (button) in
			button.tintColor = ColorgyColor.grayContentTextColor
			button.titleLabel?.font = UIFont.systemFontOfSize(16)
		}
		
		boyButton.setTitle("男生", forState: UIControlState.Normal)
		girlButton.setTitle("女生", forState: UIControlState.Normal)
		otherButton.setTitle("其他", forState: UIControlState.Normal)
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
    }
	
	public func active(selected sex: Sex) {
		switch sex {
		case .Boy:
			boyButton.tintColor = ColorgyColor.TextColor
		case .Girl:
			girlButton.tintColor = ColorgyColor.TextColor
		case .Other:
			otherButton.tintColor = ColorgyColor.TextColor
		}
	}

}

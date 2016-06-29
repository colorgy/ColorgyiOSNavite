//
//  SettingsSwitchCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsSwitchCell: UITableViewCell {

	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var switchControl: UISwitch!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.font = UIFont.systemFontOfSize(16)
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
    }

}

//
//  EventRepeatSettingTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class EventRepeatSettingTableViewCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		selectionStyle = .None
		
		titleLabel.textColor = ColorgyColor.TextColor
		titleLabel.setFontAsContentTextFont()
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

}

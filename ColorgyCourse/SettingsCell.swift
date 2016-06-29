//
//  SettingsCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var disclosureImageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		titleLabel.textColor = ColorgyColor.TextColor
		titleLabel.font = UIFont.systemFontOfSize(16)
		
		disclosureImageView.image = UIImage(named: "GrayDisclosureIndicator")
		disclosureImageView.contentMode = .ScaleAspectFill
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
    }

}

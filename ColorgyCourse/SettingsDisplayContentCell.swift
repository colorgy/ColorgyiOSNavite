//
//  SettingsDisplayContentCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsDisplayContentCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var disclosureImageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.font = UIFont.systemFontOfSize(16)
		
		contentLabel.textColor = ColorgyColor.TextColor
		contentLabel.font = UIFont.systemFontOfSize(16)
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		disclosureImageView.image = UIImage(named: "GrayDisclosureIndicator")
		disclosureImageView.contentMode = .ScaleAspectFill
		
		selectionStyle = .None
    }

}

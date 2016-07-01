//
//  SettingsSexCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SettingsSexCell: UITableViewCell {
	
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
		
		disclosureImageView.image = UIImage(named: "GrayDownDisclosureIndicator")
		disclosureImageView.contentMode = .ScaleAspectFill
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
	}
	
}
//
//  EventManagerRepeatEndsCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventManagerRepeatEndsCell: UITableViewCell {
	
	@IBOutlet weak var disclosureIndicatorImageView: UIImageView!
	@IBOutlet weak var titleLable: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		disclosureIndicatorImageView.image = UIImage(named: "GrayDisclosureIndicator")
		disclosureIndicatorImageView.contentMode = .ScaleAspectFill
		
		titleLable.textColor = ColorgyColor.grayContentTextColor
		titleLable.text = "重複結束"
		
		contentLabel.text = "永不"
		contentLabel.textColor = ColorgyColor.TextColor
		contentLabel.textAlignment = .Right
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

}

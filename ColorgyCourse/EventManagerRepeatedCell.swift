//
//  EventManagerRepeatedCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventManagerRepeatedCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var disclosureIndicatorImageView: UIImageView!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.text = "重複"
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		
		contentLabel.text = "永不"
		contentLabel.textColor = ColorgyColor.TextColor
		contentLabel.textAlignment = .Right
		
		disclosureIndicatorImageView.image = UIImage(named: "GrayDisclosureIndicator")
		disclosureIndicatorImageView.contentMode = .ScaleAspectFill
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

}

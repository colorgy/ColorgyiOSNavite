//
//  CreateEventTitleCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class CreateEventTitleCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.text = "標題"
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		
		titleTextField.placeholder = "輸入事件標題..."
		titleTextField.autocorrectionType = .No
		titleTextField.autocapitalizationType = .None
		titleTextField.textColor = ColorgyColor.TextColor
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

}

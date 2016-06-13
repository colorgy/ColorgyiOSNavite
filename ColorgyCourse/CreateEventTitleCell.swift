//
//  CreateEventTitleCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol CreateEventTitleCellDelegate: class {
	func createEventTitleCellTitleTextUpdated(text: String?)
}

final public class CreateEventTitleCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
	public weak var delegate: CreateEventTitleCellDelegate?
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.text = "標題"
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		
		titleTextField.placeholder = "輸入事件標題..."
		titleTextField.autocorrectionType = .No
		titleTextField.autocapitalizationType = .None
		titleTextField.textColor = ColorgyColor.TextColor
		titleTextField.addTarget(self, action: #selector(CreateEventTitleCell.titleTextEdtingChanged), forControlEvents: UIControlEvents.EditingChanged)
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

	@objc private func titleTextEdtingChanged() {
		delegate?.createEventTitleCellTitleTextUpdated(titleTextField.text)
	}
	
	public func setTitle(title: String?) {
		titleLabel.text = title
	}
}

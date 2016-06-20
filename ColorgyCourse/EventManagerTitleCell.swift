//
//  EventManagerTitleCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol EventManagerTitleCellDelegate: class {
	func eventManagerTitleCellTitleTextUpdated(text: String?)
}

final public class EventManagerTitleCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
	public weak var delegate: EventManagerTitleCellDelegate?
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.text = "標題"
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		
		titleTextField.placeholder = "輸入事件標題..."
		titleTextField.autocorrectionType = .No
		titleTextField.autocapitalizationType = .None
		titleTextField.textColor = ColorgyColor.TextColor
		titleTextField.tintColor = ColorgyColor.MainOrange
		titleTextField.addTarget(self, action: #selector(EventManagerTitleCell.titleTextEdtingChanged), forControlEvents: UIControlEvents.EditingChanged)
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

	@objc private func titleTextEdtingChanged() {
		delegate?.eventManagerTitleCellTitleTextUpdated(titleTextField.text)
	}
	
	public func setTitle(title: String?) {
		titleTextField.text = title
	}
}

//
//  SettingsSexPickerCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol SettingsSexPickerCellDelegate: class {
	func settingsSexPickerCell(didSelect sex: SettingsSexPickerCell.Sex)
}

final public class SettingsSexPickerCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var boyButton: UIButton!
	@IBOutlet weak var girlButton: UIButton!
	@IBOutlet weak var otherButton: UIButton!
	
	public weak var delegate: SettingsSexPickerCellDelegate?
	
	public enum Sex: String {
		case Boy = "男生"
		case Girl = "女生"
		case Other = "其他"
	}

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		deactiveAllButtons()
		
		boyButton.setTitle(Sex.Boy.rawValue, forState: UIControlState.Normal)
		girlButton.setTitle(Sex.Girl.rawValue, forState: UIControlState.Normal)
		otherButton.setTitle(Sex.Other.rawValue, forState: UIControlState.Normal)
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
    }
	
	private func deactiveAllButtons() {
		let buttons = [boyButton, girlButton, otherButton]
		buttons.forEach { (button) in
			button.tintColor = ColorgyColor.grayContentTextColor
			button.titleLabel?.font = UIFont.systemFontOfSize(16)
		}
	}
	
	public func active(selected sex: Sex) {
		
		deactiveAllButtons()
		
		switch sex {
		case .Boy:
			boyButton.tintColor = ColorgyColor.TextColor
		case .Girl:
			girlButton.tintColor = ColorgyColor.TextColor
		case .Other:
			otherButton.tintColor = ColorgyColor.TextColor
		}
	}
	
	// MARK: - Actions
	@IBAction public func sexButtonClicked(button: UIButton) {
		switch button {
		case boyButton:
			active(selected: .Boy)
			delegate?.settingsSexPickerCell(didSelect: .Boy)
		case girlButton:
			active(selected: .Girl)
			delegate?.settingsSexPickerCell(didSelect: .Girl)
		case otherButton:
			active(selected: .Other)
			delegate?.settingsSexPickerCell(didSelect: .Other)
		default:
			break
		}
	}

}

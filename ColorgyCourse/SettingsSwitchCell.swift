//
//  SettingsSwitchCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol SettingsSwitchCellDelegate: class {
	func settingsSwitchCell(switchDidChangedIn cell: SettingsSwitchCell, toState on: Bool)
}

final public class SettingsSwitchCell: UITableViewCell {

	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var switchControl: UISwitch!
	
	public weak var delegate: SettingsSwitchCellDelegate?
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.font = UIFont.systemFontOfSize(16)
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		switchControl.addTarget(self, action: #selector(SettingsSwitchCell.switchControlValueChanged), forControlEvents: UIControlEvents.ValueChanged)
		
		selectionStyle = .None
    }
	
	@objc private func switchControlValueChanged() {
		delegate?.settingsSwitchCell(switchDidChangedIn: self, toState: switchControl.on)
	}

}

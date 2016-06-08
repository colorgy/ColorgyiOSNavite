//
//  ChooseSchoolTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ChooseSchoolTableViewCell: UITableViewCell {
	
	@IBOutlet weak var seperatorLine: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	public var school: Organization? {
		didSet {
			updateUI()
		}
	}

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		seperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		
		selectionStyle = .None
    }

	private func updateUI() {
		titleLabel.text = school?.name
	}
}

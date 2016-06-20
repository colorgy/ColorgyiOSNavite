//
//  EventManagerColorCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventManagerColorCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var choosedColorView: UIView!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
	public weak var delegate: EventManagerColorCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.text = "顏色"
		
		choosedColorView.layer.cornerRadius = choosedColorView.bounds.width / 2
		choosedColorView.backgroundColor = UIColor(red: 198/255.0, green: 188/255.0, blue: 188/255.0, alpha: 1.0)
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EventManagerColorCell.tapped)))
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }
	
	@objc private func tapped() {
		delegate?.createEventColorCellNeedsExpand()
	}

	public func updateSelectedColor(color: UIColor?) {
		choosedColorView.backgroundColor = color
	}
}

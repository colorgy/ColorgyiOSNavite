//
//  CreateEventDateAndLocationCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class CreateEventDateAndLocationCell: UITableViewCell {
	
	@IBOutlet weak var deleteIconImageView: UIImageView!
	@IBOutlet weak var deleteTitleLabel: UILabel!
	@IBOutlet weak var deleteRegionView: UIView!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var seperatorLine1: UIView!
	@IBOutlet weak var seperatorLine2: UIView!
	@IBOutlet weak var sideBarView: UIView!
	@IBOutlet weak var startsDateLabel: UILabel!
	@IBOutlet weak var endsDateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		backgroundColor = UIColor.clearColor()
		
		deleteIconImageView.image = UIImage(named: "CircleDeleteIcon")
		deleteIconImageView.contentMode = .ScaleAspectFill
		
		deleteTitleLabel.text = "刪除時間"
		deleteTitleLabel.font = UIFont.systemFontOfSize(12)
		deleteTitleLabel.textColor = ColorgyColor.grayContentTextColor
		
		deleteRegionView.backgroundColor = UIColor.clearColor()
		deleteRegionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEventDateAndLocationCell.deleteRegionTapped)))
		
		containerView.backgroundColor = UIColor.whiteColor()
		seperatorLine1.backgroundColor = ColorgyColor.BackgroundColor
		seperatorLine2.backgroundColor = ColorgyColor.BackgroundColor
		
		sideBarView.backgroundColor = ColorgyColor.MainOrange
		
		startsDateLabel.textColor = ColorgyColor.grayContentTextColor
		startsDateLabel.text = "開始時間"
		
		endsDateLabel.textColor = ColorgyColor.grayContentTextColor
		endsDateLabel.text = "結束時間"
		
		locationLabel.textColor = ColorgyColor.grayContentTextColor
		locationLabel.text = "地點"
    }
	
	@objc private func deleteRegionTapped() {
		
	}
	
}

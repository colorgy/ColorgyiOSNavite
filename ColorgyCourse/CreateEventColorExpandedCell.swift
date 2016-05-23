//
//  CreateEventColorCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class CreateEventColorExpandedCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var choosedColorView: UIView!
	
	@IBOutlet weak var grayColorView: UIView!
	@IBOutlet weak var orangeColorView: UIView!
	@IBOutlet weak var yellowColorView: UIView!
	@IBOutlet weak var greenColorView: UIView!
	@IBOutlet weak var blueGreenColorView: UIView!
	@IBOutlet weak var blueColorView: UIView!
	@IBOutlet weak var indigoColorView: UIView!
	@IBOutlet weak var purpleColorView: UIView!
	@IBOutlet weak var peachColorView: UIView!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
	public weak var delegate: CreateEventColorCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.text = "顏色"
		
		// corner radius
		let colorViews = [grayColorView, orangeColorView, yellowColorView, greenColorView, blueGreenColorView, blueColorView, indigoColorView, purpleColorView, peachColorView]
		colorViews.forEach { (view) in
			view.layer.cornerRadius = view.bounds.width / 2
			view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEventColorExpandedCell.tapped(_:))))
		}
		
		choosedColorView.layer.cornerRadius = choosedColorView.bounds.width / 2
		
		// set color
		grayColorView.backgroundColor = UIColor(red: 198/255.0, green: 188/255.0, blue: 188/255.0, alpha: 1.0)
		orangeColorView.backgroundColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 1.0)
		yellowColorView.backgroundColor = UIColor(red: 245/255.0, green: 166/255.0, blue: 35/255.0, alpha: 1.0)
		greenColorView.backgroundColor = UIColor(red: 155/255.0, green: 206/255.0, blue: 2/255.0, alpha: 1.0)
		blueGreenColorView.backgroundColor = UIColor(red: 0/255.0, green: 208/255.0, blue: 173/255.0, alpha: 1.0)
		blueColorView.backgroundColor = UIColor(red: 0/255.0, green: 207/255.0, blue: 228/255.0, alpha: 1.0)
		indigoColorView.backgroundColor = UIColor(red: 7/255.0, green: 148/255.0, blue: 191/255.0, alpha: 1.0)
		purpleColorView.backgroundColor = UIColor(red: 226/255.0, green: 137/255.0, blue: 250/255.0, alpha: 1.0)
		peachColorView.backgroundColor = UIColor(red: 247/255.0, green: 107/255.0, blue: 157/255.0, alpha: 1.0)
		
		// default color
		choosedColorView.backgroundColor = grayColorView.backgroundColor
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
	}
	
	@objc private func tapped(gesture: UITapGestureRecognizer) {
		delegate?.createEventColorCell(needsCollapseWithSelectedColor: gesture.view?.backgroundColor)
    }

	public func updateSelectedColor(color: UIColor?) {
		choosedColorView.backgroundColor = color
	}
}

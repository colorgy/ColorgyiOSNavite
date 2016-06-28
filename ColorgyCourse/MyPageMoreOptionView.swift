//
//  MyPageMoreOptionView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MyPageMoreOptionView: UIView {

	
	// MARK: - Parameters
	
	private var optionViews: [UIView] = []
	private let numberOfViewsInRow = 3
	private let numberOfRows = 1
	private let heightOfOptionView: CGFloat = 75
	
	// MARK: - Init
	
	public convenience init() {
		self.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 75)))
	}
	
	override private init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	private func configureOptionView(with optionTitle: String?, optionImageName: String?, optionColor: UIColor?) -> UIView {
		let optionView = UIView(
			frame: CGRect(origin: CGPointZero,
			size: CGSize(width: bounds.width / numberOfViewsInRow.CGFloatValue, height: heightOfOptionView)))
		
		optionView.backgroundColor = optionColor
		
		// configure image of option view
		let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 21, height: 21)))
		imageView.contentMode = .ScaleAspectFill
		imageView.image = UIImage(named: optionImageName ?? "")
		
		imageView.frame.origin.y = 18
		imageView.center.x = centerXOfBounds
		
		optionView.addSubview(imageView)
		
		// configure title of option view
		let titleLabel = UILabel(frame: optionView.bounds)
		titleLabel.frame.size.height = 13
		titleLabel.font = UIFont.systemFontOfSize(13)
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.textAlignment = .Center
		titleLabel.text = optionTitle
		
		titleLabel.frame.origin.y = 8.point(below: imageView)
		titleLabel.center.x = centerXOfBounds
		
		optionView.addSubview(titleLabel)
		
		return optionView
	}
}

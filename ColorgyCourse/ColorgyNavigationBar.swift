//
//  ColorgyNavigationBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class ColorgyNavigationBar: UIView {
	
	// MARK: - Parameters
	private var titleLabel: UILabel!
	public var title: String? {
		didSet {
			titleLabel?.text = title
			titleLabel?.sizeToFit()
			centerLabel()
		}
	}

	// MARK: - Init
	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 64)))
		backgroundColor = UIColor.whiteColor()
		configureTitleLabel()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureTitleLabel() {
		titleLabel = UILabel()
		titleLabel.frame.size.height = 21
		titleLabel.font = UIFont.boldSystemFontOfSize(17)
		titleLabel.textAlignment = .Center
		titleLabel.frame.size.width = 0.6 * bounds.width
		titleLabel.sizeToFit()
		
		centerLabel()
		
		addSubview(titleLabel)
	}
	
	private func centerLabel() {
		titleLabel.center.x = bounds.midX
		titleLabel.center.y = (bounds.height - 20) / 2 + 20
	}

}

//
//  ColorgyFullScreenButton.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol ColorgyFullScreenButtonDelegate: class {
	func colorgyFullScreenButtonClicked(button: ColorgyFullScreenButton)
}

final public class ColorgyFullScreenButton: UIView {
	
	private var titleLabel: UILabel!
	
	public weak var delegate: ColorgyFullScreenButtonDelegate?

	public init(title: String?) {
		super.init(frame: UIScreen.mainScreen().bounds)
		frame.size.height = 36.0
		
		configureTitle(title)
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ColorgyFullScreenButton.tapped)))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	private func configureTitle(title: String?) {
		titleLabel = UILabel(frame: frame)
		titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
		titleLabel.textAlignment = .Center
		titleLabel.textColor = ColorgyColor.MainOrange
		titleLabel.text = title
		titleLabel.font = UIFont.systemFontOfSize(16.0)
		
		addSubview(titleLabel)
	}
	
	@objc private func tapped() {
		delegate?.colorgyFullScreenButtonClicked(self)
	}
}

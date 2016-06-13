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

final public class ColorgyFullScreenButton: UIButton {
	
	public weak var delegate: ColorgyFullScreenButtonDelegate?

	public init(title: String?, delegate: ColorgyFullScreenButtonDelegate?) {
		super.init(frame: UIScreen.mainScreen().bounds)
		
		frame.size.height = 36.0
		frame.size.width = UIScreen.mainScreen().bounds.width - 24 * 2
		layer.borderColor = ColorgyColor.MainOrange.CGColor
		layer.borderWidth = 1.5
		layer.cornerRadius = 2.0
		
		self.delegate = delegate
		
		setTitle(title, forState: UIControlState.Normal)
		titleLabel?.setFontAsContentTextFont()
		setTitleColor(ColorgyColor.MainOrange, forState: UIControlState.Normal)
		
		addTarget(self, action: #selector(ColorgyFullScreenButton.touchEnter), forControlEvents: [.TouchDown, .TouchDragEnter])
		addTarget(self, action: #selector(ColorgyFullScreenButton.touchExit), forControlEvents: [.TouchCancel, .TouchDragExit, .TouchUpOutside])
		addTarget(self, action: #selector(ColorgyFullScreenButton.touchUpInside), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	@objc private func touchEnter() {
		UIView.animateWithDuration(0.15) {
			self.alpha = 0.7
		}
	}
	
	@objc private func touchExit() {
		UIView.animateWithDuration(0.15) {
			self.alpha = 1.0
		}
	}
	
	@objc private func touchUpInside() {
		UIView.animateWithDuration(0.15) {
			self.alpha = 1.0
		}
		delegate?.colorgyFullScreenButtonClicked(self)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func didMoveToSuperview() {
		centerHorizontallyToSuperview()
	}
}

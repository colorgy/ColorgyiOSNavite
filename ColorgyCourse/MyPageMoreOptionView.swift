//
//  MyPageMoreOptionView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

@objc public protocol MyPageMoreOptionViewDelegate: class {
	optional func myPageMoreOptionViewMyActivityTapped()
	optional func myPageMoreOptionViewGreetingsTapped()
	optional func myPageMoreOptionViewSettingsTapped()
}

final public class MyPageMoreOptionView: UIView {

	
	// MARK: - Parameters
	
	private var optionViews: [UIView] = []
	private let numberOfViewsInRow = 3
	private let numberOfRows = 1
	private let heightOfOptionView: CGFloat = 75
	private var optionData: [(title: String, imageName: String, color: UIColor, selector: Selector)] = []
	
	public weak var delegate: MyPageMoreOptionViewDelegate?
	
	// MARK: - Init
	
	public convenience init(delegate: MyPageMoreOptionViewDelegate?) {
		self.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 75)))
		
		self.delegate = delegate
		
		// setup option data
		optionData.append((title: "我的活動", imageName: "OptionMyActivityIcon", color: ColorgyColor.waterBlue, selector: #selector(MyPageMoreOptionView.myActivityOptionViewTapped)))
		optionData.append((title: "我的招呼", imageName: "OptionGreetingsIcon", color: ColorgyColor.orangeYellow, selector: #selector(MyPageMoreOptionView.greetingsOptionViewTapped)))
		optionData.append((title: "更多設定", imageName: "OptionSettingsIcon", color: ColorgyColor.magenta, selector: #selector(MyPageMoreOptionView.settingsOptionViewTapped)))
		
		// configure
		optionData.forEach({ optionViews.append(configureOptionView(with: $0)) })
		// arrange
		for (index, optionView) in optionViews.enumerate() {
			optionView.frame.origin.x = index.CGFloatValue * optionView.bounds.width
			addSubview(optionView)
		}
	}
	
	override private init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	private func configureOptionView(with option: (title: String, imageName: String, color: UIColor, selector: Selector)) -> UIView {
		let optionView = UIView(
			frame: CGRect(origin: CGPointZero,
			size: CGSize(width: bounds.width / numberOfViewsInRow.CGFloatValue, height: heightOfOptionView)))
		
		optionView.backgroundColor = option.color
		
		// configure image of option view
		let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 21, height: 21)))
		imageView.contentMode = .ScaleAspectFill
		imageView.image = UIImage(named: option.imageName)
		
		imageView.frame.origin.y = 18
		imageView.centerX(to: optionView)
		
		optionView.addSubview(imageView)
		
		// configure title of option view
		let titleLabel = UILabel(frame: optionView.bounds)
		titleLabel.frame.size.height = 13
		titleLabel.font = UIFont.systemFontOfSize(13)
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.textAlignment = .Center
		titleLabel.text = option.title
		
		titleLabel.move(8, pointBelow: imageView)
		titleLabel.centerX(to: optionView)
		
		optionView.addSubview(titleLabel)
		
		// tap gesture
		optionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: option.selector))
		
		return optionView
	}
	
	// MARK: - Selectors
	@objc private func myActivityOptionViewTapped() {
		delegate?.myPageMoreOptionViewMyActivityTapped?()
	}
	
	@objc private func greetingsOptionViewTapped() {
		delegate?.myPageMoreOptionViewGreetingsTapped?()
	}
	
	@objc private func settingsOptionViewTapped() {
		delegate?.myPageMoreOptionViewSettingsTapped?()
	}
}

//
//  ColorgyBillboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ColorgyBillboardView: UIView {
	
	private var chickAndGirlImageView: UIImageView!
	private var billboardImageView: UIImageView!
	private var billboardLabel: UILabel!
	
	public var billboardText: String? {
		didSet {
			updateBillboardText()
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		configureChickAndGirlImageView()
		configureBillboardImageView()
		configureBillboardLabel()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	private func configureChickAndGirlImageView() {
		chickAndGirlImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 77, height: 117)))
		chickAndGirlImageView.image = UIImage(named: "ChickAndGirl")
		chickAndGirlImageView.contentMode = .ScaleAspectFit
		
		chickAndGirlImageView.center.x = bounds.width * (254.0 / 375.0)
		chickAndGirlImageView.center.y = bounds.height * (103.0 / 170.0)
		
		addSubview(chickAndGirlImageView)
	}
	
	private func configureBillboardImageView() {
		billboardImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 81, height: 80)))
		billboardImageView.image = UIImage(named: "ChickAndGirl")
		billboardImageView.contentMode = .ScaleAspectFit
		
		billboardImageView.center.x = bounds.width * (152.5 / 375.0)
		billboardImageView.center.y = bounds.height * (148.0 / 170.0)
		
		addSubview(billboardImageView)
	}
	
	private func configureBillboardLabel() {
		billboardLabel = UILabel()
		billboardLabel.frame.size.width = billboardImageView.bounds.width
		billboardLabel.frame.size.height = 29
		
		billboardLabel.textAlignment = .Center
		billboardLabel.font = UIFont.systemFontOfSize(16)
		billboardLabel.textColor = ColorgyColor.TextColor
		
		billboardImageView.addSubview(billboardLabel)
	}
	
	// MARK: - Update UI 
	private func updateBillboardText() {
		billboardLabel.text = billboardText
	}
}

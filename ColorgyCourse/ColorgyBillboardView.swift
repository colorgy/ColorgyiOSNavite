//
//  ColorgyBillboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ColorgyBillboardView: UIView {
	
	private var billboardImageView: UIImageView!
	private var initialImage: UIImage?
	private var errorImage: UIImage?

	public convenience init(initialImageName: String, errorImageName: String) {
		self.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 170.0)))
		initialImage = UIImage(named: initialImageName)
		errorImage = UIImage(named: errorImageName)
		if initialImage == nil {
			print(#file, #function, #line, "initial image not set")
		}
		if errorImage == nil {
			print(#file, #function, #line, "error image not set")
		}
		billboardImageView.image = initialImage
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		configureBillbaordImageView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	private func configureBillbaordImageView() {
		billboardImageView = UIImageView(frame: bounds)
		billboardImageView.contentMode = .ScaleAspectFit
		
		addSubview(billboardImageView)
	}
	
	// MARK: - Update UI 
	public func showInitialImage() {
		billboardImageView.image = initialImage
	}
	
	public func showErrorImage() {
		billboardImageView.image = errorImage
	}
}

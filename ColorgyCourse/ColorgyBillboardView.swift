//
//  ColorgyBillboardView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

/// Billboard is used at dsiplaying a half screen image.
/// Will be used in login, register situations.
/// Billboard can have 2 displaying images.
/// One is for normal state, another is for error state.
final public class ColorgyBillboardView: UIView {
	
	// MARK: - Parameters
	
	private var billboardImageView: UIImageView!
	private var initialImage: UIImage?
	private var errorImage: UIImage?
	private let billboardHeight: CGFloat = 170.0

	// MARK: - Init
	
	/// Initializeing billboard, you have to give the initializer two image names.
	public convenience init(initialImageName: String, errorImageName: String) {
		self.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: billboardHeight)))
		
		// init images.
		initialImage = UIImage(named: initialImageName)
		errorImage = UIImage(named: errorImageName)
		
		// check if image was loaded.
		if initialImage == nil {
			print(#file, #function, #line, "initial image not set")
		}
		if errorImage == nil {
			print(#file, #function, #line, "error image not set")
		}
		
		// set billboard's image to initial state.
		billboardImageView.image = initialImage
	}
	
	override private init(frame: CGRect) {
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
	/// Can change image to normal state image.
	public func showInitialImage() {
		billboardImageView.image = initialImage
	}
	
	/// Can change image to error state image.
	public func showErrorImage() {
		billboardImageView.image = errorImage
	}
}

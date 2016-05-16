//
//  BlurWallViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import WebImage

final public class BlurWallViewCell: UICollectionViewCell {
	
	public var blurImageURL: String! {
		didSet {
			updateImage()
		}
	}
	
	private var blurImageView: UIImageView!
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureBlurImageView()
		configureGradientLayer()
	}
	
	func configureBlurImageView() {
		blurImageView = UIImageView(frame: self.bounds)
		addSubview(blurImageView)
	}
	
	func configureGradientLayer() {
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [UIColor.whiteColor().withAlpha(0.5).CGColor, UIColor.blackColor().withAlpha(0.5).CGColor]
		blurImageView.layer.addSublayer(gradient)
	}
	
	func updateImage() {
		guard let blurImageURL = blurImageURL else { return }
		guard let url = blurImageURL.url else { return }
		blurImageView.setImageWithURL(url, placeholderImage: UIImage(named: "1.png"))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

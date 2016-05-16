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
	
	// MARK: - Parameters
	
	// MARK: Public
	/// Set this url and will auto update the image for you
	public var blurImageURL: String! {
		didSet {
			updateImage()
		}
	}
	
	// MARK: Private
	private var blurImageView: UIImageView!
	
	// MARK: - Init
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureBlurImageView()
		configureGradientLayer()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	/// Configure image view to contain the blur image
	func configureBlurImageView() {
		blurImageView = UIImageView(frame: self.bounds)
		addSubview(blurImageView)
	}
	
	/// Configure gradient layer on image view
	func configureGradientLayer() {
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [UIColor.whiteColor().withAlpha(0.5).CGColor, UIColor.blackColor().withAlpha(0.5).CGColor]
		blurImageView.layer.addSublayer(gradient)
	}
	
	/// Update image with the given url.
	/// Will not update if url is not a valid url string
	func updateImage() {
		guard let blurImageURL = blurImageURL else { return }
		guard let url = blurImageURL.url else { return }
		blurImageView.setImageWithURL(url, placeholderImage: UIImage(named: "1.png"))
	}
	
}

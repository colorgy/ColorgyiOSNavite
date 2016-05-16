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
	}
	
	func configureBlurImageView() {
		blurImageView = UIImageView(frame: self.bounds)
		addSubview(blurImageView)
	}
	
	func updateImage() {
		guard let blurImageURL = blurImageURL else { return }
		guard let url = blurImageURL.url else { return }
		blurImageView.setImageWithURL(url)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

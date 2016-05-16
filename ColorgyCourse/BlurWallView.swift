//
//  BlurWallView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class BlurWallView: UIView {
	
	private var blurWallCollectionView: UICollectionView!
	private var blurWallCollectionViewFlowLayout: UICollectionViewFlowLayout!

	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	func configureBlurWallCollectionView(frame: CGRect) {
		blurWallCollectionViewFlowLayout = UICollectionViewFlowLayout()
		blurWallCollectionViewFlowLayout.itemSize = CGSize(width: frame.width / 2, height: frame.width / 2)
		
		blurWallCollectionView = UICollectionView(frame: frame, collectionViewLayout: blurWallCollectionViewFlowLayout)
		
		addSubview(blurWallCollectionView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

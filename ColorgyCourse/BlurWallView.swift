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
	private let cellIdentifer = "BlurWallViewCell"
	
	public var targets: [AvailableTarget] = [] {
		didSet {
			updateTargets()
		}
	}
	
	private func updateTargets() {
		blurWallCollectionView.reloadData()
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureBlurWallCollectionView(frame)
	}

	func configureBlurWallCollectionView(frame: CGRect) {
		blurWallCollectionViewFlowLayout = UICollectionViewFlowLayout()
		blurWallCollectionViewFlowLayout.itemSize = CGSize(width: frame.width / 2, height: frame.width / 2)
		blurWallCollectionViewFlowLayout.minimumLineSpacing = 0
		blurWallCollectionViewFlowLayout.minimumInteritemSpacing = 0
		blurWallCollectionViewFlowLayout.sectionInset = UIEdgeInsetsZero
		
		blurWallCollectionView = UICollectionView(frame: frame, collectionViewLayout: blurWallCollectionViewFlowLayout)
		blurWallCollectionView.backgroundColor = UIColor.clearColor()
		
		blurWallCollectionView.registerClass(BlurWallViewCell.self, forCellWithReuseIdentifier: cellIdentifer)
		
		blurWallCollectionView.delegate = self
		blurWallCollectionView.dataSource = self
		
		addSubview(blurWallCollectionView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension BlurWallView : UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return targets.count
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifer, forIndexPath: indexPath) as! BlurWallViewCell
		cell.blurImageURL = targets[indexPath.item].avatarBlur2XURL
		return cell
	}
}
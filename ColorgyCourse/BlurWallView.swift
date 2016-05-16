//
//  BlurWallView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol BlurWallViewDelegate: class {
	func blurWallViewAboutToTouchTheEnd()
}

final public class BlurWallView: UIView {
	
	// MARK: - Parameters
	
	// MARK: Private
	/// collection view of blur wall
	private var blurWallCollectionView: UICollectionView!
	/// layout of collection view
	private var blurWallCollectionViewFlowLayout: UICollectionViewFlowLayout!
	/// cell identifier of collection view
	private let cellIdentifer = "BlurWallViewCell"
	/// This is where you start to request for more data
	private let preloadPoint = 10
	
	
	// MARK: Public
	/// Set this after list updated, will auto update ui
	public var targetList: AvailableTargetList = AvailableTargetList() {
		didSet {
			updateTargets()
		}
	}
	/// Delegate of this blur wall view
	public weak var delegate: BlurWallViewDelegate?

	// MARK: - Init
	
	/// Initialization
	public init(frame: CGRect, delegate: BlurWallViewDelegate?) {
		super.init(frame: frame)
		
		self.delegate = delegate
		
		configureBlurWallCollectionView(frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configuration
	
	/// Configure blur wall collection view
	func configureBlurWallCollectionView(frame: CGRect) {
		blurWallCollectionViewFlowLayout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 1.5
		let itemWidth = frame.width / 2 - spacing
		blurWallCollectionViewFlowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		blurWallCollectionViewFlowLayout.minimumLineSpacing = spacing * 2
		blurWallCollectionViewFlowLayout.minimumInteritemSpacing = spacing * 2
		blurWallCollectionViewFlowLayout.sectionInset = UIEdgeInsetsZero
		
		blurWallCollectionView = UICollectionView(frame: frame, collectionViewLayout: blurWallCollectionViewFlowLayout)
		blurWallCollectionView.backgroundColor = UIColor.clearColor()
		
		blurWallCollectionView.registerClass(BlurWallViewCell.self, forCellWithReuseIdentifier: cellIdentifer)
		
		blurWallCollectionView.delegate = self
		blurWallCollectionView.dataSource = self
		
		addSubview(blurWallCollectionView)
	}

	// MARK: - Update UI
	/// Update targets on blur wall
	private func updateTargets() {
		blurWallCollectionView.reloadData()
	}
	
	// MARK: - Methods
	private func checkIfReachingTheEnd(indexPath: NSIndexPath) {
		if indexPath.item == targetList.count - preloadPoint {
			delegate?.blurWallViewAboutToTouchTheEnd()
		}
	}
}

// MARK: - Collection View Delegate and DataSource
extension BlurWallView : UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return targetList.count
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifer, forIndexPath: indexPath) as! BlurWallViewCell
		cell.blurImageURL = targetList[indexPath.item].avatarBlur2XURL
		checkIfReachingTheEnd(indexPath)
		return cell
	}
}
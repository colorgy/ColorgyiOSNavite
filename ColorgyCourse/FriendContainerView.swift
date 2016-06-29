//
//  FriendContainerView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class FriendContainerView: UIView {
	
	private var friendListCollectionView: UICollectionView!
	private var friendListCollectionViewFlowLayout: UICollectionViewFlowLayout!

	// MARK: - Init
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureFriendListCollectionView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	struct Keys {
		static let cellIdentifer = "cell"
	}
	
	// MARK: - Configuration
	private func configureFriendListCollectionView() {
		
		// configure layout
		friendListCollectionViewFlowLayout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 2.0
		let numberOfCellPerRow: CGFloat = 2
		let itemWidth: CGFloat = (bounds.width - 3 * spacing) / numberOfCellPerRow
		friendListCollectionViewFlowLayout.minimumLineSpacing = spacing
		friendListCollectionViewFlowLayout.minimumInteritemSpacing = spacing
		friendListCollectionViewFlowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		
		// configure collection view
		friendListCollectionView = UICollectionView(frame: bounds, collectionViewLayout: friendListCollectionViewFlowLayout)
		friendListCollectionView.contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
		friendListCollectionView.registerClass(FriendContainerCell.self, forCellWithReuseIdentifier: Keys.cellIdentifer)
		
		friendListCollectionView.backgroundColor = UIColor.clearColor()
		
		friendListCollectionView.delegate = self
		friendListCollectionView.dataSource = self
		
		addSubview(friendListCollectionView)
	}
}

extension FriendContainerView : UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 100
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Keys.cellIdentifer, forIndexPath: indexPath) as! FriendContainerCell
		cell.setImageName(["4.jpg", "2.jpg", "3.jpg", "5.jpg", "6.jpg", "7.jpg"][random() % 6])
		return cell
	}
}

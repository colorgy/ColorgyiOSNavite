//
//  FriendContainerCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class FriendContainerCell: UICollectionViewCell {
	
	private var profileImageView: UIImageView!
	
	// MARK: - Init
    override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configurePorfileImageView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configurePorfileImageView() {
		profileImageView = UIImageView(frame: bounds)
		
		profileImageView.contentMode = .ScaleAspectFill
		profileImageView.image = UIImage(named: "1.png")
		profileImageView.clipsToBounds = true
		
		addSubview(profileImageView)
	}
	
	public func setImageName(name: String) {
		profileImageView.image = UIImage(named: name)
	}
}

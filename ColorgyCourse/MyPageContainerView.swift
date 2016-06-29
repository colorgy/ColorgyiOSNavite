//
//  MyPageContainerView.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MyPageContainerView: UIScrollView {
	
	private var profileImageView: UIImageView!
	private var personalInfoView: MyPagePersonalInfoView!
	private var moreOptionView: MyPageMoreOptionView!

	// MARK: - Init
	public init(frame: CGRect, moreOptionViewDelegate: MyPageMoreOptionViewDelegate?) {
		super.init(frame: frame)
		
		// configure
		configureProfileImageView()
		configurePersonalInfoView()
		configureMoreOptionView()
		
		// set delegation
		moreOptionView.delegate = moreOptionViewDelegate
		self.delegate = self
		
		contentSize = CGSize(width: bounds.width, height: moreOptionView.frame.maxY*2)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureProfileImageView() {
		profileImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: bounds.width, height: bounds.width)))
		
		profileImageView.contentMode = .ScaleAspectFill
		profileImageView.image = UIImage(named: "1.png")
		
		addSubview(profileImageView)
	}
	
	private func configurePersonalInfoView() {
		personalInfoView = MyPagePersonalInfoView(name: "揪揪掰掰", school: "耶黑黑嘿嘿")
		personalInfoView.move(0, pointBelow: profileImageView)
		addSubview(personalInfoView)
	}
	
	private func configureMoreOptionView() {
		moreOptionView = MyPageMoreOptionView()
		moreOptionView.move(16, pointBelow: personalInfoView)
		addSubview(moreOptionView)
	}

	private func updateProfilePhoto(with offset: CGFloat) {
		// arrange
		profileImageView.frame.origin.y = offset
		// resize
		profileImageView.frame.size = CGSize(width: bounds.width, height: bounds.width - offset)
	}
}

extension MyPageContainerView : UIScrollViewDelegate {
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		// will be negative or 0.
		// never be positive.
		let offsetY = min(scrollView.contentOffset.y, 0)
		updateProfilePhoto(with: offsetY)
	}
}
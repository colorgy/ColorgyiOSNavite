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
	public init(frame: CGRect, moreOptionViewDelegate: MyPageMoreOptionViewDelegate?, personalInfoViewDelegate: MyPagePersonalInfoViewDelegate?) {
		super.init(frame: frame)
		
		// configure
		configureProfileImageView()
		configurePersonalInfoView()
		configureMoreOptionView()
		
		// set delegation
		moreOptionView.delegate = moreOptionViewDelegate
		personalInfoView.delegate = personalInfoViewDelegate
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
		profileImageView.image = UIImage(named: "5.jpg")
		
		addSubview(profileImageView)
	}
	
	private func configurePersonalInfoView() {
		personalInfoView = MyPagePersonalInfoView(name: "我是青峯", school: "耶黑黑嘿嘿黑黑嘿嘿黑黑嘿嘿", greetings: 21983892)
		personalInfoView.move(0, pointBelow: profileImageView)
		addSubview(personalInfoView)
	}
	
	private func configureMoreOptionView() {
		moreOptionView = MyPageMoreOptionView()
		moreOptionView.move(0, pointBelow: personalInfoView)
		addSubview(moreOptionView)
	}

	private func updateProfilePhoto(with offset: CGFloat) {
		// check move up or down
		if offset <= 0 {
			// move down
			// arrange
			profileImageView.frame.origin.y = offset
			// resize
			profileImageView.frame.size = CGSize(width: bounds.width, height: bounds.width - offset)
		} else {
			// move up
			profileImageView.frame.origin.y = offset * 0.3
		}
	}
}

extension MyPageContainerView : UIScrollViewDelegate {
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		// will be negative or 0.
		// never be positive.
		let offsetY = scrollView.contentOffset.y
		updateProfilePhoto(with: offsetY)
	}
}
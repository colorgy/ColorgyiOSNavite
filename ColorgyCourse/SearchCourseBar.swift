//
//  SearchCourseBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class SearchCourseBar: UIView {
	
	// MARK: - Parameters
	private var searchTextField: UITextField!
	private var cancelButton: UIButton!
	private var searchIconImageVIew: UIImageView!
	
	// MARK: - Init
	public override init(frame: CGRect) {
		super.init(frame: frame)
		configureIconImageView()
		configureCancelButton()
		configureSearchTextField()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureSearchTextField() {
		searchTextField = UITextField()
		searchTextField.frame.size.width = bounds.width - (searchIconImageVIew.bounds.width + cancelButton.bounds.width) - 4 * 16
		searchTextField.frame.size.height = 18
		searchTextField.center.y = bounds.midY
		searchTextField.frame.origin.x = searchIconImageVIew.frame.origin.x + 16
		
		addSubview(searchTextField)
	}
	
	private func configureCancelButton() {
		cancelButton = UIButton(type: UIButtonType.System)
		cancelButton.setTitle("取消", forState: UIControlState.Normal)
		cancelButton.titleLabel?.font = UIFont.systemFontOfSize(16)
		cancelButton.sizeToFit()
		cancelButton.center.y = bounds.midY
		cancelButton.frame.origin.x = bounds.width - cancelButton.bounds.width - 16
		
		addSubview(cancelButton)
	}
	
	private func configureIconImageView() {
		searchIconImageVIew = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 20, height: 20)))
		searchIconImageVIew.image = UIImage(named: "OrangeSearchButton")
		searchIconImageVIew.center.y = bounds.midY
		searchIconImageVIew.frame.origin.x = 16
		
		addSubview(searchIconImageVIew)
	}
}

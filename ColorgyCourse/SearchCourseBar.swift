//
//  SearchCourseBar.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol SearchCourseBarDelegate: class {
	func searchCourseBarCancelButtonClicked()
	func searchCourseBar(didUpdateSearchText text: String?)
}

final public class SearchCourseBar: UIView {
	
	// MARK: - Parameters
	private var searchTextField: UITextField!
	private var cancelButton: UIButton!
	private var searchIconImageVIew: UIImageView!
	
	private var centerOfBar: CGPoint {
		get {
			return CGPoint(x: bounds.midX, y: (bounds.height - 20) / 2 + 20)
		}
	}
	
	public weak var delegate: SearchCourseBarDelegate?
	
	// MARK: - Init
	public init(frame: CGRect, delegate: SearchCourseBarDelegate?) {
		super.init(frame: frame)
		self.delegate = delegate
		configureIconImageView()
		configureCancelButton()
		configureSearchTextField()
		backgroundColor = UIColor.whiteColor()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Configuration
	private func configureSearchTextField() {
		searchTextField = UITextField()
		searchTextField.frame.size.width = bounds.width - (searchIconImageVIew.bounds.width + cancelButton.bounds.width) - 4 * 16
		searchTextField.frame.size.height = 18
		searchTextField.tintColor = ColorgyColor.MainOrange
		searchTextField.center.y = centerOfBar.y
		searchTextField.frame.origin.x = searchIconImageVIew.frame.origin.x + 16 * 2
		
		searchTextField.placeholder = "搜尋課程..."
		
		searchTextField.addTarget(self, action: #selector(SearchCourseBar.searchTextFieldTextChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
		
		addSubview(searchTextField)
	}
	
	private func configureCancelButton() {
		cancelButton = UIButton(type: UIButtonType.System)
		cancelButton.setTitle("取消", forState: UIControlState.Normal)
		cancelButton.tintColor = ColorgyColor.MainOrange
		cancelButton.titleLabel?.font = UIFont.systemFontOfSize(16)
		cancelButton.sizeToFit()
		cancelButton.center.y = centerOfBar.y
		cancelButton.frame.origin.x = bounds.width - cancelButton.bounds.width - 16
		
		cancelButton.addTarget(self, action: #selector(SearchCourseBar.cancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		addSubview(cancelButton)
	}
	
	private func configureIconImageView() {
		searchIconImageVIew = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 20, height: 20)))
		searchIconImageVIew.image = UIImage(named: "OrangeSearchButton")
		searchIconImageVIew.center.y = centerOfBar.y
		searchIconImageVIew.frame.origin.x = 16
		
		addSubview(searchIconImageVIew)
	}
	
	// MARK: - Methods
	@objc private func cancelButtonClicked() {
		endEditing(true)
		delegate?.searchCourseBarCancelButtonClicked()
	}
	
	@objc private func searchTextFieldTextChanged(textField: UITextField) {
		delegate?.searchCourseBar(didUpdateSearchText: textField.text)
	}
}

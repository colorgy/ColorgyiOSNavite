//
//  ReenterPhoneViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ReenterPhoneViewController: UIViewController {
	
	public private(set) var reenterPhoneNumberView: ReenterPhoneNumberView!
	private var _title: String?
	private var _subtitle: String?
	
	public init(title: String?, subtitle: String?) {
		super.init(nibName: nil, bundle: nil)
		self.modalPresentationStyle = .Custom
		self._title = title
		self._subtitle = subtitle
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.blackColor().withAlpha(0.7)
		
		reenterPhoneNumberView = ReenterPhoneNumberView(title: _title, subtitle: _subtitle, delegate: self)
		view.addSubview(reenterPhoneNumberView)
		moveReenterPhoneNumberViewToInitialPosition()
    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		registerNotification()
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		unregisterNotification()
	}
	
	// MARK: - Notification
	private func registerNotification() {
		// keyboard
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	private func unregisterNotification() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - Handle Keyboard
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let kbRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
			print(kbRect)
			moveReenterPhoneNumberViewToKeyboardShowPosition(kbRect.size)
		}
	}
	
	@objc private func keyboardWillHide(notification: NSNotification) {
		moveReenterPhoneNumberViewToInitialPosition()
	}
	
	// MARK: - Move Reenter Phone View
	private func moveReenterPhoneNumberViewToInitialPosition() {
		reenterPhoneNumberView.centerHorizontallyToSuperview()
		reenterPhoneNumberView.center.y = view.bounds.height * 0.4
	}

	private func moveReenterPhoneNumberViewToKeyboardShowPosition(keyboardSize: CGSize) {
		reenterPhoneNumberView.center.y = (view.bounds.height - keyboardSize.height) / 2
	}
}

extension ReenterPhoneViewController : ReenterPhoneNumberViewDelegate {
	public func reenterPhoneNumberViewConfirmButtonClicked() {
		
	}
	
	public func reenterPhoneNumberViewCancelButtonClicked() {
		view.endEditing(true)
		dismissViewControllerAnimated(true, completion: nil)
	}
}
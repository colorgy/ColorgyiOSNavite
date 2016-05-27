//
//  ReenterPhoneViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ReenterPhoneViewController: UIViewController {
	
	private var reenterPhoneNumberView: ReenterPhoneNumberView!

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		reenterPhoneNumberView = ReenterPhoneNumberView(title: "yGGHJgo", subtitle: "lsakgjlsaklaskl", delegate: self)
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
	func registerNotification() {
		// keyboard
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func unregisterNotification() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - Handle Keyboard
	func keyboardWillShow(notification: NSNotification) {
		if let kbSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
			print(kbSize)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		
	}
	
	// MARK: - Move Reenter Phone View
	private func moveReenterPhoneNumberViewToInitialPosition() {
		reenterPhoneNumberView.centerHorizontallyToSuperview()
		reenterPhoneNumberView.center.y = view.bounds.height * 0.4
	}

	private func moveReenterPhoneNumberViewToKeyboardShowPosition(keyboardSize: CGSize) {
		reenterPhoneNumberView.center.y = view.bounds.height * 0.4
	}
}

extension ReenterPhoneViewController : ReenterPhoneNumberViewDelegate {
	public func reenterPhoneNumberViewConfirmButtonClicked() {
		
	}
	
	public func reenterPhoneNumberViewCancelButtonClicked() {
		
	}
}
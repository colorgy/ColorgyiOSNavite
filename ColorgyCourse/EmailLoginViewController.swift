//
//  EmailLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class EmailLoginViewController: UIViewController {
	
	// MARK: - Parameters
	private var emailInputView: IconedTextInputView!
	private var passwordInputView: IconedTextInputView!
	private var viewModel: EmailLoginViewModel?
	private var loginButton: UIButton!

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// configure view
		configureLoginView()
		
		// configure view
		view.backgroundColor = ColorgyColor.BackgroundColor
		title = "登入"
		
		// assign view model
		viewModel = EmailLoginViewModel(delegate: self)
		
		let e = EmailInputBox()
		e.frame.origin.y = 250
		view.addSubview(e)
		let p = PasswordInputBox()
		p.frame.origin.y = 250 + 44 * 1
		view.addSubview(p)
		let p2 = ConfirmPasswordInputBox()
		p2.frame.origin.y = 250 + 44 * 2
		view.addSubview(p2)
		p2.bindPasswordInputBox(p)
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		showNavigationBar()
	}
	
	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		hideNavigationBar()
	}
	
	// MARK: - Configuration
	private func configureLoginView() {
		
		emailInputView = IconedTextInputView(imageName: "grayEmailIcon", placeholder: "輸入信箱", keyboardType: .Default, isPassword: false, delegate: self)
		passwordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
		
		// arrange view
		let initialPosition: CGFloat = 66
		let _ = [emailInputView, passwordInputView].reduce(initialPosition, combine: arrangeView)
		
		// add subview
		[emailInputView, passwordInputView].forEach(view.addSubview)
		
		// configure button
		configureLoginButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: IconedTextInputView) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 4 + view.bounds.height
	}
	
	private func configureLoginButton() {
		
		loginButton = UIButton(type: UIButtonType.System)
		loginButton.backgroundColor = ColorgyColor.MainOrange
		loginButton.tintColor = UIColor.whiteColor()
		loginButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
		loginButton.setTitle("登入", forState: UIControlState.Normal)
		
		loginButton.layer.cornerRadius = 4.0
		
		loginButton.frame.size = CGSize(width: 249, height: 44)
		
		// buttom of confirmPasswordInputView
		loginButton.frame.origin.y = passwordInputView.frame.maxY + 36
		loginButton.center.x = passwordInputView.center.x
		
		loginButton.anchorViewTo(view)
		
		loginButton.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	// MARK: - Helper
	private func showNavigationBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func hideNavigationBar() {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	// MARK: - Selector
	@objc private func loginButtonClicked() {
		viewModel?.loginToColorgy()
	}
}

extension EmailLoginViewController : EmailLoginViewModelDelegate {
	
	public func emailLoginViewModel(successfullyLoginToColorgy userHasPossibleOrganization: Bool) {
		print(userHasPossibleOrganization)
	}
	
	public func emailLoginViewModel(failToLoginColorgy error: ColorgyLoginError, afError: AFError?) {
		print(error, afError)
	}
	
	public func emailLoginViewModel(invalidRequiredInformation error: InvalidLoginInformationError) {
		print(error)
	}
	
	public func emailLoginViewModel(failToRetrieveDataFromServre error: APIError, afError: AFError?) {
		print(error, afError)
	}
}

extension EmailLoginViewController : IconedTextInputViewDelegate {
	
	public func iconedTextInputViewShouldReturn(textInputView: IconedTextInputView) {
		
		if textInputView == emailInputView {
			passwordInputView.becomeFirstResponder()
		} else if textInputView == passwordInputView {
			viewModel?.loginToColorgy()
		}
	}
	
	public func iconedTextInputViewTextChanged(textInputView: IconedTextInputView, changedText: String?) {
		
		if textInputView == emailInputView {
			viewModel?.email = changedText
		} else if textInputView == passwordInputView {
			viewModel?.password = changedText
		}
	}
}
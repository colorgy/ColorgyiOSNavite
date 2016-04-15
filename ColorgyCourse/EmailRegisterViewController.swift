//
//  EmailRegisterViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class EmailRegisterViewController: UIViewController {
	
	// MARK: - Parameters
	
	// MARK: Register
	private var usernameInputView: IconedTextInputView?
	private var emailInputView: IconedTextInputView?
	private var passwordInputView: IconedTextInputView?
	private var confirmPasswordInputView: IconedTextInputView?
	private var submitRegistrationButton: UIButton?
	
	// MARK: Check Email
	private var hintLabel: UILabel?
	private var emailLabel: UILabel?
	private var hintSubLabel: UILabel?
	private var checkEmailButton: UIButton?
	private var stillNotRecieveingLabel: UILabel?
	
	// MARK: View Model
	private var viewModel: EmailRegisterViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureRegisterView()
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		viewModel = EmailRegisterViewModel(delegate: self)
    }
	
	// MARK: - Configure
	private func configureRegisterView() {
		usernameInputView = IconedTextInputView(imageName: "grayUserNameIcon", placeholder: "輸入名稱", keyboardType: .Default, isPassword: false, delegate: self)
		emailInputView = IconedTextInputView(imageName: "grayEmailIcon", placeholder: "輸入信箱", keyboardType: .EmailAddress, isPassword: false, delegate: self)
		passwordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
		confirmPasswordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "再次輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
		
		// arrange
		let initialY: CGFloat = 66.0
		let _ = [usernameInputView!, emailInputView!, passwordInputView!, confirmPasswordInputView!].reduce(initialY, combine: arrangeView)
		
		// add view
		[usernameInputView!, emailInputView!, passwordInputView!, confirmPasswordInputView!].forEach(view.addSubview)
		
		// configure button
		configureRegistrationButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: IconedTextInputView) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 4 + view.bounds.height
	}
	
	private func configureRegistrationButton() {
		
		submitRegistrationButton = UIButton(type: UIButtonType.System)
		submitRegistrationButton?.backgroundColor = ColorgyColor.MainOrange
		submitRegistrationButton?.tintColor = UIColor.whiteColor()
		submitRegistrationButton?.titleLabel?.font = UIFont.systemFontOfSize(14.0)
		submitRegistrationButton?.setTitle("註冊", forState: UIControlState.Normal)
		
		submitRegistrationButton?.layer.cornerRadius = 4.0
		
		submitRegistrationButton?.frame.size = CGSize(width: 249, height: 44)
		
		// buttom of confirmPasswordInputView
		submitRegistrationButton?.frame.origin.y = confirmPasswordInputView!.frame.maxY + 36
		submitRegistrationButton?.center.x = confirmPasswordInputView!.center.x
		
		submitRegistrationButton?.anchorViewTo(view)
		
		submitRegistrationButton?.addTarget(self, action: #selector(submitRegistrationButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	@objc private func submitRegistrationButtonClicked() {
		viewModel?.submitRegistration()
	}
	
	private func configureCheckEmailView() {
		
	}
	
	// MARK: - Layout
	private func layoutRegisterView() {
		
	}
	
	private func layoutCheckEmailView() {
		
	}
	
	private func removeAllLayout() {
		
	}
}

extension EmailRegisterViewController : IconedTextInputViewDelegate {
	
	public func iconedTextInputViewShouldReturn(textInputView: IconedTextInputView) {
		
		if textInputView == usernameInputView {
			emailInputView?.becomeFirstResponder()
		} else if textInputView == emailInputView {
			passwordInputView?.becomeFirstResponder()
		} else if textInputView == passwordInputView {
			confirmPasswordInputView?.becomeFirstResponder()
		} else if textInputView == confirmPasswordInputView {
			confirmPasswordInputView?.resignFirstResponder()
			viewModel?.submitRegistration()
		}
	}
	
	public func iconedTextInputViewTextChanged(textInputView: IconedTextInputView, changedText: String?) {
		
		if textInputView == usernameInputView {
			print(changedText)
			viewModel?.userName = changedText
		} else if textInputView == emailInputView {
			print(changedText)
			viewModel?.email = changedText
		} else if textInputView == passwordInputView {
			print(changedText)
			viewModel?.password = changedText
		} else if textInputView == confirmPasswordInputView {
			print(changedText)
			viewModel?.confirmPassword = changedText
		}
	}
}

extension EmailRegisterViewController : EmailRegisterViewModelDelegate {
	
	public func emailRegisterViewModelSuccessfullySubmitRegistration() {
		let alert = UIAlertController(title: "你輸入的資料有誤哦！", message: nil, preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		
		let message: String? = "你可以登入惹，但是我還沒串API嗚嗚"
		
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	public func emailRegisterViewModel(invalidRequiredInformation error: InvalidInformationError) {
		
		let alert = UIAlertController(title: "你輸入的資料有誤哦！", message: nil, preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		
		var message: String?
		switch error {
		case .NoUserName:
			message = "請輸入名字"
		case .InvalidEmail:
			message = "Email格式不正確，請輸入正確的Email唷！"
		case .PasswordMustGreaterThanOrEqualTo8Charaters:
			message = "密碼要大於8個字元喔！"
		case .TwoPasswordsDontMatch:
			message = "兩個密碼不一樣，請再次確認唷！"
		}
		
		alert.message = message
		
		dispatch_async(dispatch_get_main_queue()) { 
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	public func emailRegisterViewModel(errorSumittingRequest error: APIError, afError: AFError?) {
		// TODO: finish fail to connect api
	}
}
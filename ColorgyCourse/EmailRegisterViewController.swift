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
	private var emailInputBox: EmailInputBox!
	private var phoneInputBox: PhoneInputBox!
	private var passwordInputBox: PasswordInputBox!
	private var confirmPasswordInputBox: ConfirmPasswordInputBox!
	private var registerButton: ColorgyFullScreenButton!
	
	private var billboard: ColorgyBillboardView!
	
	// MARK: View Model
	private var viewModel: EmailRegisterViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureBillboard()
		configureRegistrationView()
		
		// configure view
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		// assign view model
		viewModel = EmailRegisterViewModel(delegate: self)
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// MARK: - Configuration
	private func configureBillboard() {
		billboard = ColorgyBillboardView(initialImageName: "RegisterBillboard", errorImageName: "RegisterErrorBillboard")
		
		view.addSubview(billboard)
	}
	
	private func configureRegistrationView() {
		emailInputBox = EmailInputBox()
		phoneInputBox = PhoneInputBox()
		passwordInputBox = PasswordInputBox()
		confirmPasswordInputBox = ConfirmPasswordInputBox()
		
		// arrange views
		let views = [emailInputBox, phoneInputBox, passwordInputBox, confirmPasswordInputBox]
		let initialPosition = CGPoint(x: 0, y: 170)
		_ = views.reduce(initialPosition.y, combine: arrangeView)
		views.forEach(view.addSubview)
		views.forEach({ $0.inputBoxDelegate = self })
		
		// bind password validator
		confirmPasswordInputBox.bindPasswordInputBox(passwordInputBox)
		
		configureRegisterButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: InputBox) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 2 + view.bounds.height
	}
	
	private func configureRegisterButton() {
		registerButton = ColorgyFullScreenButton(title: "確認註冊", delegate: self)
		registerButton.move(24, pointBelow: confirmPasswordInputBox)
		view.addSubview(registerButton)
	}
}

extension EmailRegisterViewController : EmailRegisterViewModelDelegate {

	/// Everything ok here. Create an account and get token.
	public func emailRegisterViewModelSuccessfullySubmitRegistration() {
		// go to phone validation view
	}
	
	/// Something wrong in given information
	public func emailRegisterViewModel(invalidRequiredInformation error: InvalidInformationError) {
		
		let alert = UIAlertController(title: "你輸入的資料有誤哦！", message: nil, preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		
		var message: String?
		switch error {
		case .InvalidEmail:
			message = "Email格式不正確，請輸入正確的Email唷！"
		case .InvalidPhoneNumber:
			message = "請輸入正確手機號碼"
		case .PasswordLessThen8Characters:
			message = "密碼要大於8個字元喔！"
		case .TwoPasswordsDontMatch:
			message = "兩個密碼不一樣，請再次確認唷！"
		}
		
		alert.message = message
		
		dispatch_async(dispatch_get_main_queue()) { 
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	/// This happened when something is wrong when creating account.
	public func emailRegisterViewModel(errorSumittingRequest error: APIError, afError: AFError?) {
		let alert = UIAlertController(title: "Server 錯誤", message: "\(error)\n\(afError?.statusCode)\n\(afError?.responseBody)", preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	/// This happened when something is wrong after creating account. Maybe fail to get access token.
	public func emailRegisterViewModel(errorAfterSumittingRequest error: ColorgyLoginError, afError: AFError?) {
		let alert = UIAlertController(title: "登入 錯誤", message: "\(error)\n\(afError?.statusCode)\n\(afError?.responseBody)", preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
}

extension EmailRegisterViewController : InputBoxDelegate {
	public func inputBoxEditingChanged(inputbox: InputBox, text: String?) {
		switch inputbox {
		case emailInputBox:
			viewModel?.updateEmail(with: text)
		case phoneInputBox:
			viewModel?.updatePhoneNumber(with: text)
		case passwordInputBox:
			viewModel?.updatePassword(with: text)
		case confirmPasswordInputBox:
			viewModel?.updateConfirmPassword(with: text)
		default: break
		}
	}
}

extension EmailRegisterViewController : ColorgyFullScreenButtonDelegate {
	public func colorgyFullScreenButtonClicked(button: ColorgyFullScreenButton) {
		if button == registerButton {
			viewModel?.submitRegistration()
		}
	}
}
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
	// MARK: View Model
	private var viewModel: EmailRegisterViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureRegistrationView()
		
		// configure view
		view.backgroundColor = ColorgyColor.BackgroundColor
		title = "註冊"
		
		// assign view model
		viewModel = EmailRegisterViewModel(delegate: self)
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// MARK: - Configuration
	private func configureRegistrationView() {
		emailInputBox = EmailInputBox()
		phoneInputBox = PhoneInputBox()
		passwordInputBox = PasswordInputBox()
		confirmPasswordInputBox = ConfirmPasswordInputBox()
		
		let views = [emailInputBox, phoneInputBox, passwordInputBox, confirmPasswordInputBox]
		let initialPosition = CGPoint(x: 0, y: 120)
		views.reduce(initialPosition.y, combine: arrangeView)
		views.forEach(view.addSubview)
		
		configureRegisterButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: InputBox) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 4 + view.bounds.height
	}
	
	private func configureRegisterButton() {
		registerButton = ColorgyFullScreenButton(title: "確認註冊", delegate: self)
		registerButton.frame.origin.y = confirmPasswordInputBox.frame.maxY + 24
		view.addSubview(registerButton)
		registerButton.centerHorizontallyToSuperview()
	}
}

extension EmailRegisterViewController : EmailRegisterViewModelDelegate {
	
	public func emailRegisterViewModelSuccessfullySubmitRegistration() {

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
	
	public func emailRegisterViewModel(errorSumittingRequest error: APIError, afError: AFError?) {
		let alert = UIAlertController(title: "Server 錯誤", message: "\(error)\n\(afError?.statusCode)\n\(afError?.responseBody)", preferredStyle: .Alert)
		let ok = UIAlertAction(title: "知道了", style: .Default, handler: nil)
		alert.addAction(ok)
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
}

extension EmailRegisterViewController : ColorgyFullScreenButtonDelegate {
	public func colorgyFullScreenButtonClicked(button: ColorgyFullScreenButton) {
		if button == registerButton {
			
		}
	}
}
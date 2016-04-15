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
	private var usernameInputView: IconedTextInputView!
	private var emailInputView: IconedTextInputView!
	private var passwordInputView: IconedTextInputView!
	private var confirmPasswordInputView: IconedTextInputView!
	private var submitRegistrationButton: UIButton!
	
	// MARK: Check Email
	private var hintLabel: UILabel!
	private var emailLabel: UILabel!
	private var hintSublabel: UILabel!
	private var checkEmailButton: UIButton!
	private var stillNotRecievingLabel: UILabel!
	
	// MARK: View Model
	private var viewModel: EmailRegisterViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureRegisterView()
		configureCheckEmailView()
		
		// hide all view first
		hideAllViews()
		
		// first shoe register view
		showRegisterView()
		
		// configure view
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		// assign view model
		viewModel = EmailRegisterViewModel(delegate: self)
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
	private func configureRegisterView() {
		usernameInputView = IconedTextInputView(imageName: "grayUserNameIcon", placeholder: "輸入名稱", keyboardType: .Default, isPassword: false, delegate: self)
		emailInputView = IconedTextInputView(imageName: "grayEmailIcon", placeholder: "輸入信箱", keyboardType: .EmailAddress, isPassword: false, delegate: self)
		passwordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
		confirmPasswordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "再次輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
		
		// arrange
		let initialY: CGFloat = 66.0
		let _ = [usernameInputView, emailInputView, passwordInputView, confirmPasswordInputView].reduce(initialY, combine: arrangeView)
		
		// add view
		[usernameInputView, emailInputView, passwordInputView, confirmPasswordInputView].forEach(view.addSubview)
		
		// configure button
		configureRegistrationButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: IconedTextInputView) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 4 + view.bounds.height
	}
	
	private func configureRegistrationButton() {
		
		submitRegistrationButton = UIButton(type: UIButtonType.System)
		submitRegistrationButton.backgroundColor = ColorgyColor.MainOrange
		submitRegistrationButton.tintColor = UIColor.whiteColor()
		submitRegistrationButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
		submitRegistrationButton.setTitle("註冊", forState: UIControlState.Normal)
		
		submitRegistrationButton.layer.cornerRadius = 4.0
		
		submitRegistrationButton.frame.size = CGSize(width: 249, height: 44)
		
		// buttom of confirmPasswordInputView
		submitRegistrationButton.frame.origin.y = confirmPasswordInputView.frame.maxY + 36
		submitRegistrationButton.center.x = confirmPasswordInputView.center.x
		
		submitRegistrationButton.anchorViewTo(view)
		
		submitRegistrationButton.addTarget(self, action: #selector(submitRegistrationButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	private func configureCheckEmailView() {
		
		hintLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
		hintLabel.textAlignment = .Center
		hintLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
		hintLabel.text = "五分鐘內驗證信將送到"
		hintLabel.font = UIFont.systemFontOfSize(18)
		hintLabel.sizeToFit()
		
		emailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
		emailLabel.textAlignment = .Center
		emailLabel.textColor = ColorgyColor.MainOrange
		emailLabel.font = UIFont.systemFontOfSize(14)
		emailLabel.sizeToFit()
		
		hintSublabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
		hintSublabel.textAlignment = .Center
		hintSublabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
		hintSublabel.text = "趕快去收信吧！"
		hintSublabel.font = UIFont.systemFontOfSize(18)
		hintSublabel.sizeToFit()
		
		// arrange
		hintLabel.center.x = view.center.x
		emailLabel.center.x = view.center.x
		hintSublabel.center.x = view.center.x
		
		hintLabel.frame.origin.y = 65
		emailLabel.frame.origin.y = hintLabel.frame.maxY + 8
		hintSublabel.frame.origin.y = emailLabel.frame.maxY + 8
		
		// add subview
		view.addSubview(hintLabel)
		view.addSubview(emailLabel)
		view.addSubview(hintSublabel)
		
		// button
		checkEmailButton = UIButton(type: UIButtonType.System)
		checkEmailButton.frame = CGRect(x: 0, y: 0, width: 249, height: 44)
		checkEmailButton.backgroundColor = ColorgyColor.MainOrange
		checkEmailButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		checkEmailButton.setTitle("確認收到認證信", forState: UIControlState.Normal)
		checkEmailButton.titleLabel?.font = UIFont.systemFontOfSize(14)
		checkEmailButton.layer.cornerRadius = 4.0
		checkEmailButton.addTarget(self, action: #selector(checkEmailButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		
		checkEmailButton.center.x = view.center.x
		checkEmailButton.center.y = hintSublabel.frame.maxY + 66
		
		view.addSubview(checkEmailButton)
		
		stillNotRecievingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
		stillNotRecievingLabel.textAlignment = .Center
		stillNotRecievingLabel.textColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 198/255.0, alpha: 1)
		stillNotRecievingLabel.text = "還是沒收到？"
		stillNotRecievingLabel.font = UIFont.systemFontOfSize(14)
		stillNotRecievingLabel.sizeToFit()
		stillNotRecievingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stillNotRecievingEmailClicked)))
		stillNotRecievingLabel.userInteractionEnabled = true
		
		stillNotRecievingLabel.center.x = view.center.x
		stillNotRecievingLabel.center.y = checkEmailButton.frame.maxY + 16
		
		view.addSubview(stillNotRecievingLabel)
	}
	
	// MARK: - Helper
	private func showNavigationBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func hideNavigationBar() {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	// MARK: - Selectors
	@objc private func submitRegistrationButtonClicked() {
		viewModel?.submitRegistration()
	}
	
	@objc private func checkEmailButtonClicked() {
		
	}
	
	@objc private func stillNotRecievingEmailClicked() {
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			let alert = UIAlertController(title: "還是沒收到驗證信嗎？", message: "你可以到粉絲專頁將你的問題私訊給我們，我們將有專人幫您處理！", preferredStyle: .Alert)
			let ok = UIAlertAction(title: "前往粉專", style: .Cancel) { (action: UIAlertAction) in
				if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://profile/1529686803975150")!) {
					UIApplication.sharedApplication().openURL(NSURL(string: "fb://profile/1529686803975150")!)
				} else {
					UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/1529686803975150")!)
				}
			}
			let cancel = UIAlertAction(title: "取消", style: .Default, handler: nil)
			alert.addAction(ok)
			alert.addAction(cancel)
			self.presentViewController(alert, animated: true, completion: nil)
		})
	}
	
	// MARK: - Layout
	private func showRegisterView() {
		usernameInputView.show()
		emailInputView.show()
		passwordInputView.show()
		confirmPasswordInputView.show()
		submitRegistrationButton.show()
	}
	
	private func showCheckEmailView() {
		hintLabel.show()
		emailLabel.show()
		emailLabel.text = viewModel?.email
		hintSublabel.show()
		checkEmailButton.show()
		stillNotRecievingLabel.show()
	}
	
	private func hideAllViews() {
		
		usernameInputView.hide()
		emailInputView.hide()
		passwordInputView.hide()
		confirmPasswordInputView.hide()
		submitRegistrationButton.hide()
		
		hintLabel.hide()
		emailLabel.hide()
		hintSublabel.hide()
		checkEmailButton.hide()
		stillNotRecievingLabel.hide()
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
			viewModel?.userName = changedText
		} else if textInputView == emailInputView {
			viewModel?.email = changedText
		} else if textInputView == passwordInputView {
			viewModel?.password = changedText
		} else if textInputView == confirmPasswordInputView {
			viewModel?.confirmPassword = changedText
		}
	}
}

extension EmailRegisterViewController : EmailRegisterViewModelDelegate {
	
	public func emailRegisterViewModelSuccessfullySubmitRegistration() {
		hideAllViews()
		showCheckEmailView()
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
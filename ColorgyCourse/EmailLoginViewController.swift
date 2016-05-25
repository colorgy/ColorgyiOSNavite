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
	private var viewModel: EmailLoginViewModel?
	
	private var emailInputBox: EmailInputBox!
	private var passwordInputBox: PasswordInputBox!
	private var loginButton: ColorgyFullScreenButton!
	
	private var billboard: ColorgyBillboardView!

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// configure view
		configureBillboard()
		configureLoginView()
		
		// configure view
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		// assign view model
		viewModel = EmailLoginViewModel(delegate: self)
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// MARK: - Configuration
	private func configureBillboard() {
		billboard = ColorgyBillboardView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 170)))
		
		view.addSubview(billboard)
		
		billboard.billboardText = "登入"
	}
	
	private func configureLoginView() {
		
		emailInputBox = EmailInputBox()
		passwordInputBox = PasswordInputBox()
		
		let views = [emailInputBox, passwordInputBox]
		// arrange view
		let initialPosition = CGPoint(x: 0, y: 170)
		views.reduce(initialPosition.y, combine: arrangeView)
		views.forEach(view.addSubview)
		
		// configure button
		configureLoginButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: InputBox) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 2 + view.bounds.height
	}
	
	private func configureLoginButton() {
		loginButton =  ColorgyFullScreenButton(title: "登入", delegate: self)
		loginButton.frame.origin.y = passwordInputBox.frame.maxY + 48
		view.addSubview(loginButton)
		loginButton.centerHorizontallyToSuperview()
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

extension EmailLoginViewController : ColorgyFullScreenButtonDelegate {
	public func colorgyFullScreenButtonClicked(button: ColorgyFullScreenButton) {
		if button == loginButton {
			
		}
	}
}
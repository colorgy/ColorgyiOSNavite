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
		billboard = ColorgyBillboardView(initialImageName: "LoginBillboard", errorImageName: "LoginErrorBillboard")
		
		view.addSubview(billboard)
	}
	
	private func configureLoginView() {
		
		emailInputBox = EmailInputBox()
		passwordInputBox = PasswordInputBox()
		
		let views = [emailInputBox, passwordInputBox]
		// arrange view
		let initialPosition = CGPoint(x: 0, y: 170)
		_ = views.reduce(initialPosition.y, combine: arrangeView)
		views.forEach(view.addSubview)
		views.forEach({ $0.inputBoxDelegate = self })
		
		// configure button
		configureLoginButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: InputBox) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 2 + view.bounds.height
	}
	
	private func configureLoginButton() {
		loginButton =  ColorgyFullScreenButton(title: "登入", delegate: self)
		loginButton.move(48, pointBelow: passwordInputBox)
		view.addSubview(loginButton)
	}
	
	// MARK: - Selector
}

extension EmailLoginViewController : EmailLoginViewModelDelegate {
	
	public func emailLoginViewModelSuccessfullyLoginToColorgy() {
		if ColorgyUserInformation.sharedInstance().userMobile == nil {
			// need to validate phone
			let phoneValidationVC = StoryboardViewControllerFetchHelper.Main.fetchPhoneValidationViewController()
			dispatch_async(dispatch_get_main_queue(), { 
				self.presentViewController(phoneValidationVC, animated: true, completion: nil)
			})
		} else if ColorgyUserInformation.sharedInstance().userPossibleOrganization == nil {
			// need to choose school
			let chooseSchoolVC = StoryboardViewControllerFetchHelper.Main.fetchChooseSchooolViewController()
			dispatch_async(dispatch_get_main_queue(), {
				self.presentViewController(chooseSchoolVC, animated: true, completion: nil)
			})
		} else {
			
		}
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
			viewModel?.loginToColorgy()
		}
	}
}
extension EmailLoginViewController : InputBoxDelegate {
	public func inputBoxEditingChanged(inputbox: InputBox, text: String?) {
		if inputbox == emailInputBox {
			viewModel?.updateEmail(with: text)
		} else if inputbox == passwordInputBox {
			viewModel?.updatePassword(with: text)
		}
	}
}
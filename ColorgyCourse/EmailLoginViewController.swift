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
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	// MARK: - Configuration
	private func configureLoginView() {
		
		

//		// arrange view
//		let initialPosition: CGFloat = 66
//		let _ = [emailInputView, passwordInputView].reduce(initialPosition, combine: arrangeView)
//		
//		// add subview
//		[emailInputView, passwordInputView].forEach(view.addSubview)
		
		// configure button
//		configureLoginButton()
	}
	
	private func arrangeView(currentY: CGFloat, view: UIView) -> CGFloat {
		view.frame.origin.y = currentY
		return currentY + 4 + view.bounds.height
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
		
	}
}
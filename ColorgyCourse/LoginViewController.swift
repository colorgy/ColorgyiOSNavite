//
//  LoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class LoginViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var fbLoginButton: UIButton!
	@IBOutlet weak var emailLoginButton: UIButton!
	@IBOutlet weak var emailRegisterButton: UIButton!
	
	// MARK: - Actions
	@IBAction func fbLoginButtonClicked() {
		loginViewModel?.facebookLogin()
	}
	
	@IBAction func emailLoginButtonClicked() {
		loginViewModel?.emailLogin()
	}
	
	@IBAction func emailRegisterButtonClicked() {
		loginViewModel?.emailRegister()
	}
	
	// MARK: - Parameters
	
	// MARK: - ViewModel
	var loginViewModel: LoginViewModel?

	// MARK: - View Life Cycle
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoginButton()
		
		configureViewModel()
		
		navigationController?.navigationBarHidden = true
	}
	
	override public func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	// MARK: - Configure
	func configureLoginButton() {
		emailLoginButton.layer.cornerRadius = 4.0
		emailRegisterButton.layer.cornerRadius = 4.0
	}
	
	func configureViewModel() {
		loginViewModel = LoginViewModel(delegate: self)
	}
	
	// MARK: - Storyboard
	struct Storyboard {
		static let emailLoginSegue = "Email Login Segue"
		static let registerEmailSegue = "register email segue"
	}
	
	// MARK: - Navigation
	public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Storyboard.registerEmailSegue {
			
		} else if segue.identifier == Storyboard.emailLoginSegue {
			
		}
	}
}

extension LoginViewController : LoginViewModelDelegate {
	
	public func loginViewModel(failToLoginToFacebook error: FacebookLoginError) {
		switch error {
		case .CancelLoginFacebook:
			print(error)
		case .FailLoginToFacebook:
			print(error)
		}
	}
	
	public func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?) {
		print(error)
	}
	
	public func loginViewModel(failToGetDataFromServer error: APIError, afError: AFError?) {
		print(error)
	}

	public func loginViewModel(loginToColorgy userHasPossibleOrganization: Bool) {
		// after getting these data you will need to check if user has a valid organization code
		// 1. if yes, direct to main view
		// 2. if not, direct to select school view
		if userHasPossibleOrganization {
			// main view
			print(userHasPossibleOrganization)
		} else {
			// direct to select school view
			print(userHasPossibleOrganization)
		}
	}
	
	public func loginViewModelRequestToLoginWithEmail() {
		
	}
	
	public func loginViewModelRequestRegisterNewAccount() {
		performSegueWithIdentifier(Storyboard.registerEmailSegue, sender: nil)
	}
}

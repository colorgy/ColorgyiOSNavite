//
//  LoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var fbLoginButton: UIButton!
	@IBOutlet weak var emailLoginButton: UIButton!
	@IBOutlet weak var emailRegisterButton: UIButton!
	
	// MARK: - Actions
	@IBAction func fbLoginButtonClicked() {
		loginViewModel?.facebookLogin()
	}
	
	@IBAction func emailLoginButtonClicked() {
		
	}
	
	@IBAction func emailRegisterButtonClicked() {
		
	}
	
	// MARK: - Parameters
	var loginViewModel: LoginViewModel?

	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoginButton()
		
		configureViewModel()
		
		navigationController?.navigationBarHidden = true
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
	}
}

extension LoginViewController : LoginViewModelDelegate {
	
	func loginViewModel(failToLoginToFacebook error: ColorgyFacebookLoginError) {
		
	}
	
	func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?) {
		
	}
}

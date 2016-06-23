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
	
	// MARK: - Parameters
	private var transitioningManager: ColorgyNavigationTransitioningDelegate!
	
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
		
		transitioningManager = ColorgyNavigationTransitioningDelegate()
		
		configureLoginButton()
		
		configureViewModel()
		
		navigationController?.navigationBarHidden = true
	}
	
	override public func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
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
		static let emailLoginSegue = "email login segue"
		static let registerEmailSegue = "register email segue"
	}
	
	// MARK: - Navigation
	public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Storyboard.registerEmailSegue {
			transitioningManager.mainViewController = self
			transitioningManager.presentingViewController = segue.destinationViewController
			transitioningManager.presentingViewController.transitioningDelegate = transitioningManager
		} else if segue.identifier == Storyboard.emailLoginSegue {
			transitioningManager.mainViewController = self
			transitioningManager.presentingViewController = segue.destinationViewController
			transitioningManager.presentingViewController.transitioningDelegate = transitioningManager
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
	
	/// Might be server error
	public func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?) {
		print(error, afError)
	}
	
	/// Fail to get data from server, maybe fail to retireve me api or something
	public func loginViewModel(failToGetDataFromServer error: APIError, afError: AFError?) {
		print(error)
	}

	/// Login to colorgy.
	/// After login, check if this user validate the phone and choose a school.
	public func loginViewModelDidLoginToColorgy() {
		// TODO: VC transition
	}
	
	public func loginViewModelRequestToLoginWithEmail() {
		performSegueWithIdentifier(Storyboard.emailLoginSegue, sender: nil)
	}
	
	public func loginViewModelRequestRegisterNewAccount() {
		performSegueWithIdentifier(Storyboard.registerEmailSegue, sender: nil)
	}
}

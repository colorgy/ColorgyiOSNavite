//
//  LoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

// MARK: - Delegate
public protocol LoginViewModelDelegate: class {
	/// Fail to login to facebook.
	func loginViewModel(failToLoginToFacebook error: FacebookLoginError)
	/// Fail to login to colorgy, might be server problem.
	func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?)
	/// Fail to get data from server, maybe fail to get data from me api.
	func loginViewModel(failToGetDataFromServer error: APIError, afError: AFError?)
	
	// Login part
	/// Login to colorgy.
	func loginViewModelDidLoginToColorgy()
	/// Need to goto email login view.
	func loginViewModelRequestToLoginWithEmail()
	/// Need to goto register account view.
	func loginViewModelRequestRegisterNewAccount()
}

final public class LoginViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: LoginViewModelDelegate?
	// MARK: Private
	private let colorgyAPI: ColorgyAPI
	
	// MARK: - Methods
	/// Call this to perform login using fb token
	public func facebookLogin() {
		ColorgyLogin.getFacebookAccessToken(success: { (token) in
			// Success login from facebook,
			// continue to get data from server
			
			}, failure: { (error) in
				self.delegate?.loginViewModel(failToLoginToFacebook: error)
		})
	}
	
	
	// MARK: - Init
	
	public init(delegate: LoginViewModelDelegate?) {
		self.delegate = delegate
		self.colorgyAPI = ColorgyAPI()
		registerNotification()
	}
	
	// MARK: - Public Methods
	
	/// Call this to perform login using email
	public func emailLogin() {
		delegate?.loginViewModelRequestToLoginWithEmail()
	}
	
	public func emailRegister() {
		delegate?.loginViewModelRequestRegisterNewAccount()
	}
	
	// MARK: - Notifications
	private func registerNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshTokenRevokedNotification), name: ColorgyAppNotification.RefreshTokenRevokedNotification, object: nil)
	}
	
	// TODO: something to do if refresh token is revoked
	@objc private func refreshTokenRevokedNotification() {
		print("YOOoooooo")
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - Helper
	private func checkUserOrganization() -> String {
		// TODO: handle no orgnization
		return ColorgyUserInformation.sharedInstance().userActualOrganization ?? "error orgnization"
	}
}

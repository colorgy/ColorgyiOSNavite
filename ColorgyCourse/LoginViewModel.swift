//
//  LoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol LoginViewModelDelegate: class {
	func loginViewModel(failToLoginToFacebook error: ColorgyFacebookLoginError)
	func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?)
}

final public class LoginViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: LoginViewModelDelegate?
	// MARK: Private
	private let colorgyAPI: ColorgyAPI
	
	// MARK: - Methods
	public func facebookLogin() {
		ColorgyLogin.getFacebookAccessToken(success: { (token) in
			// Success login from facebook,
			// continue to get data from server
			ColorgyLogin.loginToColorgyWithFacebookToken(token, success: { (result) in
				// get me data after login
				
				// need to fetch data as follow:
				// 1. me data
				// 2. period data
				// 
				// after getting these data you will need to check if user has a valid organization code
				// 1. if yes, direct to main view
				// 2. if not, direct to select school view
				
				// test firing 100 req
				for _ in 1...100 {
					self.colorgyAPI.me(success: { (result) in
						self.updateOperationCount()
						}, failure: { (error, afError) in
							self.updateOperationCount()
					})
				}
				}, failure: { (error, afError) in
					// fail to login to colorgy
					self.delegate?.loginViewModel(failToLoginToColorgy: error, afError: afError)
			})
			}, failure: { (error) in
				self.delegate?.loginViewModel(failToLoginToFacebook: error)
		})
	}
	
	private func updateOperationCount() {
		print(colorgyAPI.manager.operationQueue.operationCount)
	}
	
	public func emailLogin() {
		colorgyAPI.manager.operationQueue.operationCount
	}
	
	public func emailRegister() {
		
	}
	
	// MARK: - Init
	init(delegate: LoginViewModelDelegate?) {
		self.delegate = delegate
		self.colorgyAPI = ColorgyAPI()
	}
}

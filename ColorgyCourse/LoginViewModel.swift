//
//  LoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol LoginViewModelDelegate: class {
	func failToLoginToFacebook(error: ColorgyFacebookLoginError)
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
			// get me data after login
			self.colorgyAPI.me(success: { (result) in
				<#code#>
				}, failure: { (error, AFError) in
					<#code#>
			})
			}, failure: { (error) in
				self.delegate?.failToLoginToFacebook(error)
		})
	}
	
	public func emailLogin() {
		
	}
	
	public func emailRegister() {
		
	}
	
	// MARK: - Init
	init(delegate: LoginViewModelDelegate?) {
		self.delegate = delegate
		self.colorgyAPI = ColorgyAPI()
	}
}

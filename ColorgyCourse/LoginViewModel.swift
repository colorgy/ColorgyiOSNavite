//
//  LoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

@objc public protocol LoginViewModelDelegate: class {
	
}

final public class LoginViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: LoginViewModelDelegate?
	// MARK: Private
	private let colorgyAPI: ColorgyAPI
	
	// MARK: - Methods
	public func facebookLogin() {
		ColorgyLogin.getFacebookAccessToken(<#T##success: ((token: String) -> Void)?##((token: String) -> Void)?##(token: String) -> Void#>, failure: <#T##((error: ColorgyFacebookLoginError) -> Void)?##((error: ColorgyFacebookLoginError) -> Void)?##(error: ColorgyFacebookLoginError) -> Void#>)
	}
	
	public func emailLogin() {
		
	}
	
	public func emailRegister() {
		
	}
	
	// MARK: - Init
	init(delegate: LoginViewModelDelegate?) {
		self.delegate = delegate
	}
}

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
	
	public weak var delegate: LoginViewModelDelegate?
	
	// MARK: - Methods
	public func facebookLogin() {
		
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

//
//  EmailLoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

/// This indicates the information problem user gave.
public enum InvalidLoginInformationError: ErrorType {
	/// This is an invalid email format.
	case InvalidEmail
	/// Password must be greater or equal to 8 letters.
	case PasswordLessThan8Characters
}

public protocol EmailLoginViewModelDelegate: class {
	/// Invalid required information.
	func emailLoginViewModel(invalidRequiredInformation error: InvalidLoginInformationError)
	///
	func emailLoginViewModelSuccessfullyLoginToColorgy()
	/// Fail to login to colorgy.
	func emailLoginViewModel(failToLoginColorgy error: ColorgyLoginError, afError: AFError?)
	/// Fail to fetch data from server.
	func emailLoginViewModel(failToRetrieveDataFromServre error: APIError, afError: AFError?)
}

final public class EmailLoginViewModel {
	
	// MARK: - Parameters
	public weak var delegate: EmailLoginViewModelDelegate?
	private let api: ColorgyAPI
	/// Email that will be use on login to colorgy
	public private(set) var email: String?
	/// Password that will be use on login to colorgy
	public private(set) var password: String?
	
	// MARK: - Init
	init(delegate: EmailLoginViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
	}
	
	// MARK: - Public Methods
	
	/// Login to colorgy.
	/// Will check email and password in view model.
	/// **Make sure you update email and password** in view model before calling this method.
	public func loginToColorgy() {
		
		// Check email format first.
		guard let email = email where email.isValidEmail else {
			delegate?.emailLoginViewModel(invalidRequiredInformation: InvalidLoginInformationError.InvalidEmail)
			return
		}
		
		// Then check password length, must greater or equal to 8 letters.
		guard let password = password where password.characters.count >= 8 else {
			delegate?.emailLoginViewModel(invalidRequiredInformation: InvalidLoginInformationError.PasswordLessThan8Characters)
			return
		}
		
		// Prepare to login to colorgy
		ColorgyLogin.loginToColorgy(with: email, password: password, success: { (result) in
			// After getting access token, fetch data from server
			// First get user information
			self.api.me(success: { (result) in
				// check if this user has a confirmed mobile
				print(result)
				self.delegate?.emailLoginViewModelSuccessfullyLoginToColorgy()
				}, failure: { (error, afError) in
					// Fail to get data from colorgy.
					self.delegate?.emailLoginViewModel(failToRetrieveDataFromServre: error, afError: afError)
			})
			}, failure: { (error, afError) in
				// Fail to login to colorgy
				self.delegate?.emailLoginViewModel(failToLoginColorgy: error, afError: afError)
		})
	}
	
	/// Update view model's email.
	public func updateEmail(with email: String?) {
		self.email = email
	}
	
	/// Update view model's password.
	public func updatePassword(with password: String?) {
		self.password = password
	}
	
	// MARK: - Private Methods
	
	// MARK: - Helper
	private func checkUserOrganization() -> String {
		// TODO: handle no orgnization
		return ColorgyUserInformation.sharedInstance().userActualOrganization ?? "error orgnization"
	}
}
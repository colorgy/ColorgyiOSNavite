//
//  EmailRegisterViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public enum InvalidInformationError {
	case NoUserName
	case InvalidEmail
	case PasswordMustGreaterThanOrEqualTo8Charaters
	case TwoPasswordsDontMatch
}

public protocol EmailRegisterViewModelDelegate: class {
	func emailRegisterViewModel(invalidRequiredInformation error: InvalidInformationError)
	func emailRegisterViewModelSuccessfullySubmitRegistration()
	func emailRegisterViewModel(errorSumittingRequest error: APIError, afError: AFError?)
}

final public class EmailRegisterViewModel {
	
	// MARK: - Parameters
	weak var delegate: EmailRegisterViewModelDelegate?
	private let api: ColorgyAPI
	public var userName: String?
	public var email: String?
	public var password: String?
	public var confirmPassword: String?
	
	// MARK: - Init
	public init(delegate: EmailRegisterViewModelDelegate?) {
		self.delegate = delegate
		api = ColorgyAPI()
	}
	
	// MARK: - Public Methods
	public func submitRegistration() {
		print("submit register")
		
		// User must have at least one charater of name
		guard let userName = userName where userName.characters.count >= 1 else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.NoUserName)
			return
		}
		
		guard let email = email where email.isValidEmail else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.InvalidEmail)
			return
		}
		
		guard let password = password where password.characters.count >= 8 else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.PasswordMustGreaterThanOrEqualTo8Charaters)
			return
		}
		
		guard let confirmPassword = confirmPassword where confirmPassword == password else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.TwoPasswordsDontMatch)
			return
		}
		
		// if no data is wrong, perform api request
		api.registerNewUser(userName, email: email, password: password, passwordConfirm: confirmPassword, success: { 
			self.delegate?.emailRegisterViewModelSuccessfullySubmitRegistration()
			}, failure: { (error, afError) in
			self.delegate?.emailRegisterViewModel(errorSumittingRequest: error, afError: afError)
		})
	}
}
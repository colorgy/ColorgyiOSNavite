//
//  EmailRegisterViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public enum InvalidInformationError: ErrorType {
	case InvalidEmail
	case InvalidPhoneNumber
	case PasswordLessThen8Characters
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
	public private(set) var email: String?
	public private(set) var phoneNumber: String?
	public private(set) var password: String?
	public private(set) var confirmPassword: String?
	
	// MARK: - Init
	public init(delegate: EmailRegisterViewModelDelegate?) {
		self.delegate = delegate
		api = ColorgyAPI()
	}
	
	// MARK: - Update Data
	public func updateEmail(with email: String?) {
		self.email = email
	}
	
	public func updatePhoneNumber(with number: String?) {
		self.phoneNumber = number
	}
	
	public func updatePassword(with password: String?) {
		self.password = password
	}
	
	public func updateConfirmPassword(with password: String?) {
		self.confirmPassword = password
	}
	
	// MARK: - Public Methods
	public func submitRegistration() {
		print("submit register")
		
		// User must have at least one charater of name
		guard let number = phoneNumber where number.isValidMobileNumber else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.InvalidPhoneNumber)
			return
		}
		
		guard let email = email where email.isValidEmail else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.InvalidEmail)
			return
		}
		
		guard let password = password where password.characters.count >= 8 else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.PasswordLessThen8Characters)
			return
		}
		
		guard let confirmPassword = confirmPassword where confirmPassword == password else {
			delegate?.emailRegisterViewModel(invalidRequiredInformation: InvalidInformationError.TwoPasswordsDontMatch)
			return
		}
		
		// if no data is wrong, perform api request
		api.registerNewUser(with: email, phoneNumber: number, password: password, passwordConfirm: confirmPassword, success: {
			print("yooooooooooo")
			self.successfullyRegister(with: email, and: password)
			}, failure: { (error, afError) in
				print(error, afError)
		})
	}
	
	/// After register, you need to login and get access token to update mobile.
	private func successfullyRegister(with email: String, and password: String) {
		ColorgyLogin.loginToColorgyWithEmail(email: email, password: password, success: { (result) in
			self.delegate?.emailRegisterViewModelSuccessfullySubmitRegistration()
			}, failure: { (error, afError) in
				// TODO: what should i do if user fail to login after register?
				// Should i direct them to login page?
				print(error, afError)
		})
	}
	
	
	
	
	
	
	
	
	
	
	
}
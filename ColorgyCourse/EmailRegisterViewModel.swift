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
	/// Something wrong in given information
	func emailRegisterViewModel(invalidRequiredInformation error: InvalidInformationError)
	/// Everything ok here. Create an account and get token.
	func emailRegisterViewModelSuccessfullySubmitRegistration()
	/// This happened when something is wrong when creating account.
	func emailRegisterViewModel(errorSumittingRequest error: APIError, afError: AFError?)
	/// This happened when something is wrong after creating account. Maybe fail to get access token.
	func emailRegisterViewModel(errorAfterSumittingRequest error: ColorgyLoginError, afError: AFError?)
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
			self.successfullyRegister(with: email, and: password)
			}, failure: { (error, afError) in
				// TODO: 這邊有三種錯誤，有兩種個別是EMAIL備用過、MOBILE備用過
				// TODO: 特別的事email跟mobile都備用過，那這邊要怎麼做呢？
				print(error, afError)
				self.delegate?.emailRegisterViewModel(errorSumittingRequest: error, afError: afError)
		})
	}
	
	/// After register, you need to login and get access token to update mobile.
	private func successfullyRegister(with email: String, and password: String) {
		ColorgyLogin.loginToColorgy(with: email, password: password, success: { (result) in
			self.delegate?.emailRegisterViewModelSuccessfullySubmitRegistration()
			}, failure: { (error, afError) in
				// TODO: what should i do if user fail to login after register?
				// Should i direct them to login page?
				print(error, afError)
				self.delegate?.emailRegisterViewModel(errorAfterSumittingRequest: error, afError: afError)
		})
	}
	
	
	
	
	
	
	
	
	
	
	
}
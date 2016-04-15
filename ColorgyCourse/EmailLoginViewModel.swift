//
//  EmailLoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public enum InvalidLoginInformationError: ErrorType {
	case InvalidEmail
	case PasswordLessThan8Characters
}

public protocol EmailLoginViewModelDelegate: class {
	func emailLoginViewModel(invalidRequiredInformation error: InvalidLoginInformationError)
	func emailLoginViewModel(successfullyLoginToColorgy userHasPossibleOrganization: Bool)
	func emailLoginViewModel(failToLoginColorgy error: ColorgyLoginError, afError: AFError?)
	func emailLoginViewModel(failToRetrieveDataFromServre error: APIError, afError: AFError?)
}

final public class EmailLoginViewModel {
	
	// MARK: - Parameters
	public weak var delegate: EmailLoginViewModelDelegate?
	private let api: ColorgyAPI
	public var email: String?
	public var password: String?
	
	// MARK: - Init
	init(delegate: EmailLoginViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
	}
	
	// MARK: - Public Methods
	public func loginToColorgy() {
		
		guard let email = email where email.isValidEmail else {
			delegate?.emailLoginViewModel(invalidRequiredInformation: InvalidLoginInformationError.InvalidEmail)
			return
		}
		
		guard let password = password where password.characters.count >= 8 else {
			delegate?.emailLoginViewModel(invalidRequiredInformation: InvalidLoginInformationError.PasswordLessThan8Characters)
			return
		}
		
		ColorgyLogin.loginToColorgyWithEmail(email: email, password: password, success: { (result) in
			// After getting access token, fetch data from server
			// First get user information
			self.api.me(success: { (result) in
				let organization = self.checkUserOrganization()
				// get school period data
				self.api.getSchoolPeriodData(organization, success: { (periodData) in
					// store period data for further use
					PeriodRawDataRealmObject.storePeriodRawData(periodData)
					// check if user has a organization
					let state = ColorgyUserInformation.sharedInstance().userActualOrganization != nil ? true : false
					self.delegate?.emailLoginViewModel(successfullyLoginToColorgy: state)
					}, failure: { (error, afError) in
						self.delegate?.emailLoginViewModel(failToRetrieveDataFromServre: error, afError: afError)
				})
				}, failure: { (error, afError) in
					self.delegate?.emailLoginViewModel(failToRetrieveDataFromServre: error, afError: afError)
			})
			}, failure: { (error, afError) in
				self.delegate?.emailLoginViewModel(failToLoginColorgy: error, afError: afError)
		})
	}
	
	// MARK: - Private Methods
	
	// MARK: - Helper
	private func checkUserOrganization() -> String {
		// TODO: handle no orgnization
		return ColorgyUserInformation.sharedInstance().userActualOrganization ?? "error orgnization"
	}
}
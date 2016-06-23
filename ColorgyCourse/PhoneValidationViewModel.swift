//
//  PhoneValidationViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol PhoneValidationViewModelDelegate: class {
	func phoneValidationViewModelDidSentSMS()
	func phoneValidationViewModel(failToSendSMSWith error: APIError, and afError: AFError?)
	func phoneValidationViewModelSuccessfullyValidationSMSCode()
	func phoneValidationViewModel(failToValidateCodeWith error: APIError, and afError: AFError?)
}

final public class PhoneValidationViewModel {
	
	public weak var delegate: PhoneValidationViewModelDelegate?
	private let api: ColorgyAPI
	public private(set) var validationCode: String
	
	public init(delegate: PhoneValidationViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
		self.validationCode = ""
	}
	
	/// Will send a sms to specific number.
	/// Format: International format, with '+' at very beginning.
	public func requestValidationSMS() {
		guard let phoneNumber = ColorgyUserInformation.sharedInstance().userUnconfirmedMobile else { return }
		api.requestSMS(with: phoneNumber, success: {
			self.delegate?.phoneValidationViewModelDidSentSMS()
			}, failure: { (error, afError) in
				self.delegate?.phoneValidationViewModel(failToSendSMSWith: error, and: afError)
		})
	}
	
	/// Update validation code
	public func updateValidationCode(with code: String) {
		validationCode = code
	}
	
	/// Validation the validation code user typed in.
	public func validateSMSValidationCode() {
		
	}
}
//
//  PhoneValidationViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol PhoneValidationViewModelDelegate: class {
	
}

final public class PhoneValidationViewModel {
	
	public weak var delegate: PhoneValidationViewModelDelegate?
	private let api: ColorgyAPI
	
	public init(delegate: PhoneValidationViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
	}
	
	public func requestValidationSMS() {
		guard let phoneNumber = ColorgyUserInformation.sharedInstance().userUnconfirmedMobile else { return }
		api.requestSMS(with: phoneNumber, success: { 
			print(#file, #function, #line, "okok")
			}, failure: { (error, afError) in
				print(#file, #line,error, afError)
		})
	}
}
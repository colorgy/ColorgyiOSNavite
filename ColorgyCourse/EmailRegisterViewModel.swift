//
//  EmailRegisterViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol EmailRegisterViewModelDelegate: class {
	
}

final public class EmailRegisterViewModel {
	
	weak var delegate: EmailRegisterViewModelDelegate?
	
	// MARK: - Init
	public init(delegate: EmailRegisterViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Submit
	public func submitRegistration() {
		print("submit register")
	}
}
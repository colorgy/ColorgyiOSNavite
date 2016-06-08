//
//  ChooseSchoolViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol ChooseSchoolViewModelDelegate: class {
	func chooseSchoolViewModelUpdateSchool(schools: [Organization])
	func chooseSchoolViewModelFailToFetchSchool(error: APIError, afError: AFError?)
}

final public class ChooseSchoolViewModel {
	
	public weak var delegate: ChooseSchoolViewModelDelegate?
	private let api: ColorgyAPI
	public private(set) var schools: [Organization]
	
	public init(delegate: ChooseSchoolViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
		self.schools = []
	}
	
	public func fetchSchoolData() {
		api.getOrganizations(success: { (organizations) in
			self.schools = organizations
			self.delegate?.chooseSchoolViewModelUpdateSchool(self.schools)
			}, failure: { (error, afError) in
				self.delegate?.chooseSchoolViewModelFailToFetchSchool(error, afError: afError)
		})
	}
	
}
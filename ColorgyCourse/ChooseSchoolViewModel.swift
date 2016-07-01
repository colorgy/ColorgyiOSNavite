//
//  ChooseSchoolViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol ChooseSchoolViewModelDelegate: class {
	func chooseSchoolViewModel(updateSchool schools: [Organization])
	func chooseSchoolViewModel(updateFilteredSchool schools: [Organization])
	func chooseSchoolViewModel(failToFetchSchoolWith error: APIError, and afError: AFError?)
	func chooseSchoolViewModel(updateOrganizationTo organization: Organization)
	func chooseSchoolViewModel(failToUpdateOrganizationWith error: APIError, and afError: AFError?)
}

final public class ChooseSchoolViewModel {
	
	public weak var delegate: ChooseSchoolViewModelDelegate?
	private let api: ColorgyAPI
	public private(set) var schools: [Organization]
	public private(set) var filteredSchools: [Organization]

	public init(delegate: ChooseSchoolViewModelDelegate?) {
		self.delegate = delegate
		self.api = ColorgyAPI()
		self.schools = []
		self.filteredSchools = []
	}
	
	public func fetchSchoolData() {
		api.getOrganizations({ (organizations) in
			self.schools = organizations
			self.delegate?.chooseSchoolViewModel(UpdateSchool: self.schools)
			}, failure: { (error, afError) in
				self.delegate?.chooseSchoolViewModel(failToFetchSchoolWith: error, and: afError)
		})
	}
	
	public func filterSchoolWithText(text: String?) {
		guard let text = text else { return }
		// check if the text is an empty string
		// if is an empty string, show origin schools
		if text == "" {
			filteredSchools = schools
			self.delegate?.chooseSchoolViewModel(updateFilteredSchool: self.filteredSchools)
		} else {
			// if not, filter it
			filteredSchools = []
			let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
			dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
				self.schools.forEach({ (school) in
					if school.name.rangeOfString(text, options: .CaseInsensitiveSearch, range: nil, locale: nil) != nil {
						self.filteredSchools.append(school)
					} else if school.code.rangeOfString(text, options: .CaseInsensitiveSearch, range: nil, locale: nil) != nil {
						self.filteredSchools.append(school)
					}
				})
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.delegate?.chooseSchoolViewModel(updateFilteredSchool: self.filteredSchools)
				})
			})
		}
	}
	
	public func enroll(to organization: Organization) {
		api.updateOrganization(withCode: organization.code, success: {
			self.delegate?.chooseSchoolViewModel(updateOrganizationTo: organization)
			}, failure: { (error, afError) in
				self.delegate?.chooseSchoolViewModel(failToUpdateOrganizationWith: error, and: afError)
		})
	}
	
}
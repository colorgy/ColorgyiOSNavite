//
//  SearchCourseViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol SearchCourseViewModelDelegate: class {
	
}

final public class SearchCourseViewModel {
	
	// MARK: - Parameters
	public weak var delegate: SearchCourseViewModelDelegate?
	
	// MARK: - Init
	public init(delegate: SearchCourseViewModelDelegate?) {
		self.delegate = delegate
	}
	
	// MARK: - Public Methods
	public func searchText(text: String?) {
		
	}
	
	// MARK: - Private Methods
}
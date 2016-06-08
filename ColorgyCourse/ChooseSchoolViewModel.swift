//
//  ChooseSchoolViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol ChooseSchoolViewModelDelegate: class {
	
}

final public class ChooseSchoolViewModel {
	
	public weak var delegate: ChooseSchoolViewModelDelegate?
	
	public init(delegate: ChooseSchoolViewModelDelegate?) {
		self.delegate = delegate
	}
	
}
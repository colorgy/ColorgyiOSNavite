//
//  SearchEventListViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

protocol SearchEventListViewModelDelegate: class {
	
}

final public class SearchEventListViewModel {
	
	weak var delegate: SearchEventListViewModelDelegate?
	
	init(delegate: SearchEventListViewModelDelegate?) {
		self.delegate = delegate
	}
}
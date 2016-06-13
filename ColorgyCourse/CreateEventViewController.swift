//
//  CreateEventViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
	
	var tb: CreateEventView!
	var viewModel: CreateEventViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel = CreateEventViewModel(delegate: self)
		tb = CreateEventView(frame: UIScreen.mainScreen().bounds, viewModel: viewModel)
		view.addSubview(tb)
    }
}

extension CreateEventViewController : CreateEventViewModelDelegate {
	
}
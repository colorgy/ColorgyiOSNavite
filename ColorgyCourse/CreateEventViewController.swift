//
//  CreateEventViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
	
	var tb: EventManagerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tb = EventManagerView(frame: UIScreen.mainScreen().bounds)
		view.addSubview(tb)
    }
}


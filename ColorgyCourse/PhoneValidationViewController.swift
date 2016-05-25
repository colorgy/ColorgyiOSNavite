//
//  PhoneValidationViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneValidationViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let k = PhoneValidationView()
		view.addSubview(k)
		k.targetPhoneNumber = "0988913868"
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }

}

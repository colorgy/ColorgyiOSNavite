//
//  ReenterPhoneViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ReenterPhoneViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		let re = ReenterPhoneNumberView(title: "yGGHJgo", subtitle: "lsakgjlsaklaskl")
		view.addSubview(re)
    }

}

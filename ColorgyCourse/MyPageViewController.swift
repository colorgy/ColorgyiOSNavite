//
//  MyPageViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MyPageViewController: UIViewController {
	
	private var personalInfoView: MyPagePersonalInfoView!
	private var moreOptionView: MyPageMoreOptionView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		personalInfoView = MyPagePersonalInfoView(name: "揪揪掰掰", school: "耶黑黑嘿嘿")
		view.addSubview(personalInfoView)
		
		moreOptionView = MyPageMoreOptionView(delegate: self)
		moreOptionView.move(16, pointBelow: personalInfoView)
		view.addSubview(moreOptionView)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }

}

extension MyPageViewController : MyPageMoreOptionViewDelegate {
	
}
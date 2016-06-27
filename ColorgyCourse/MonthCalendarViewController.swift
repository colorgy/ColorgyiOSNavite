//
//  MonthCalendarViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/27.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class MonthCalendarViewController: UIViewController {
	
	private var cc: DLCalendarView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		cc = DLCalendarView(frameWithHeader: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.width)))
		view.addSubview(cc)
		cc.jumpToDate(NSDate())
		cc.backgroundColor = ColorgyColor.BackgroundColor
		
    }

}

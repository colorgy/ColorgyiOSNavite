//
//  WeekCalendarViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class WeekCalendarViewController: UIViewController {
	var v: WeekCalendarView!
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		v = WeekCalendarView(frame: CGRect(x: 0, y: 20, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 20))
		view.addSubview(v)
		v.days = [29,30,31,1,2,3,4]
		
		
		let e = Event(title: "yo", location: "yo", starts: NSDate(), ends: NSDate(timeInterval: 111000, sinceDate: NSDate()), repeats: true, color: UIColor.whiteColor(), alertTime: nil, notes: "hiii")
		v.events = [e]
    }
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		v.scrollToCurrentTime()
	}
}

//
//  MonthCalendarViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/27.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class MonthCalendarViewController: UIViewController {
	
//	private var cc: DLCalendarView!
	public var k: DLCalendarView!
//	private var f: DLCalendarView?
	
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		k = DLCalendarView(frameWithHeader: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 330)))
		view.addSubview(k)
		k.jumpToDate(NSDate())
		k.backgroundColor = UIColor.whiteColor()
		k.delegate = self
		view.backgroundColor = ColorgyColor.BackgroundColor

    }
	
	

}
extension MonthCalendarViewController {
	
}
extension MonthCalendarViewController : DLCalendarViewDelegate {
	
	public func DLCalendar(didFinishSelecting date: NSDate?) {
		<#code#>
	}
	
}

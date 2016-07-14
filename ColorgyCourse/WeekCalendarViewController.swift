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
	var navigationBar: ColorgyNavigationBar!
	var calendarView: DLCalendarView!
	var viewModel: WeekCalendarViewModel?
	
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel = WeekCalendarViewModel(delegate: self)
		
		
		
		navigationBar = ColorgyNavigationBar()
		navigationBar.iWantACalendarButtonAtLeft()
		navigationBar.iWantAAddButtonAtRight()
		navigationBar.title = "嘿YO油"
		view.addSubview(navigationBar)
		
		navigationBar.delegate = self
		
		configureCalendarView()
		
		v = WeekCalendarView(frame:
			CGRect(
				x: 0,
				y: 20 + navigationBar.frame.height,
				width: UIScreen.mainScreen().bounds.width,
				height: UIScreen.mainScreen().bounds.height - 20 - navigationBar.frame.height))
		view.insertSubview(v, belowSubview: calendarView)
		v.days = [29,30,31,1,2,3,4]

    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		v.scrollToCurrentTime()
	}
	
	private func configureCalendarView() {
		calendarView = DLCalendarView(frameWithHeader: CGRect(x: 0, y: 0, width: view.bounds.width, height: 270))
		calendarView.jumpToTaday()
		view.insertSubview(calendarView, belowSubview: navigationBar)
		calendarView.hide()
		calendarView.delegate = self
		calendarView.backgroundColor = UIColor.whiteColor()
		calendarViewInitialPosition()
	}
	
	private func toggleCalendarView() {
		if calendarView.hidden {
			// show
			self.calendarView.show()
			// from top
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
				self.calendarView.transform = CGAffineTransformMakeTranslation(0, self.calendarView.bounds.height)
				}, completion: { (ok) in
					
			})
		} else {
			// hide
			// slide up
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				self.calendarView.transform = CGAffineTransformIdentity
				}, completion: { (ok) in
					self.calendarView.hide()
			})
		}
	}
	
	private func calendarViewInitialPosition() {
		calendarView.frame.origin.y = navigationBar.bounds.height - calendarView.bounds.height
	}
}

extension WeekCalendarViewController : ColorgyNavigationBarDelegate {
	public func colorgyNavigationBarCalendarButtonClicked() {
		print(#function, #line)
		toggleCalendarView()
	}
	
	public func colorgyNavigationBarAddButtonClicked() {
		print(#function, #line)
		viewModel?.loadData(between: NSDate(), and: NSDate())
	}
}

extension WeekCalendarViewController : DLCalendarViewDelegate {
	
}

extension WeekCalendarViewController : WeekCalendarViewModelDelegate {
	
}
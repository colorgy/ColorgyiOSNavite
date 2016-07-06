//
//  MyPageViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import RealmSwift

final public class MyPageViewController: UIViewController {
	
	private var myPageContainerView: MyPageContainerView!
	private var transitionManager: ColorgyNavigationTransitioningDelegate!
	
	// test
	private var api: ColorgyAPI!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let size = UIScreen.mainScreen().bounds.size
		myPageContainerView = MyPageContainerView(frame: CGRect(origin: CGPointZero, size: size), moreOptionViewDelegate: self)
		view.addSubview(myPageContainerView)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		transitionManager = ColorgyNavigationTransitioningDelegate()
		
		// test
		api = ColorgyAPI()
		
		let rs = "DTSTART=20150901T000000Z;UNTIL=20160131T000000Z;FREQ=WEEKLY;WKST=MO;"
		let rs2 = "DTSTART=20150901T000000Z;FREQ=WEEKLY;WKST=MO;"
		let rr = RRule(rruleString: rs)
		print(rr?.allOccurrences())
    }

}

extension MyPageViewController : MyPageMoreOptionViewDelegate {
	
	public func myPageMoreOptionViewSettingsTapped() {
		print(#file, #function, #line)
		let settingsVC = StoryboardViewControllerFetchHelper.MyPage.fetchSettingsViewController()
		transitionManager.mainViewController = self
		transitionManager.presentingViewController = settingsVC
		transitionManager.presentingViewController.transitioningDelegate = transitionManager
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(settingsVC, animated: true, completion: nil)
		}
	}
	
	public func myPageMoreOptionViewGreetingsTapped() {
		print(#file, #function, #line)
//		let list = CourseRealmObject.getCourseList()
//		EventRealmObject.queryData(fromYear: 1970, toYear: 1971) { (events) in
//			print(events)
//		}
		CourseRealmObject.queryData(fromYear: 2016, toYear: 2016) { (courses) in
			print(courses)
		}
	}
	
	public func myPageMoreOptionViewMyActivityTapped() {
		print(#file, #function, #line)
		api.me(success: nil, failure: nil)
		
		api.getCoursesList(of: 2015, andTerm: 1, success: { (courseList) in
			courseList.saveListToRealm({ (succeed) in
				if succeed {
					print(CourseRealmObject.getCourseList()?.count)
				} else {
					print("fail")
				}
			})
			}) { (error, afError) in
				print(error, afError)
		}
	}
}
//
//  MyPageViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

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
		let from = NSDate.create(dateOnYear: 2015, month: 7, day: 1, hour: 21, minute: 0, second: 0)!
		let to = NSDate.create(dateOnYear: 2016, month: 10, day: 1, hour: 22, minute: 0, second: 0)!
		CourseRealmObject.queryDate(fromDate: from, toDate: to) { (objects) in
			print(objects.count, "courses in db")
			let courses = Course.generateCourses(withRealmObjects: objects)
			print(courses.count, "courses been transformed")
			print(courses.first)
		}
	}
	
	public func myPageMoreOptionViewMyActivityTapped() {
		print(#file, #function, #line)
		
		let c = Course(id: NSUUID().UUIDString,
		               name: "某捷克",
		               uuid: NSUUID().UUIDString,
		               rrule: nil,
		               startTime: NSDate.create(dateOnYear: 2016, month: 7, day: 12, hour: 0, minute: 0, second: 0),
		               endTime: NSDate.create(dateOnYear: 2016, month: 7, day: 12, hour: 3, minute: 0, second: 0),
		               detailDescription: nil,
		               referenceId: nil,
		               createdAt: NSDate(),
		               updatedAt: NSDate(),
		               courseCredits: nil,
		               courseLecturer: nil,
		               courseURL: nil,
		               courseCode: nil,
		               courseRequired: nil,
		               courseTerm: nil,
		               courseYear: nil,
		               subcourses: [])
		print(c)
		
		api.getCoursesList({ (courses) in
			courses.saveToRealm({ (succeed) in
				print(succeed)
				print("fuck")
			})
			}) { (error, afError) in
				print(error,afError)
		}
	}
}
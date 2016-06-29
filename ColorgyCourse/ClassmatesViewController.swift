//
//  ClassmatesViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/29.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ClassmatesViewController: UIViewController {
	
	private var navigationBar: ColorgyNavigationBar!
	private var friendListView: FriendContainerView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		navigationBar = ColorgyNavigationBar()
		navigationBar.title = "就是不放你照片"
		navigationBar.iWantABackButtonAtLeft()
		navigationBar.iWantAAdjusttingButtonAtRight()
		view.addSubview(navigationBar)
		
		let size = CGSize(
			width: UIScreen.mainScreen().bounds.width,
			height: UIScreen.mainScreen().bounds.height - navigationBar.frame.height)
		
		friendListView = FriendContainerView(frame: CGRect(origin: CGPoint(x: 0, y: navigationBar.frame.height), size: size))
		view.addSubview(friendListView)
    }

	

}

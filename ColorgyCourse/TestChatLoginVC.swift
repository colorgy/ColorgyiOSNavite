//
//  TestChatLoginVC.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TestChatLoginVC: UIViewController {

	let api = ColorgyChatAPI()
	var userId: String!
	var uuid: String!
	var chatroomId: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func btC() {
		api.checkUserAvailability({ (user) in
			self.api.getHistoryTarget(user.userId, gender: Gender.Unspecified, page: 0, success: { (targets) in
				for t in targets where t.friendId == "56ebc89dd9062dbb5ffe9f27" {
					self.userId = user.userId
					self.uuid = ColorgyUserInformation.sharedInstance().userUUID
					self.chatroomId = t.chatroomId
					
					self.performSegueWithIdentifier("show room", sender: nil)
				}
				}, failure: nil)
			}, failure: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "show room" {
			let vc = segue.destinationViewController as! ChatroomViewController
			vc.chatroomId = self.chatroomId
			vc.userId = self.userId
			vc.uuid = self.uuid
		}
	}
}

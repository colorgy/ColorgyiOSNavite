//
//  FriendListViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class FriendListViewController: UIViewController {
	
	// MARK: - Parameters
	@IBOutlet weak var friendListTableView: UITableView!
	private var viewModel: FriendListViewModel?
	
	// MARK: - Life Cycle
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "好朋友"
		
		friendListTableView.delegate = self
		friendListTableView.dataSource = self
		friendListTableView.estimatedRowHeight = 120
		friendListTableView.rowHeight = UITableViewAutomaticDimension
		friendListTableView.separatorStyle = .None
		friendListTableView.backgroundColor = ColorgyColor.BackgroundColor
		
		viewModel = FriendListViewModel(delegate: self)
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		viewModel?.startLoadingFriend()
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel?.stopLoadingFriend()
	}
	
	// MARK: - Storyboard
	struct Storyboard {
		static let FriendListCellIdentifier = "Friend List Cell"
		static let GotoChatroomSegueIdentifier = "chat room segue"
		static let SayHelloCellIdentifier = "hello counts cell"
//		static let SayHelloSegue = "to say hi segue" 
	}
	
	public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Storyboard.GotoChatroomSegueIdentifier, let historyChatroom = sender as? HistoryChatroom {
			let vc = segue.destinationViewController as! ChatroomViewController
			vc.historyChatroom = historyChatroom
		}
	}
	
	// MARK: - Reload
	private func reloadFriend() {
		friendListTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
	}
	
	private func reloadHi() {
		friendListTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
	}
}

extension FriendListViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			// say hello cell
			return 1
		} else {
			return viewModel?.historyChatrooms.count ?? 0
		}
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.SayHelloCellIdentifier, forIndexPath: indexPath) as! SayHelloCountsCell
			cell.countsLabel.text = viewModel != nil ? "\(viewModel!.hiList.count)" : " "
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FriendListCellIdentifier, forIndexPath: indexPath) as! FriendListTableViewCell
			cell.historyChatroom = viewModel?.historyChatrooms[indexPath.row]
			return cell
		}
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			print("to hello view \(#line) \(#file) \(#function)")
		} else {
			performSegueWithIdentifier(Storyboard.GotoChatroomSegueIdentifier, sender: viewModel?.historyChatrooms[indexPath.row])
		}
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 51
		} else {
			return 82
		}
	}
}

extension FriendListViewController : FriendListViewModelDelegate {
	
	// reload part
	public func friendListViewModelReloadFriendList() {
		reloadFriend()
	}
	
	public func friendListViewModelReloadHiList() {
		reloadHi()
	}
	
	public func friendListViewModelFailToReloadFriendList(error: ChatAPIError, afError: AFError?) {
		print("api error: \(error) \(afError) \(#line) \(#function)")
	}
	
	public func friendListViewModelFailToReloadHiList(error: ChatAPIError, afError: AFError?) {
		print("api error: \(error) \(afError) \(#line) \(#function)")
	}
}
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
		
		friendListTableView.delegate = self
		friendListTableView.dataSource = self
		friendListTableView.estimatedRowHeight = 120
		friendListTableView.rowHeight = UITableViewAutomaticDimension
		friendListTableView.separatorStyle = .None
		friendListTableView.backgroundColor = ColorgyColor.BackgroundColor
		
		viewModel = FriendListViewModel(delegate: self)
	}
	
	// MARK: - Storyboard
	struct Storyboard {
		static let FriendListCellIdentifier = "Friend List Cell"
//		static let GotoChatroomSegueIdentifier = "goto chatroom"
		static let SayHelloCellIdentifier = "hello counts cell"
//		static let SayHelloSegue = "to say hi segue" 
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
			
			cell.userId = userId
			cell.historyChatroom = viewModel?.historyChatrooms[indexPath.row]
			
			return cell
		}
	}
}

extension FriendListViewController : FriendListViewModelDelegate {
	
}
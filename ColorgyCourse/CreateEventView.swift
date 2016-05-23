//
//  CreateEventView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class CreateEventView: UIView {

	private var createEventTableView: UITableView!
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		configureCreateEventTableView()
	}
	
	
	// MARK: - Key
	private struct NibName {
		static let titleCell = "CreateEventTitleCell"
		static let selectColorCell = "CreateEventColorCell"
	}
	
	// MARK: - Configuration
	private func configureCreateEventTableView() {
		
		createEventTableView = UITableView(frame: frame)
		
		// register nib
		createEventTableView.registerNib(UINib(nibName: NibName.titleCell, bundle: nil), forCellReuseIdentifier: NibName.titleCell)
		createEventTableView.registerNib(UINib(nibName: NibName.selectColorCell, bundle: nil), forCellReuseIdentifier: NibName.selectColorCell)
		
		// delegate & datasource
		createEventTableView.delegate = self
		createEventTableView.dataSource = self
		
		addSubview(createEventTableView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension CreateEventView : UITableViewDataSource {
	
	// TODO: into 3 sections, one for containing dates
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! CreateEventTitleCell
			return cell
		case 1:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.selectColorCell, forIndexPath: indexPath) as! CreateEventColorCell
			return cell
		default:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! CreateEventTitleCell
			return cell
		}
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.row {
		case 1:
			return 88.0
		default:
			return 44.0
		}
	}
}

extension CreateEventView : UITableViewDelegate {
	
}
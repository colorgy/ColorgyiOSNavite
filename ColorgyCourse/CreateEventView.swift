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
	// select color
	private var selectColorCellExpanded: Bool = false
	// repeat
	private var eventRepeated: Bool = false
	// viewmodel reference
	public var viewModel: CreateEventViewModel?

	
	// MARK: - Table view arrangement
	private enum CellArrangement {
		enum InfoSection: Int {
			case titleCell = 0
			case colorCell = 1
		}
		
		enum NonRepeatSection: Int {
			case repeatCell = 0
			case notificationCell = 1
		}
		
		enum RepeatSection: Int {
			case repeatCell = 0
			case repeatEndsCell = 1
			case notificationCell = 2
		}
	}
	
	private var infoSection: Int = 0
	private var repeatSection: Int = 1
	private var eventDateSection: Int = 2
	private var notesSection: Int = 3
	
	private var infoSectionCount: Int = 2
	private var repeatSectionCount: Int = 2
	private var eventDateSectionCount: Int = 10
	private var notesSectionCount: Int = 1
	
	public init(frame: CGRect, viewModel: CreateEventViewModel?) {
		super.init(frame: frame)
		self.viewModel = viewModel
		configureCreateEventTableView()
		backgroundColor = ColorgyColor.BackgroundColor
	}
	
	// MARK: - Key
	private struct NibName {
		// info nib
		static let titleCell = "CreateEventTitleCell"
		static let selectColorCell = "CreateEventColorCell"
		static let repeatedCell = "CreateEventRepeatedCell"
		static let repeatEndsCell = "CreateEventRepeatEndsCell"
		static let notificationCell = "CreateEventNotificationCell"
		// date nib
		static let dateAndLocationCell = "CreateEventDateAndLocationCell"
		// notes nib
		static let notesCell = "CreateEventNotesCell"
		// expanded nib
		static let expandedSelectColorCell = "CreateEventColorExpandedCell"
	}
	
	// MARK: - Configuration
	private func configureCreateEventTableView() {
		
		createEventTableView = UITableView(frame: frame)
		
		// register nib
		// info nib
		createEventTableView.registerNib(UINib(nibName: NibName.titleCell, bundle: nil), forCellReuseIdentifier: NibName.titleCell)
		createEventTableView.registerNib(UINib(nibName: NibName.selectColorCell, bundle: nil), forCellReuseIdentifier: NibName.selectColorCell)
		createEventTableView.registerNib(UINib(nibName: NibName.repeatedCell, bundle: nil), forCellReuseIdentifier: NibName.repeatedCell)
		createEventTableView.registerNib(UINib(nibName: NibName.repeatEndsCell, bundle: nil), forCellReuseIdentifier: NibName.repeatEndsCell)
		createEventTableView.registerNib(UINib(nibName: NibName.notificationCell, bundle: nil), forCellReuseIdentifier: NibName.notificationCell)
		// date nib
		createEventTableView.registerNib(UINib(nibName: NibName.dateAndLocationCell, bundle: nil), forCellReuseIdentifier: NibName.dateAndLocationCell)
		// notes nib
		createEventTableView.registerNib(UINib(nibName: NibName.notesCell, bundle: nil), forCellReuseIdentifier: NibName.notesCell)
		// expanded nib
		createEventTableView.registerNib(UINib(nibName: NibName.expandedSelectColorCell, bundle: nil), forCellReuseIdentifier: NibName.expandedSelectColorCell)
		
		// delegate & datasource
		createEventTableView.delegate = self
		createEventTableView.dataSource = self
		
		// style
		createEventTableView.separatorStyle = .None
		createEventTableView.backgroundColor = UIColor.clearColor()
		
		createEventTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(t)))
		
		addSubview(createEventTableView)
	}
	
	@objc private func t() {
		endEditing(true)
		print("yo")
		changeEventTo(!eventRepeated)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Color Cell
	// update color cell
	private func reloadColorCell() {
		createEventTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: CellArrangement.InfoSection.colorCell.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
	}
	
	/// Expand the color plate cell,
	/// true for expanded cell, false for collasped cell.
	/// Will update the cell if this method is called.
	private func expandColorCell(expanded: Bool) {
		selectColorCellExpanded = expanded
		reloadColorCell()
	}
	
	// MARK: - Repeat Cell
	private func reloadRepeatCell() {
		createEventTableView.reloadSections(NSIndexSet(index: repeatSection), withRowAnimation: UITableViewRowAnimation.Fade)
	}
	
	private func changeEventTo(repeated: Bool) {
		eventRepeated = repeated
		repeatSectionCount = repeated ? 3 : 2
		reloadRepeatCell()
	}
}

extension CreateEventView : UITableViewDataSource {
	
	// TODO: into 3 sections, one for containing dates
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case infoSection:
			return infoSectionCount
		case repeatSection:
			return repeatSectionCount
		case eventDateSection:
			return eventDateSectionCount
		case notesSection:
			return notesSectionCount
		default:
			return 0
		}
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		switch indexPath.section {
		case infoSection:
			// info section
			switch indexPath.row {
			case CellArrangement.InfoSection.titleCell.rawValue:
				let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! CreateEventTitleCell
				cell.delegate = self
				cell.setTitle(viewModel?.context.title)
				return cell
			case CellArrangement.InfoSection.colorCell.rawValue:
				if selectColorCellExpanded {
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.expandedSelectColorCell, forIndexPath: indexPath) as! CreateEventColorExpandedCell
					cell.updateSelectedColor(viewModel?.context.color)
					cell.delegate = self
					return cell
				} else {
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.selectColorCell, forIndexPath: indexPath) as! CreateEventColorCell
					cell.updateSelectedColor(viewModel?.context.color)
					cell.delegate = self
					return cell
				}
			default:
				break
			}
		case repeatSection:
			// info section
			if eventRepeated {
				switch indexPath.row {
				case CellArrangement.RepeatSection.repeatCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatedCell, forIndexPath: indexPath) as! CreateEventRepeatedCell
					return cell
				case CellArrangement.RepeatSection.repeatEndsCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatEndsCell, forIndexPath: indexPath) as! CreateEventRepeatEndsCell
					return cell
				case CellArrangement.RepeatSection.notificationCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notificationCell, forIndexPath: indexPath) as! CreateEventNotificationCell
					return cell
				default:
					break
				}
			} else {
				switch indexPath.row {
				case CellArrangement.NonRepeatSection.repeatCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatedCell, forIndexPath: indexPath) as! CreateEventRepeatedCell
					return cell
				case CellArrangement.NonRepeatSection.notificationCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notificationCell, forIndexPath: indexPath) as! CreateEventNotificationCell
					return cell
				default:
					break
				}
			}
		case eventDateSection:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.dateAndLocationCell, forIndexPath: indexPath) as! CreateEventDateAndLocationCell
			return cell
		case notesSection:
			// notes section
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notesCell, forIndexPath: indexPath) as! CreateEventNotesCell
			return cell
		default:
			break
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! CreateEventTitleCell
		return cell
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case infoSection:
			// info section
			switch indexPath.row {
			case CellArrangement.InfoSection.titleCell.rawValue:
				return 44.0
			case CellArrangement.InfoSection.colorCell.rawValue:
				if selectColorCellExpanded {
					return 88.0
				} else {
					return 44.0
				}
			default:
				return 44.0
			}
		case repeatSection:
			// date section
			return 44.0
		case eventDateSection:
			// date section
			return 175.0
		case notesSection:
			// notes section
			return 132.0
		default:
			return 44.0
		}
	}
	
	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case repeatSection:
			return 24.0
		default:
			return 0.0
		}
	}
	
	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
		case repeatSection:
			let view = UIView(frame: CGRectZero)
			view.backgroundColor = UIColor.clearColor()
			return view
		default:
			return nil
		}
	}
}

extension CreateEventView : UITableViewDelegate {
	
}

extension CreateEventView : CreateEventTitleCellDelegate {
	public func createEventTitleCellTitleTextUpdated(text: String?) {
		viewModel.
	}
}

extension CreateEventView : CreateEventColorCellDelegate {
	
	public func createEventColorCellNeedsExpand() {
		expandColorCell(true)
	}
	
	
	/// This method get called when user tap on a color
	public func createEventColorCell(needsCollapseWithSelectedColor color: UIColor?) {
		// need to update color inside context,
		// just call this method to update color inside context.
		viewModel?.updateSelectedColor(color)
		// after storing color,
		// update cell
		expandColorCell(false)
	}
}
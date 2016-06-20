//
//  EventManagerView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventManagerView: UIView {
	
	// MARK: - Parameters
	
	/// Where event manager show its data
	private var eventManagerTableView: UITableView!
	/// Flag to determine the color cell to expand or collapse.
	private var selectColorCellExpanded: Bool = false
	/// Flag to determine the event is repeat or not
	private var eventRepeated: Bool = false
	/// view model
	public var viewModel: EventManagerViewModel!
	
	
	// MARK: - Table view arrangement
	
	/// This enum helps to arrange cell positions.
	///
	/// Three sections here.
	///		1. Info: wit title, color
	///		2. Non Repeat: can control if this event is a repeat event or not
	///		3. Repeat: can control the end date of this event
	///
	/// If you want to change the arrangement of the cell, just revise the given number. Not to change the enum case.
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
	
	// MARK: - Section Position
	
	/// Info section position.
	private let infoSection: Int = 0
	/// Repeat section position.
	private let repeatSection: Int = 1
	/// Child event section position.
	private let childEventSection: Int = 2
	/// Add child section position.
	private let addChildEventSection: Int = 3
	/// Notes section position.
	private let notesSection: Int = 4
	
	// MARK: - Section Count
	
	/// Total sections we have now.
	private let totalSectionCount: Int = 5
	/// Info section count.
	private let infoSectionCount: Int = 2
	/// Repeat section count.
	private var repeatSectionCount: Int = 2
	/// Add child event section count.
	private let addChildEventSectionCount: Int = 1
	/// Notes section count.
	private let notesSectionCount: Int = 1
	
	// MARK: - Init
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.viewModel = EventManagerViewModel(delegate: self)
		configureCreateEventTableView()
		backgroundColor = ColorgyColor.BackgroundColor
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Key
	private struct NibName {
		// info nib
		static let titleCell = "EventManagerTitleCell"
		static let selectColorCell = "EventManagerColorCell"
		static let repeatedCell = "EventManagerRepeatedCell"
		static let repeatEndsCell = "EventManagerRepeatEndsCell"
		static let notificationCell = "EventManagerNotificationCell"
		// date nib
		static let childEventCell = "EventManagerChildEventCell"
		static let addChildEventCell = "EventManagerAddChildEventCell"
		// notes nib
		static let notesCell = "EventManagerNotesCell"
		// expanded nib
		static let expandedSelectColorCell = "EventManagerColorExpandedCell"
	}
	
	// MARK: - Configuration
	
	/// Configure event manager view. 
	/// First, create table view.
	/// Second, register for nibs.
	/// Third, setup delegate and datasource.
	/// Fourth, style.
	/// Fifth, add to subview.
	private func configureCreateEventTableView() {
		
		eventManagerTableView = UITableView(frame: frame)
		
		// register nib
		// info nib
		eventManagerTableView.registerNib(UINib(nibName: NibName.titleCell, bundle: nil), forCellReuseIdentifier: NibName.titleCell)
		eventManagerTableView.registerNib(UINib(nibName: NibName.selectColorCell, bundle: nil), forCellReuseIdentifier: NibName.selectColorCell)
		eventManagerTableView.registerNib(UINib(nibName: NibName.repeatedCell, bundle: nil), forCellReuseIdentifier: NibName.repeatedCell)
		eventManagerTableView.registerNib(UINib(nibName: NibName.repeatEndsCell, bundle: nil), forCellReuseIdentifier: NibName.repeatEndsCell)
		eventManagerTableView.registerNib(UINib(nibName: NibName.notificationCell, bundle: nil), forCellReuseIdentifier: NibName.notificationCell)
		// date nib
		eventManagerTableView.registerNib(UINib(nibName: NibName.childEventCell, bundle: nil), forCellReuseIdentifier: NibName.childEventCell)
		eventManagerTableView.registerNib(UINib(nibName: NibName.addChildEventCell, bundle: nil), forCellReuseIdentifier: NibName.addChildEventCell)
		// notes nib
		eventManagerTableView.registerNib(UINib(nibName: NibName.notesCell, bundle: nil), forCellReuseIdentifier: NibName.notesCell)
		// expanded nib
		eventManagerTableView.registerNib(UINib(nibName: NibName.expandedSelectColorCell, bundle: nil), forCellReuseIdentifier: NibName.expandedSelectColorCell)
		
		// delegate & datasource
		eventManagerTableView.delegate = self
		eventManagerTableView.dataSource = self
		
		// style
		eventManagerTableView.separatorStyle = .None
		eventManagerTableView.backgroundColor = UIColor.clearColor()
		
		eventManagerTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(t)))
		
		addSubview(eventManagerTableView)
	}
	
	@objc private func t() {
		endEditing(true)
		print("yo")
		changeEventTo(!eventRepeated)
	}
	
	// MARK: - Color Cell
	
	/// Reload color cell.
	///
	/// You can reload color cell while cell need to collapse or expand to show the cell user want.
	///
	/// **Causion**: This method is just the reload job. Expanding or collapsing will accroding to datacourse.
	private func reloadColorCell() {
		eventManagerTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: CellArrangement.InfoSection.colorCell.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
	}
	
	/// Expand the color plate cell,
	/// **true** for expanded cell, **false** for collasped cell.
	/// Will update the cell if this method is called.
	private func expandColorCell(expanded: Bool) {
		selectColorCellExpanded = expanded
		reloadColorCell()
	}
	
	// MARK: - Repeat Cell
	
	/// Reload repeat cell.
	private func reloadRepeatCell() {
		eventManagerTableView.reloadSections(NSIndexSet(index: repeatSection), withRowAnimation: UITableViewRowAnimation.Fade)
	}
	
	private func changeEventTo(repeated: Bool) {
		eventRepeated = repeated
		repeatSectionCount = repeated ? 3 : 2
		reloadRepeatCell()
	}
	
	// MARK: - Child Event Cell
	private func reloadChildEventSection() {
		eventManagerTableView.reloadSections(NSIndexSet(index: childEventSection), withRowAnimation: UITableViewRowAnimation.Fade)
	}
}

extension EventManagerView : UITableViewDataSource {
	
	// TODO: into 3 sections, one for containing dates
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return totalSectionCount
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case infoSection:
			return infoSectionCount
		case repeatSection:
			return repeatSectionCount
		case childEventSection:
			return viewModel.context.childEvents.count
		case addChildEventSection:
			return addChildEventSectionCount
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
				let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! EventManagerTitleCell
				cell.delegate = self
				cell.setTitle(viewModel.context.title)
				return cell
			case CellArrangement.InfoSection.colorCell.rawValue:
				if selectColorCellExpanded {
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.expandedSelectColorCell, forIndexPath: indexPath) as! EventManagerColorExpandedCell
					cell.updateSelectedColor(viewModel.context.color)
					cell.delegate = self
					return cell
				} else {
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.selectColorCell, forIndexPath: indexPath) as! EventManagerColorCell
					cell.updateSelectedColor(viewModel.context.color)
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
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatedCell, forIndexPath: indexPath) as! EventManagerRepeatedCell
					return cell
				case CellArrangement.RepeatSection.repeatEndsCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatEndsCell, forIndexPath: indexPath) as! EventManagerRepeatEndsCell
					return cell
				case CellArrangement.RepeatSection.notificationCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notificationCell, forIndexPath: indexPath) as! EventManagerNotificationCell
					return cell
				default:
					break
				}
			} else {
				switch indexPath.row {
				case CellArrangement.NonRepeatSection.repeatCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.repeatedCell, forIndexPath: indexPath) as! EventManagerRepeatedCell
					return cell
				case CellArrangement.NonRepeatSection.notificationCell.rawValue:
					let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notificationCell, forIndexPath: indexPath) as! EventManagerNotificationCell
					return cell
				default:
					break
				}
			}
		case childEventSection:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.childEventCell, forIndexPath: indexPath) as! EventManagerChildEventCell
			cell.childEvent = viewModel.context.childEvents[indexPath.row]
			cell.delegate = self
			return cell
		case addChildEventSection:
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.addChildEventCell, forIndexPath: indexPath) as! EventManagerAddChildEventCell
			cell.delegate = self
			return cell
		case notesSection:
			// notes section
			let cell = tableView.dequeueReusableCellWithIdentifier(NibName.notesCell, forIndexPath: indexPath) as! EventManagerNotesCell
			return cell
		default:
			break
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier(NibName.titleCell, forIndexPath: indexPath) as! EventManagerTitleCell
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
		case childEventSection:
			// date section
			return 175.0
		case addChildEventSection:
			return 36.0 + 48.0
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

extension EventManagerView : UITableViewDelegate {
	
}

// MARK: - View Model Delegate
extension EventManagerView : EventManagerViewModelDelegate {
	
}

// MARK: - Cell Delegates
extension EventManagerView : EventManagerTitleCellDelegate {
	
	public func eventManagerTitleCell(titleUpdatedWith text: String?) {
		viewModel.updateTitle(with: text)
	}
	
}

extension EventManagerView : EventManagerColorCellDelegate {
	
	public func eventManagerColorCellNeedsExpand() {
		expandColorCell(true)
	}
	
	/// This method get called when user tap on a color
	public func eventManagerColorCell(needsCollapseWithSelectedColor color: UIColor?) {
		// need to update color inside context,
		// just call this method to update color inside context.
		viewModel.updateSelectedColor(color)
		// after storing color,
		// update cell
		expandColorCell(false)
	}
}

extension EventManagerView : EventManagerChildEventCellDelegate {
	
	public func eventManagerChildEventCellNeedToDeleteChildEvent(id: String?) {
		viewModel.removeChildeEventWithId(id)
		reloadChildEventSection()
	}
	
}

extension EventManagerView : EventManagerAddChildEventCellDelegate {
	
	public func eventManagerAddChildEventCellAddChildEventButtonClicked() {
		// Will get called if user wants to add a new child event
		viewModel.createNewChildEvent()
		reloadChildEventSection()
	}
}
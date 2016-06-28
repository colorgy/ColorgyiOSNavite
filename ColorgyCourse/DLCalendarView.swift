//
//  DLCalendarView.swift
//  MonthCalender
//
//  Created by David on 2016/5/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public protocol DLCalendarViewDelegate: class {
	func DLCalendarViewDidChangeToDate(date: NSDate?)
	func DLCalendarViewDidSelectDate(date: NSDate)
	func DLCalendarViewDidDeselectDate(date: NSDate)
}

public class DLCalendarView: UIView {
	
	// MARK: - Parameters
	
	/// This is collection view of the calendar.
	var calendarCollectionView: UICollectionView!
	/// This is the flow layout of a collection view.
	var calendarCollectionViewLayout: UICollectionViewFlowLayout!
	
	/// Dates user selected.
	var selectedDates: [NSDate] = []
	/// Indexpath user previous selected, used to perform deselection animation.
	var previousSelectedIndexPath: NSIndexPath?
	// TODO: revise the name of calendar.
	/// Where we store dates.
	var calendar: [[NSDate]]!
	/// Special dates, like 端午節、二退、期中期末.
	var specialDates: [NSDate] = []
	/// Date that calendar starts.
	/// If this property is not assigned, default is 1970/1.
	var startDate: NSDate?
	/// Date that calendar ends.
	/// If this property is not assigned, default is 2099/12.
	var endDate: NSDate?
	
	/// This is the view that show weekdays.
	/// Like 一二三四五六日.
	var headerView: UIView!
	
	/// Delegation of this calendar view.
	weak var delegate: DLCalendarViewDelegate?
	
	// MARK: Color
	
	/// Color of today.
	/// Defaults to colorgy's main orange color.
	var todayColor: UIColor! = ColorgyColor.MainOrange
	/// Color of selected date.
	/// Defaults to colorgy's main orange color.
	var selectedColor: UIColor! = ColorgyColor.MainOrange
	/// Color of selected date's text.
	/// Defaults to white.
	var selectedDateTextColor: UIColor! = UIColor.whiteColor()
	/// Color for dates and details that is normal state.
	/// Like 四月 below date's text, or normal state date text color.
	/// Defaults to colorgy's gray content text color.
	var normalContentTextColor: UIColor! = ColorgyColor.grayContentTextColor
	/// Color for special dates, like 期中期末、二退.
	/// Defaults to colorgy's water blue color.
	var specialDateColor: UIColor! = ColorgyColor.waterBlue
	
	// MARK: - Init
	
	/// Init calendar with a header on top of it.
	/// Header will display content like weekdays.
	public convenience init(frameWithHeader frame: CGRect) {
		
		self.init()
		// First, set the frame size of this calendar.
		self.frame = frame
		
		// determine the padding of left, right and bottom.
		let padding: CGFloat = frame.width * 0.05
		
		// determine size of header.
		// Default height of header is 42.
		let headerSize = CGSize(width: frame.width, height: 42)
		
		// Container is the base view of header view, which I put weekdays onto it.
		// Will snapshot after I finish configuring it.
		let container = UIView(frame: CGRect(origin: CGPointZero, size: headerSize))
//		let weekdays = ["日","一","二","三","四","五","六"]
		let weekdays = ["一","二","三","四","五","六","日"]
		
		// loop through it and determine its style and arrangement.
		for (index, weekday) : (Int, String) in weekdays.enumerate() {
			let label = UILabel()
			label.frame.size.height = headerSize.height
			label.text = weekday
			label.textAlignment = .Center
			label.textColor = UIColor.grayColor()
			label.sizeToFit()
			label.center.y = container.bounds.midY
			// First, trim left and right padding.
			// Second, calculate the offset according to index.
			label.center.x = ((container.bounds.width - 2 * padding) / weekdays.count.CGFloatValue) * (CGFloat(index) + 0.5) + padding
			container.addSubview(label)
		}
		
		addSubview(container)
		
		// configure calendar
		configureCalendar(CGRect(
			origin: CGPoint(x: 0, y: headerSize.height),
			size: CGSize(width: frame.width, height: frame.height - headerSize.height)))
	}
	
	// TODO: remove this method
	/// This can generate some random special dates for test.
	func randomSpecialDates() {
		8.times { (index) in
			let randomDays = random() % 100
			let factor = random() % 10 > 5 ? -1 : 1
			if let date = self.dateByAddingDays(factor * randomDays, toDate: NSDate()) {
				self.specialDates.append(date)
			}
		}
	}

	/// Init a calendar without header.
	public override init(frame: CGRect) {
		super.init(frame: frame)
		configureCalendar(frame)
	}
	
	// MARK: - Init
	
	/// Configure calendar with given size.
	func configureCalendar(frame: CGRect) {
		
		// TODO: remove this random special dates.
		randomSpecialDates()
		
		// First, configure layout of the calendar collection view.
		calendarCollectionViewLayout = UICollectionViewFlowLayout()
		// Second, according to layout, create calendar collection view.
		calendarCollectionView = UICollectionView(frame: frame, collectionViewLayout: calendarCollectionViewLayout)
		// set calendar dates to an empty array.
		calendar = []
		
		// Then determine layout.
		// We want padding on left, right and bottom side.
		// 3 percent of the given frame's width.
		let padding: CGFloat = frame.width * 0.03
		calendarCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: padding, right: padding)
		// No space between every line.
		calendarCollectionViewLayout.minimumLineSpacing = 0
		calendarCollectionViewLayout.minimumInteritemSpacing = 0
		// After setting the layout, we are going to determine its item size.
		let itemWidth = (frame.width - padding * 2) / 7
		let itemHeight = (frame.height - padding) / 6
		calendarCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
		
		// After all the work we've done above, set the scrolling direction to horizontal.
		calendarCollectionViewLayout.scrollDirection = .Horizontal
		
		// default calendar collectino view's background color to clear color.
		// So if we change the calendar color, it wont affect.
		calendarCollectionView.backgroundColor = UIColor.clearColor()
		// We want this calendar to stay in focus in every scroll.
		// Enable paging here.
		calendarCollectionView.pagingEnabled = true
		
		// Delegate and datasource.
		calendarCollectionView.delegate = self
		calendarCollectionView.dataSource = self
		
		// Register the class to collection view for the reusable cell.
		calendarCollectionView.registerClass(DLCalendarViewCell.self, forCellWithReuseIdentifier: "cell")
		
		addSubview(calendarCollectionView)
		
		// After creating the view, now we are going to create the date to be shown on the calendar.
		// Configure calendar dates.
		
		// First, check if start date is assigned.
		// If not, set the default to 1970/1/1.
		if startDate == nil {
			startDate = NSDate.create(dateOn: 1970, month: 1, day: 1)
		}
		// Check if end date is assigned.
		// If not, set the default to 1970/1/1.
		if endDate == nil {
			endDate = NSDate.create(dateOn: 2099, month: 12, day: 31)
		}
		
		if let startDate = startDate, let endDate = endDate {
			// calculate the required months to create
			let monthsToCreate = monthsBetween(date: startDate, andDate: endDate)
			if monthsToCreate >= 0 {
				// loop through all the month need to create.
				for month in 0..<monthsToCreate {
					// Starting from start date, get the date by adding month.
					// then configure the month that contains the dates we needed.
					if let date = dateByAddingMonths(month, toDate: startDate), let monthOnCalendar = configureMonthByDate(date) {
						calendar.append(monthOnCalendar)
					}
				}
			} else {
				print("error creating caclendar!!!")
			}
		} else {
			print("error creating calendar!!")
		}
		
		calendarCollectionView.reloadData()
	}
	
	/// Get months between given dates.
	func monthsBetween(date date: NSDate, andDate: NSDate) -> Int {
		return (yearOfDate(andDate) - yearOfDate(date)) * 12 + (monthOfDate(andDate) - monthOfDate(date)) + 1
	}
	
	/// This method will create dates that will show on specific month.
	/// ex. 2016/6, will look like this
	///
	/// ```
	/// 29 30 31  1  2  3  4
	///	 5  6  7  8  9 10 11
	/// 12 13 14 15 16 17 18
	/// 19 20 21 22 23 24 25
	/// 26 27 28 29 30  1  2
	///  3  4  5  6  7  8  9
	/// ```
	/// 
	/// Will totally display 42 days, 6 weeks of this month.
	func configureMonthByDate(date: NSDate) -> [NSDate]? {
		// TODO: 完成這邊的註解、跟weekday的排列問題
		// check if this date has a first date of the month
		guard let firstDayOfTheMonth = beginingDateOfMonth(date) else { return nil }
		// initial cache
		var datesOfMonth = [NSDate]()
		// get weekday of the beginning date of this month
		let startWeekday = weekdayOfDate(firstDayOfTheMonth)

		// first, create dates of this month.
		for dayOffsetFromFirstDay in 0..<daysAMonthOfDate(firstDayOfTheMonth) {
			// 0 is first day of this month.
			// this for loop will create dates of this month
			// ex. 4/1 ~ 4/30, 30 is +29 offset from first day
			if let date = dateByAddingDays(dayOffsetFromFirstDay, toDate: firstDayOfTheMonth) {
				datesOfMonth.append(date)
			}
		}
		// second, show previous month's dates
		// ex. if 4/1 is fri, so you are going to show 5/31 on preivous thu, etc.
		let rangeFromSunToSat = (1..<startWeekday)
		let rangeFromMonToSun = (1..<((startWeekday - 1) == 0 ? 7 : (startWeekday - 1)))
		for daysFromPreviousMonth in rangeFromMonToSun {
			if let date = dateBySubtractingDays(daysFromPreviousMonth, toDate: firstDayOfTheMonth) {
				datesOfMonth.insert(date, atIndex: 0)
			}
		}
		// third, make this array to contain 42 days.
		guard var endDate = endDateOfMonth(firstDayOfTheMonth) else { return nil }
		while datesOfMonth.count != 42 {
			if let date = tomorrowOfDate(endDate) {
				datesOfMonth.append(date)
				endDate = date
			}
		}
		
		return datesOfMonth
	}
	
	// MARK: - Helper Methods
	
	/// Can check how many days a month by the given date.
	func daysAMonthOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
	}
	
	/// Can get the weekday by the given date.
	///
	/// Will return from 1 ~ 7
	///
	/// **1** is **sunday**
	///
	/// **7** is **saturday**
	///
	/// ```
	/// sun mon tue wen thu fri sat
	///  1   2   3   4   5   6   7
	/// ```
	func weekdayOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: date)
	}
	
	func beginingDateOfMonth(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day = 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func endDateOfMonth(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.month += 1
		component.day = 0
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func tomorrowOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day += 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func yearOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date).year
	}
	
	func monthOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date).month
	}
	
	func dayOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date).day
	}
	
	func dateByAddingMonths(months: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.month = months
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateBySubtractingMonths(months: Int, toDate: NSDate) -> NSDate? {
		return dateByAddingMonths(-months, toDate: toDate)
	}
	
	func dateByAddingDays(days: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.day = days
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateBySubtractingDays(days: Int, toDate: NSDate) -> NSDate? {
		return dateByAddingDays(-days, toDate: toDate)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func stringOfDate(date: NSDate) -> String {
		let year = yearOfDate(date)
		let month = monthOfDate(date)
		let day = dayOfDate(date)
		return "\(year)-\(month)-\(day)"
	}
	
	func dateOfIndexPath(indexPath: NSIndexPath) -> NSDate {
		let indexOnCalendar = 7 * (indexPath.item % 6) + indexPath.item / 6
//		print(indexOnCalendar)
//		print(calendar[indexPath.section])
//		print("幹", dayOfDate(calendar[indexPath.section][indexOnCalendar]))
		return calendar[indexPath.section][indexOnCalendar]
	}
	
	func dateOfSection(section: Int) -> NSDate? {
		return beginingDateOfMonth(calendar[section][21])
	}
	
	func selectIndexPathOnCalendar(indexPath: NSIndexPath) {
		// first, deselect a date
		if let date = selectedDates.first {
			removeDate(date)
		}
		// second, select a date
		let dateSelected = dateOfIndexPath(indexPath)
		selectedDates.append(dateSelected)
		delegate?.DLCalendarViewDidSelectDate(dateSelected)
	}
	
	func removeDate(date: NSDate) {
		if let index = selectedDates.indexOf(date) {
			selectedDates.removeAtIndex(index)
			delegate?.DLCalendarViewDidDeselectDate(date)
		}
	}
	
	func currentDateOfIndexPath(indexPath: NSIndexPath) -> NSDate {
		return calendar[indexPath.section][21]
	}
	
	func deselectPreviousIndexPath(andReplaceWith newIndexPath: NSIndexPath) {
		if let previousSelectedIndexPath = previousSelectedIndexPath {
			// if there exits a previous selected indexpathm deselect it!
			let cell = calendarCollectionView.cellForItemAtIndexPath(previousSelectedIndexPath) as! DLCalendarViewCell
			cell.performSelect()
		}
		
		previousSelectedIndexPath = newIndexPath
	}
	
	// MARK: - Getters
	var currentMaxMonths: Int? {
		if let startDate = startDate, let endDate = endDate {
			return monthsBetween(date: startDate, andDate: endDate)
		}
		return nil
	}
	
	var calendarWidth: CGFloat {
		return calendarCollectionView.frame.width
	}
	
	var calendarContentOffsetX: CGFloat {
		return calendarCollectionView.contentOffset.x
	}
	
	var currentDate: NSDate? {
		let section = Int(calendarContentOffsetX / calendarWidth)
		return dateOfSection(section)
	}
	
	// MARK: - Calendar mover
	func jumpToTaday() {
		let now = NSDate()
		jumpToDate(now)
	}
	
	func jumpToDate(date: NSDate) {
		guard let point = pointOfDate(date) else { return }
		moveToPoint(point)
	}
	
	func pointOfDate(date: NSDate) -> CGPoint? {
		guard let section = sectionOfDate(date) else { return nil }
		return CGPoint(x: calendarWidth * CGFloat(section), y: 0)
	}
	
	func dateFromOffset(offset: CGFloat) {
		
	}
	
	func sectionOfDate(date: NSDate) -> Int? {
		guard let startDate = startDate, let endDate = endDate else { return nil }
		guard date.timeIntervalSinceDate(startDate) >= 0 else { return nil }
		guard date.timeIntervalSinceDate(endDate) <= 0 else { return nil }
		let months = monthsBetween(date: startDate, andDate: date)
		guard months - 1 >= 0 else { return nil }
		return months - 1
	}
	
	func moveToPoint(point: CGPoint) {
		calendarCollectionView.setContentOffset(point, animated: true)
	}
	
	func nextMonth() {
		let point = CGPoint(x: calendarContentOffsetX + calendarWidth, y: 0)
		if let startDate = startDate, let endDate = endDate {
			if !(point.x > CGFloat(monthsBetween(date: startDate, andDate: endDate) - 1) * calendarWidth) {
				calendarCollectionView.setContentOffset(point, animated: true)
			}
		}
	}
	
	func previousMonth() {
		let point = CGPoint(x: calendarContentOffsetX - calendarWidth, y: 0)
		if !(point.x < 0) {
			calendarCollectionView.setContentOffset(point, animated: true)
		}
	}
	
	func reloadCalendarColor() {
		calendarCollectionView.reloadData()
	}
}

extension DLCalendarView : UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return calendar.count
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendar[section].count
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DLCalendarViewCell
		cell.calendar = self
		cell.currentCalenderDate = currentDateOfIndexPath(indexPath)
		cell.date = dateOfIndexPath(indexPath)
		
		return cell
	}
	
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DLCalendarViewCell
		selectIndexPathOnCalendar(indexPath)
		deselectPreviousIndexPath(andReplaceWith: indexPath)
		cell.calendar = self
		cell.performSelect()
	}
}
extension DLCalendarView : UIScrollViewDelegate {
	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
		let date = dateOfSection(page)
		delegate?.DLCalendarViewDidChangeToDate(date)
	}
}
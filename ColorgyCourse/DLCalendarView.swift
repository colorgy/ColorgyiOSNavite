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
	
	var calendarCollectionView: UICollectionView!
	var calendarCollectionViewLayout: UICollectionViewFlowLayout!
	
	var selectedDates: [NSDate] = []
	var calendar: [[NSDate]]!
	var startDate: NSDate?
	var endDate: NSDate?
	
	var headerView: UIView!
	
	weak var delegate: DLCalendarViewDelegate?
	
	var todayColor: UIColor! = UIColor.redColor()
	var selectedColor: UIColor! = UIColor(red:0.448,  green:0.647,  blue:0.792, alpha:1)
	var selectedDateTextColor: UIColor! = UIColor.whiteColor()
	var thisMonthTextColor: UIColor! = UIColor.blackColor()
	var otherMonthTextColor: UIColor! = UIColor.lightGrayColor()
	
	public convenience init(frameWithHeader frame: CGRect) {
		
		self.init()
		self.frame = frame
		
		// configure header
		let headerSize = CGSize(width: frame.width, height: 42)
		
		let container = UIView(frame: CGRect(origin: CGPointZero, size: headerSize))
//		let weekdays = ["日","一","二","三","四","五","六"]
		let weekdays = ["一","二","三","四","五","六","日"]
		for (index, weekday) : (Int, String) in weekdays.enumerate() {
			let label = UILabel()
			label.frame.size.height = headerSize.height
			label.text = weekday
			label.textAlignment = .Center
			label.textColor = UIColor.grayColor()
			label.sizeToFit()
			label.center.y = container.bounds.midY
			label.center.x = (container.bounds.width / CGFloat(weekdays.count)) * (CGFloat(index) + 0.5)
			container.addSubview(label)
		}
		
		addSubview(container)
		
		// configure calendar
		configureCalendar(CGRect(
			origin: CGPoint(x: 0, y: headerSize.height),
			size: CGSize(width: frame.width, height: frame.height - headerSize.height)))
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		configureCalendar(frame)
	}
	
	func configureCalendar(frame: CGRect) {
		
		calendarCollectionViewLayout = UICollectionViewFlowLayout()
		calendarCollectionView = UICollectionView(frame: frame, collectionViewLayout: calendarCollectionViewLayout)
		calendar = []
		
		// layout
		calendarCollectionViewLayout.sectionInset = UIEdgeInsetsZero
		calendarCollectionViewLayout.minimumLineSpacing = 0
		calendarCollectionViewLayout.minimumInteritemSpacing = 0
		let itemWidth = frame.width / 7
		let itemHeight = frame.height / 6
		calendarCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
		calendarCollectionViewLayout.scrollDirection = .Horizontal
		
		// configure collection view
		calendarCollectionView.backgroundColor = UIColor.clearColor()
		calendarCollectionView.pagingEnabled = true
		calendarCollectionView.delegate = self
		calendarCollectionView.dataSource = self
		
		calendarCollectionView.registerClass(DLCalendarViewCell.self, forCellWithReuseIdentifier: "cell")
		
		addSubview(calendarCollectionView)
		
		// configure calendar
		if startDate == nil {
			let components = NSDateComponents()
			components.year = 1970
			components.month = 1
			components.day = 1
			startDate = NSCalendar.currentCalendar().dateFromComponents(components)
		}
		if endDate == nil {
			let components = NSDateComponents()
			components.year = 2099
			components.month = 12
			components.day = 31
			endDate = NSCalendar.currentCalendar().dateFromComponents(components)
		}
		if let startDate = startDate, let endDate = endDate {
			// calculate the required months to create
			let monthsToCreate = monthsBetween(date: startDate, andDate: endDate)
			if monthsToCreate >= 0 {
				for month in 0..<monthsToCreate {
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
	
	func monthsBetween(date date: NSDate, andDate: NSDate) -> Int {
		return (yearOfDate(andDate) - yearOfDate(date)) * 12 + (monthOfDate(andDate) - monthOfDate(date)) + 1
	}
	
	func configureMonthByDate(date: NSDate) -> [NSDate]? {
		
		// check if this date has a first date of the month
		guard let firstDayOfTheMonth = beginingDateOfMonth(date) else { return nil }
		// initial cache
		var datesOfMonth = [NSDate]()
		// get weekday of the beginning date of this month
		let startWeekday = weekdayOfDate(firstDayOfTheMonth)

		// first, create dates of this month.
		for dayOffsetFromFirstDay in 0..<daysOfDate(firstDayOfTheMonth) {
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
	
	func daysOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
	}
	
	func weekdayOfDate(date: NSDate) -> Int {
		// will return from 1 ~ 7
		// 1 is sunday
		// 7 is saturday
		// sun mon tue wen thu fri sat
		//  1	2	3	4	5	6	7
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
		let dateSelected = dateOfIndexPath(indexPath)
		if !selectedDates.contains(dateSelected) {
			selectedDates.append(dateSelected)
//			print("select", dateSelected)
			delegate?.DLCalendarViewDidSelectDate(dateSelected)
		} else {
			removeDate(dateSelected)
		}
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
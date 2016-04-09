//
//  DateExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension NSDate {
	
	/// To get year string from this date
	var year: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "yyyy"
		return formatter.stringFromDate(self)
	}
	
	var month: String {
		/// To get month string from this date
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "MM"
		return formatter.stringFromDate(self)
	}
	
	/// To get day string from this date
	var day: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "dd"
		return formatter.stringFromDate(self)
	}
	
	/// To get hour string from this date
	var hour: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "HH"
		return formatter.stringFromDate(self)
	}
	
	/// To get minute string from this date
	var minute: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "mm"
		return formatter.stringFromDate(self)
	}
	
	/// To get second string from this date
	var second: String {
		let formatter = NSDateFormatter()
		//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.dateFormat = "ss"
		return formatter.stringFromDate(self)
	}
}
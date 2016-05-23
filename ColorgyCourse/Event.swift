//
//  Event.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class Event: CustomStringConvertible {
	
	public private(set) var title: String?
	public private(set) var location: String?
	public private(set) var starts: NSDate
	public private(set) var ends: NSDate
	public private(set) var repeats: Bool
	public private(set) var color: UIColor
	public private(set) var alertTime: NSDate?
	public private(set) var notes: String?
	
	public var description: String {
		return "Event: {\n\ttitle -> \(title)\n\tlocation -> \(location)\n\tstarts -> \(starts)\n\tends -> \(ends)\n\trepeats -> \(repeats)\n\tcolor -> \(color)\n\talertTime -> \(alertTime)\n\tnotes -> \(notes)\n}"
	}
	
	public init(title: String?, location: String?, starts: NSDate, ends: NSDate, repeats: Bool, color: UIColor, alertTime: NSDate?, notes: String?) {
		self.title = title
		self.location = location
		self.starts = starts
		self.ends = ends
		self.repeats = repeats
		self.color = color
		self.alertTime = alertTime
		self.notes = notes
	}
}
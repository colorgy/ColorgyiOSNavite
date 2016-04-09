//
//  PeriodRawData.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class PeriodRawData: NSObject {
	
	// MARK: - Parameters
	let code: String
	let id: Int
	let order: Int
	let type: String
	let startTime: String
	let endTime: String
	
	public override var description: String {
		return "PeriodRawData: {\n\tcode: \(code)\n\tid: \(id)\n\torder: \(order)\n\ttype: \(type)\n\tstartTime: \(startTime)\n\tendTime: \(endTime)\n}"
	}
	
	// MARK: - Init
	private init?(code: String?, id: Int?, order: Int?, type: String?, startTime: String?, endTime: String?) {
		
		guard let code = code else { return nil }
		guard let id = id else { return nil }
		guard let order = order else { return nil }
		guard let type = type else { return nil }
		let startTime = startTime ?? ""
		let endTime = endTime ?? ""
		
		self.code = code
		self.id = id
		self.order = order
		self.type = type
		self.startTime = startTime
		self.endTime = endTime
		
		super.init()
	}
	
	public convenience init?(json: JSON) {
		
		var _code: String?
		var _id: Int?
		var _order: Int?
		var _type: String?
		// TODO: time can be nil
		var _time: String?
		var _startTime: String?
		var _endTime: String?
		
		_code = json[Key.code].string
		_id = json[Key.id].int
		_order = json[Key.order].int
		_type = json[Key.type].string
		_time = json[Key.time].string
		
		// handle time
		let time = PeriodRawData.separateTime(_time)
		
		_startTime = time.startTime
		_endTime = time.endTime
		
		self.init(code: _code, id: _id, order: _order, type: _type, startTime: _startTime, endTime: _endTime)
	}
	
	// MARK: - Keys
	private struct Key {
		static let code = "code"
		static let id = "id"
		static let order = "order"
		static let type = "_type"
		static let time = "time"
	}
	
	// MARK: - Helper
	private class func separateTime(time: String?) -> (startTime: String?, endTime: String?) {
		
		guard let time = time else { return (nil, nil) }
		
		let timeArray = time.componentsSeparatedByString("_")
		
		return (timeArray.first, timeArray.last)
	}
	
	// MARK: - Generator
	/// Generate Period Raw Data using json
	///
	/// Will be sorted in order while generating
	public class func generatePeiordRawData(json: JSON) -> [PeriodRawData]? {
		
		// must be an array
		guard json.isArray else { return nil }
		
		// initialize cache
		var rawData = [PeriodRawData]()
		// loop it
		for (_, json) : (String, JSON) in json {
			if let data = PeriodRawData(json: json) {
				rawData.append(data)
			}
		}
		
		// sort it
		rawData = rawData.sort({ $0.order < $1.order })
		
		// return
		return rawData
	}
	
	/// Generate Fake Period Raw Data
	///
	/// Will generate 16 period by default if you pass in nil
	///
	/// Or pass in required count
	/// - parameters:
	///		- count: nil for default, or your required period count
	/// - returns: an array of PeriodRawData
	public class func generateFakePeiordRawData(count: Int) -> [PeriodRawData] {
		
		// initialize cache
		var rawData = [PeriodRawData]()
		// loop it
		for index in 0..<count {
			if let data = PeriodRawData(code: "\(index)", id: index, order: index, type: "Fake Period data", startTime: nil, endTime: nil) {
				rawData.append(data)
			}
		}
		
		// sort it
		rawData = rawData.sort({ $0.order < $1.order })
		
		// return
		return rawData
	}
}
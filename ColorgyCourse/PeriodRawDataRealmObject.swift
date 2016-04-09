//
//  PeriodRawDataRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

public class PeriodRawDataRealmObject: Object {
	
	public dynamic var code = ""
	public dynamic var id = 0
	public dynamic var order = 0
	public dynamic var type = ""
	public dynamic var startTime = ""
	public dynamic var endTime = ""
	
	/// Help you to transform an array of PeriodRawData into PeriodRawDataRealmObject array
	public class func transfromPeriodRawData(data: [PeriodRawData]) -> [PeriodRawDataRealmObject] {
		
		var dataObject = [PeriodRawDataRealmObject]()
		
		for _data in data {
			dataObject.append(PeriodRawDataRealmObject(data: _data))
		}
		
		return dataObject
	}
	
	/// Use PeriodRawData to init a PeriodRawDataRealmObject
	public init(data: PeriodRawData) {
		
		self.code = data.code
		self.id = data.id
		self.order = data.order
		self.type = data.type
		self.startTime = data.startTime
		self.endTime = data.endTime
		
		super.init()
	}
	
	required public init() {
		fatalError("init() has not been implemented")
	}
}

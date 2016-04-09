//
//  PeriodRawDataRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

/// Specify the state of storing to Realm
public enum RealmStoringState {
	case Success
	case Failure
}

/// PeriodRawData from Realm
final public class PeriodRawDataRealmObject: Object {
	
	// MARK: - Parameters
	public dynamic var code = ""
	public dynamic var id = 0
	public dynamic var order = 0
	public dynamic var type = ""
	public dynamic var startTime = ""
	public dynamic var endTime = ""
	
	// MARK: - Init
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
	
	// MARK: - Generator
	/// Help you to transform an array of PeriodRawData into PeriodRawDataRealmObject array
	public class func transfromPeriodRawData(data: [PeriodRawData]) -> [PeriodRawDataRealmObject] {
		
		var dataObject = [PeriodRawDataRealmObject]()
		
		for _data in data {
			dataObject.append(PeriodRawDataRealmObject(data: _data))
		}
		
		return dataObject
	}
	
	// MARK: - Query
	/// Get all stored PeriodRawDataRealmObject
	public class func getAllStoredPeriodRawDataRealmObject() -> [PeriodRawDataRealmObject] {
		do {
			// Get the default Realm
			let realm = try Realm()
			let objects = realm.objects(PeriodRawDataRealmObject)
			// map the objects result
			return objects.map({ return $0 })
		} catch {
			return []
		}
	}
	
	// MARK: - Store
	/// You can store PeriodRawData into Realm
	public class func storePeriodRawData(data: [PeriodRawData]) -> RealmStoringState {
		do {
			// Get the default Realm
			let realm = try Realm()
			// Start writing
			realm.beginWrite()
			// transfrom data to periodRawDataRealmObject array
			let periodRawDataRealmObject = PeriodRawDataRealmObject.transfromPeriodRawData(data)
			// add the array to Realm
			realm.add(periodRawDataRealmObject)
			// Try to save to Realm
			try realm.commitWrite()
			// If success, return true
			return RealmStoringState.Success
		} catch {
			// Cannot get the default Realm
			return RealmStoringState.Failure
		}
	}
	
	/// You can store PeriodRawDataRealmObject into Realm
	public class func storePeriodRawDataRealmObject(data: [PeriodRawDataRealmObject]) -> RealmStoringState {
		do {
			// Get the default Realm
			let realm = try Realm()
			// Start writing
			realm.beginWrite()
			// add the array to Realm
			realm.add(data)
			// Try to save to Realm
			try realm.commitWrite()
			// If success, return true
			return RealmStoringState.Success
		} catch {
			// Cannot get the default Realm
			return RealmStoringState.Failure
		}
	}
	
	// MARK: - Delete
	public class func deleteAllStoredPeriodRawDataRealmObject() -> RealmStoringState {
		do {
			// Get the default Realm
			let realm = try Realm()
			// Start writing
			realm.beginWrite()
			// transfrom data to periodRawDataRealmObject array
			let storedPeriodRawDataRealmObject = PeriodRawDataRealmObject.getAllStoredPeriodRawDataRealmObject()
			// delete SequenceType
			realm.delete(storedPeriodRawDataRealmObject)
			// Try to save to Realm
			try realm.commitWrite()
			// If success, return true
			return RealmStoringState.Success
		} catch {
			// Cannot get the default Realm
			return RealmStoringState.Failure
		}
	}
}

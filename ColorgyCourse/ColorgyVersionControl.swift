//
//  ColorgyVersionControl.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/22.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFNetworking

final public class ColorgyVersionControl {
	
	public private(set) var newVersion: String
	public private(set) var oldVersion: String
	
	public class func sharedInstanse() -> ColorgyVersionControl {
		
		struct Static {
			static let instance: ColorgyVersionControl = ColorgyVersionControl()
		}
		
		return Static.instance
	}
	
	private init() {
		newVersion = ""
		oldVersion = ""
	}
	
	public class func checkForUpdate() {
		let manager = AFHTTPSessionManager()
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		manager.GET("http://itunes.apple.com/lookup?id=998230121", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
			if let response = response {
				let json = JSON(response)
				updateVersion(parseAppVersionFromJSON(json), oldVersion: currentAppVersion())
				NSNotificationCenter.defaultCenter().postNotificationName(ColorgyAppNotification.NewVersionAppReleased, object: nil)
			}
		}, failure: nil)
	}
	
	private class func parseAppVersionFromJSON(json: JSON) -> String? {
		guard let first = json["results"].first?.1 else { return nil }
		return first["version"].string
	}
	
	private class func currentAppVersion() -> String? {
		if let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
			return appVersion
		}
		return nil
	}
	
	private class func updateVersion(newVersion: String?, oldVersion: String?) {
		guard newVersion != nil else { return }
		guard oldVersion != nil else { return }
		ColorgyVersionControl.sharedInstanse().newVersion = newVersion!
		ColorgyVersionControl.sharedInstanse().oldVersion = oldVersion!
	}
}
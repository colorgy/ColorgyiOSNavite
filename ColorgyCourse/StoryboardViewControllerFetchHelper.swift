//
//  StoryboardViewControllerFetchHelper.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

final public class StoryboardViewControllerFetchHelper {
	
	private static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
	
	public class func fetchPhoneValidationViewController() -> PhoneValidationViewController? {
		return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.phoneValidationView) as? PhoneValidationViewController
	}
	
	public class func fetchChooseSchooolViewController() -> ChooseSchoolViewController? {
		return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.chooseSchoolView) as? ChooseSchoolViewController
	}
}
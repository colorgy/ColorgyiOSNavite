//
//  StoryboardViewControllerFetchHelper.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

/// This helper can help you to get view controllers in storyboard without knowing ther id.
final public class StoryboardViewControllerFetchHelper {
	
	/// Main storyboard.
	private static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
	
	/// Fetch phone validation view controller.
	public class func fetchPhoneValidationViewController() -> PhoneValidationViewController? {
		return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.phoneValidationView) as? PhoneValidationViewController
	}
	
	/// Fetch choose school view controller
	public class func fetchChooseSchooolViewController() -> ChooseSchoolViewController? {
		return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.chooseSchoolView) as? ChooseSchoolViewController
	}
}
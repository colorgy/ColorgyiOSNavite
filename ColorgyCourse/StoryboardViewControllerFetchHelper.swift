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

	public struct Main {
		/// Main storyboard.
		private static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
		
		/// Fetch phone validation view controller.
		public static func fetchPhoneValidationViewController() -> PhoneValidationViewController {
			return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MainStoryboard.phoneValidationView) as! PhoneValidationViewController
		}
		
		/// Fetch choose school view controller
		public static func fetchChooseSchooolViewController() -> ChooseSchoolViewController {
			return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MainStoryboard.chooseSchoolView) as! ChooseSchoolViewController
		}
	}
	
	public struct MyPage {
		
		private static let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
		
		/// Fetch settgins view controller.
		public static func fetchSettingsViewController() -> SettingsViewController {
			return myPageStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyPageStoryboard.settingsView) as! SettingsViewController
		}
	}
}
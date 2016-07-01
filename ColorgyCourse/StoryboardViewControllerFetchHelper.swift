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
		
		public static func fetchEmailLoginViewController() -> EmailLoginViewController {
			return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MainStoryboard.emailLoginView) as! EmailLoginViewController
		}
		
		public static func fetchEmailRegisterViewController() -> EmailRegisterViewController {
			return mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MainStoryboard.emailRegisterView) as! EmailRegisterViewController
		}
	}
	
	public struct MyPage {
		
		private static let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
		
		/// Fetch settgins view controller.
		public static func fetchSettingsViewController() -> SettingsViewController {
			return myPageStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyPageStoryboard.settingsView) as! SettingsViewController
		}
		
		/// Fetch notification settgins view controller.
		public static func fetchNotificationSettingsViewController() -> NotificationSettingsViewController {
			return myPageStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyPageStoryboard.notificationSettingsView) as! NotificationSettingsViewController
		}
		
		/// Fetch privacy settgins view controller.
		public static func fetchPrivacySettingsViewController() -> PrivacySettingsViewController {
			return myPageStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyPageStoryboard.privacySettingsView) as! PrivacySettingsViewController
		}
		
		/// Fetch privacy settgins view controller.
		public static func fetchAccountManagementViewController() -> AccountManagementViewController {
			return myPageStoryboard.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyPageStoryboard.accountManagementView) as! AccountManagementViewController
		}
	}
}
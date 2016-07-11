//
//  ColorgyUserInformation.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import KeychainSwift

// MARK: - Keys
private struct LoginResultKeys {
	static let created_at = "LoginResultKeys created_at"
	static let scope = "LoginResultKeys scope"
	static let token_type = "LoginResultKeys token_type"
	static let access_token = "LoginResultKeys access_token"
	static let expires_in = "LoginResultKeys expires_in"
	static let refresh_token = "LoginResultKeys refresh_token"
	static let createdDate = "LoginResultKeys createdDate"
}

private struct APIMeResultKeys {
	static let userType = "APIMeResultKeys userType"
	static let userAvatarUrl = "APIMeResultKeys userAvatarUrl"
	static let userCoverPhotoUrl = "APIMeResultKeys userCoverPhotoUrl"
	static let userId = "APIMeResultKeys userId"
	static let userName = "APIMeResultKeys userName"
	static let userAccountName = "APIMeResultKeys userAccountName"
	static let userUUID = "APIMeResultKeys userUUID"
	static let userDepartment = "APIMeResultKeys userDepartment"
	static let userOrganization = "APIMeResultKeys userOrganization"
	static let userUnconfirmedDepartment = "APIMeResultKeys userUnconfirmedDepartment"
	static let userUnconfirmedOrganization = "APIMeResultKeys userUnconfirmedOrganization"
	static let userEmail = "APIMeResultKeys userEmail"
	static let userFBEmail = "APIMeResultKeys userFBEmail"
	static let userMobile = "APIMeResultKeys userMobile"
	static let userUnconfirmedMobile = "APIMeResultKeys userUnconfirmedMobile"
}

private struct UserSettingKeys {
	static let deviceUUIDForPushNotificationKey = "UserSettingKeys deviceUUIDForPushNotificationKey"
	static let devicePushNotificationTokenKey = "UserSettingKeys devicePushNotificationTokenKey"
}

// MARK: - Class
final public class ColorgyUserInformation {
	
	/// Singleton of ColorgyUserInformation
	public class func sharedInstance() -> ColorgyUserInformation {
		
		struct Static {
			static let instance: ColorgyUserInformation = ColorgyUserInformation()
		}
		
		return Static.instance
	}
	
	// MARK: - Save & Delete Region
	
	// MARK: save/delete Login Result
	
	public class func saveLoginResult(result: ColorgyLoginResult) {
		let ud = NSUserDefaults.standardUserDefaults()
		let keychain = KeychainSwift()
		ud.setObject(result.created_at, forKey: LoginResultKeys.created_at)
		ud.setObject(result.scope, forKey: LoginResultKeys.scope)
		ud.setObject(result.token_type, forKey: LoginResultKeys.token_type)
		keychain.set(result.access_token, forKey: LoginResultKeys.access_token)
		ud.setObject(result.expires_in, forKey: LoginResultKeys.expires_in)
		keychain.set(result.refresh_token, forKey: LoginResultKeys.refresh_token)
		ud.setObject(result.createdDate, forKey: LoginResultKeys.createdDate)
		ud.synchronize()
	}
	
	public class func deleteLoginResult() {
		let ud = NSUserDefaults.standardUserDefaults()
		let keychain = KeychainSwift()
		ud.removeObjectForKey(LoginResultKeys.created_at)
		ud.removeObjectForKey(LoginResultKeys.scope)
		ud.removeObjectForKey(LoginResultKeys.token_type)
		keychain.delete(LoginResultKeys.access_token)
		ud.removeObjectForKey(LoginResultKeys.expires_in)
		keychain.delete(LoginResultKeys.refresh_token)
		ud.removeObjectForKey(LoginResultKeys.createdDate)
		ud.synchronize()
	}
	
	// MARK: Save/Delete API Me Result
	
	public class func saveAPIMeResult(result: ColorgyAPIMeResult) {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.setObject(result._type, forKey: APIMeResultKeys.userType)
		ud.setObject(result.avatar_url, forKey: APIMeResultKeys.userAvatarUrl)
		ud.setObject(result.cover_photo_url, forKey: APIMeResultKeys.userCoverPhotoUrl)
		ud.setObject(result.id, forKey: APIMeResultKeys.userId)
		ud.setObject(result.name, forKey: APIMeResultKeys.userName)
		ud.setObject(result.username, forKey: APIMeResultKeys.userAccountName)
		ud.setObject(result.uuid, forKey: APIMeResultKeys.userUUID)
		ud.setObject(result.department, forKey: APIMeResultKeys.userDepartment)
		ud.setObject(result.organization, forKey: APIMeResultKeys.userOrganization)
		ud.setObject(result.unconfirmed_department_code, forKey: APIMeResultKeys.userUnconfirmedDepartment)
		ud.setObject(result.unconfirmed_organization_code, forKey: APIMeResultKeys.userUnconfirmedOrganization)
		ud.setObject(result.email, forKey: APIMeResultKeys.userEmail)
		ud.setObject(result.fbemail, forKey: APIMeResultKeys.userFBEmail)
		ud.setObject(result.mobile, forKey: APIMeResultKeys.userMobile)
		ud.setObject(result.unconfirmedMobile, forKey: APIMeResultKeys.userUnconfirmedMobile)
		ud.synchronize()
	}
	
	public class func deleteAPIMeResult() {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.removeObjectForKey(APIMeResultKeys.userType)
		ud.removeObjectForKey(APIMeResultKeys.userAvatarUrl)
		ud.removeObjectForKey(APIMeResultKeys.userCoverPhotoUrl)
		ud.removeObjectForKey(APIMeResultKeys.userId)
		ud.removeObjectForKey(APIMeResultKeys.userName)
		ud.removeObjectForKey(APIMeResultKeys.userAccountName)
		ud.removeObjectForKey(APIMeResultKeys.userUUID)
		ud.removeObjectForKey(APIMeResultKeys.userDepartment)
		ud.removeObjectForKey(APIMeResultKeys.userOrganization)
		ud.removeObjectForKey(APIMeResultKeys.userUnconfirmedDepartment)
		ud.removeObjectForKey(APIMeResultKeys.userUnconfirmedOrganization)
		ud.removeObjectForKey(APIMeResultKeys.userEmail)
		ud.removeObjectForKey(APIMeResultKeys.userFBEmail)
		ud.synchronize()
	}
	
	// MARK: - Push Notification
	
	// MARK: Push Notification UUID 
	
	/// Generate a unique device uuid,
	/// If fail to generate, will return false
	/// 
	/// Will generate only if user has required data:
	///		- User name
	///
	/// Will store this uuid for further usage.
	///
	/// - returns: generate state
	public class func generateDeviceUUID() -> Bool {
		let ud = NSUserDefaults.standardUserDefaults()
		
		// User name is required
		guard let username = ColorgyUserInformation.sharedInstance().userName else { return false }
		
		// Already has a uuid, no need to generate
		guard ColorgyUserInformation.sharedInstance().deviceUUID == nil else { return true }
		
		// generate random uuid
		let randomUUID = NSUUID().UUIDString
		// get current device name
		let deviceName = UIDevice.currentDevice().name
		
		// Create a device uuid string
		let deviceUUID = "\(username.uuidEncode)-\(deviceName.uuidEncode)-\(randomUUID)"
		
		// store it
		ud.setObject(deviceUUID, forKey: UserSettingKeys.deviceUUIDForPushNotificationKey)
		ud.synchronize()
		
		return true
	}
	
	public var deviceUUID: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(UserSettingKeys.deviceUUIDForPushNotificationKey) as? String
	}
	
	// MARK: Current Device Push Notification Token
	
	/// Store current device push notification token
	public class func storePushNotificationToken(token: NSData) {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.setObject(token, forKey: UserSettingKeys.devicePushNotificationTokenKey)
		ud.synchronize()
	}
	
	/// get current device push notification token
	public var pushNotificationToken: NSData? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(UserSettingKeys.devicePushNotificationTokenKey) as? NSData
	}
	
	// MARK: - Getters
	
	// MARK: Token
	
	public var userAccessToken: String? {
		let keychain = KeychainSwift()
		return keychain.get(LoginResultKeys.access_token)
	}
	
	public var userRefreshToken: String? {
		let keychain = KeychainSwift()
		return keychain.get(LoginResultKeys.refresh_token)
	}
	
	// MARK: date since token created
	public var tokenCreatedDate: NSDate? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(LoginResultKeys.createdDate) as? NSDate
	}
	
	// MARK: Getter of User Information
	public var userOrganization: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userOrganization) as? String
	}
	
	public var userUnconfirmedOrganization: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userUnconfirmedOrganization) as? String
	}
	
	/// Get user's actual organization
	/// 
	/// Organization **>** Possible Organization
	///
	/// If neither existed, will be nil
	public var userActualOrganization: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		let organization = ud.objectForKey(APIMeResultKeys.userOrganization) as? String
		let unconfirmedOrganization = ud.objectForKey(APIMeResultKeys.userUnconfirmedOrganization) as? String
		return organization ?? unconfirmedOrganization ?? nil
	}
	
	public var userName : String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userName) as? String
	}
	
	public var userId: Int? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userId) as? Int
	}
	
	public var userUUID: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userUUID) as? String
	}
	
	// MARK: - Mobile
	public var userMobile: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userMobile) as? String
	}
	
	public var userUnconfirmedMobile: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(APIMeResultKeys.userUnconfirmedMobile) as? String
	}
	
	// MARK: - Clear
	public func clearUserDefaults() {
		let ud = NSUserDefaults.standardUserDefaults()
		let keys = ud.dictionaryRepresentation().keys
		keys.forEach({ ud.removeObjectForKey($0) })
		ud.synchronize()
	}
}
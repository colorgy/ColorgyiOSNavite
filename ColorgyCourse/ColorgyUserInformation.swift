//
//  ColorgyUserInformation.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

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
	static let userPossibleDepartment = "APIMeResultKeys userPossibleDepartment"
	static let userPossibleOrganization = "APIMeResultKeys userPossibleOrganization"
	static let userEmail = "APIMeResultKeys userEmail"
	static let userFBEmail = "APIMeResultKeys userFBEmail"
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
		ud.setObject(result.created_at, forKey: LoginResultKeys.created_at)
		ud.setObject(result.scope, forKey: LoginResultKeys.scope)
		ud.setObject(result.token_type, forKey: LoginResultKeys.token_type)
		ud.setObject(result.access_token, forKey: LoginResultKeys.access_token)
		ud.setObject(result.expires_in, forKey: LoginResultKeys.expires_in)
		ud.setObject(result.refresh_token, forKey: LoginResultKeys.refresh_token)
		ud.setObject(result.createdDate, forKey: LoginResultKeys.createdDate)
		ud.synchronize()
	}
	
	public class func deleteLoginResult() {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.removeObjectForKey(LoginResultKeys.created_at)
		ud.removeObjectForKey(LoginResultKeys.scope)
		ud.removeObjectForKey(LoginResultKeys.token_type)
		ud.removeObjectForKey(LoginResultKeys.access_token)
		ud.removeObjectForKey(LoginResultKeys.expires_in)
		ud.removeObjectForKey(LoginResultKeys.refresh_token)
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
		ud.setObject(result.possible_department_code, forKey: APIMeResultKeys.userPossibleDepartment)
		ud.setObject(result.possible_organization_code, forKey: APIMeResultKeys.userPossibleOrganization)
		ud.setObject(result.email, forKey: APIMeResultKeys.userEmail)
		ud.setObject(result.fbemail, forKey: APIMeResultKeys.userFBEmail)
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
		ud.removeObjectForKey(APIMeResultKeys.userPossibleDepartment)
		ud.removeObjectForKey(APIMeResultKeys.userPossibleOrganization)
		ud.removeObjectForKey(APIMeResultKeys.userEmail)
		ud.removeObjectForKey(APIMeResultKeys.userFBEmail)
		ud.synchronize()
	}
	
	// MARK: - Getters
	// MARK: Token
	public var userAccessToken: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(LoginResultKeys.access_token) as? String
	}
	
	public var userRefreshToken: String? {
		let ud = NSUserDefaults.standardUserDefaults()
		return ud.objectForKey(LoginResultKeys.refresh_token) as? String
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
}
//
//  ColorgyLoginResult.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

// this is use to get key of the object/dictionary properly
public struct OAuthKey {
	static let created_at = "created_at"
	static let scope = "scope"
	static let token_type = "token_type"
	static let access_token = "access_token"
	static let expires_in = "expires_in"
	static let refresh_token = "refresh_token"
}

/// A result from Colorgy OAuth server.
final public class ColorgyLoginResult : NSObject {
	var created_at: Int
	var scope: String
	var token_type: String
	var access_token: String
	var expires_in: Int
	var refresh_token: String
	var createdDate: NSDate
	
	override public var description: String { return "{\n\tcreated_at => \(created_at)\n\tscope => \(scope)\n\ttoken_type => \(token_type)\n\taccess_token => \(access_token)\n\texpires_in => \(expires_in)\n\trefresh_token => \(refresh_token)\n\tcreatedDate => \(createdDate)\n}" }
	
	/// Initialization: Pass in json, then will generate a ColorgyLoginResult
	///
	/// You can simply store this to **UserSetting.storeLoginResult**
	convenience init?(json: JSON) {
		
		var _created_at: Int?
		var _scope: String?
		var _token_type: String?
		var _access_token: String?
		var _expires_in: Int?
		var _refresh_token: String?
		
		_created_at = json[OAuthKey.created_at].int
		_scope = json[OAuthKey.scope].string
		_token_type = json[OAuthKey.token_type].string
		_access_token = json[OAuthKey.access_token].string
		_expires_in = json[OAuthKey.expires_in].int
		_refresh_token = json[OAuthKey.refresh_token].string
		
		self.init(created_at: _created_at, scope: _scope, token_type: _token_type, access_token: _access_token, refresh_token: _refresh_token, expires_in: _expires_in)
	}
	
	 private init?(created_at: Int?, scope: String?, token_type: String?, access_token: String?, refresh_token: String?, expires_in: Int?) {
		self.created_at = Int()
		self.scope = String()
		self.token_type = String()
		self.access_token = String()
		self.expires_in = Int()
		self.refresh_token = String()
		self.createdDate = NSDate()
		
		super.init()
		
		guard created_at != nil else { return nil }
		guard scope != nil else { return nil }
		guard token_type != nil else { return nil }
		guard access_token != nil else { return nil }
		guard expires_in != nil else { return nil }
		guard refresh_token != nil else { return nil }
		
		self.created_at = created_at!
		self.scope = scope!
		self.token_type = token_type!
		self.access_token = access_token!
		self.expires_in = expires_in!
		self.refresh_token = refresh_token!
	}
}
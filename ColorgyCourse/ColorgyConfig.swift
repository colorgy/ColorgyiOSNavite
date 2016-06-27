//
//  ColorgyConfig.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

/// This is for server settings.
/// Store server url, client id, client secret and so on here.
public struct ColorgyConfig {
	/// Server url, now is at "http://staging.colorgy.io"
	/// Need to change when in production mode.
	static let serverURL: String = "http://staging.colorgy.io"
	/// Colorgy app id.
	static let clientID: String = "3e1f5097e78ff964223903a3c9da891df61917e950feada039ae81f99c8f8aef"
	/// Colorgy app secret.
	static let clientSecret: String = "18ba15c6579584545b6947749b80ccf2922aca97eefa501236ee36e5b49bdd71"
}
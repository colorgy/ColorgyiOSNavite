//
//  ColorgyAppNotification.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

/// All notification colorgy will sent are listed here.
/// Notification maybe things like token revoke, get hello, get new message or something.
struct ColorgyAppNotification {
	static let RefreshTokenRevokedNotification = "ColorgyAppNotification RefreshTokenRevokedNotification"
	static let MessageRecievedNotification = "ColorgyAppNotification MessageRecievedNotification"
	static let HelloRecievedNotification = "ColorgyAppNotification HelloRecievedNotification"
	static let NewVersionAppReleased = "ColorgyAppNotification NewVersionAppReleased"
}
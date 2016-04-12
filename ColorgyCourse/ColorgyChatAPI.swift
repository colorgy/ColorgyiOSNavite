//
//  ColorgyChatAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFNetworking

public protocol ColorgyChatAPIDelegate: class {
	<#requirements#>
}

final public class ColorgyChatAPI: NSObject {
	
	private static let serverURL = "http://chat.colorgy.io"
	
	// MARK: - Parameters
	public let manager: AFHTTPSessionManager
	private var pointer: UnsafeMutablePointer<Void> = nil
	public weak var delegate: ColorgyChatAPIDelegate?
	
	// MARK: - Init
	public override init() {
		manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		super.init()
		manager.operationQueue.addObserver(self, forKeyPath: "operationCount", options: [], context: pointer)
	}

	// MARK: - Helper
	/// private access token getter
	private var accessToken: String? {
		get {
			return ColorgyRefreshCenter.sharedInstance().accessToken
		}
	}
	
	// MARK: - Methods
	
	///上傳聊天室照片：
	///
	///用途：單純一個end-point以供照片上傳
	///使用方式：
	///
	///1. 傳一個http post給/upload/upload_chat_image，將圖片檔案放在file這個參數內
	///2. 伺服器會回傳圖片位置到result這個參數內
	
	
	
	
	
	
	
	
	
	
}
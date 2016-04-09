//
//  Release.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class Release: NSObject {
	#if DEBUG
		public static let mode = false
	#else
		public static let mode = true
	#endif
}
//
//  DLMessageData.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/19.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DLMessageData: NSObject {
    
    var userId: String
    var userImage: UIImage?
    var message: String?
    
    init(userId: String, userImage: UIImage?, message: String?) {
        self.userId = userId
        self.userImage = userImage
        self.message = message
    }
}

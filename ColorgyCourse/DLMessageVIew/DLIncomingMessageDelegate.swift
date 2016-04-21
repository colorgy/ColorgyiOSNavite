//
//  DLIncomingMessageDelegate.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

protocol DLMessageDelegate {
	func DLMessage(didTapOnUserImageView image: UIImage?, message: ChatMessage)
	func DLMessage(didTapOnSentImageView imageView: UIImageView?)
}
//
//  FriendListTableViewCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userProfileImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userQuestionLabel: UILabel!
	@IBOutlet weak var userLastMessageLabel: UILabel!
	@IBOutlet weak var timeStampLabel: UILabel!
	
	var historyChatroom: HistoryChatroom! {
		didSet {
			if historyChatroom != nil {
				updateUI()
			}
		}
	}
	
	func updateUI() {
		if historyChatroom.image.isValidURLString {
			
			if historyChatroom.chatProgress >= 100 {
				// can show photo
				userProfileImageView.sd_setImageWithURL(historyChatroom.image.url)
			} else {
				userProfileImageView.sd_setImageWithURL(historyChatroom.blurImage.url)
			}
			
			//			let percentage = self.historyChatroom.chatProgress
			//			var radius: CGFloat = 0.0
			//			radius = (33 - CGFloat(percentage < 98 ? percentage : 98) % 33) / 33.0 * 4.0
			//			userProfileImageView.sd_setImageWithURL(historyChatroom.image.url, blurPercantage: radius)
			
			//			let sc = SDImageCache()
			//			let imageFromCache = sc.imageFromDiskCacheForKey(self.historyChatroom.image)
			//
			//			if imageFromCache == nil  {
			//				// load image if its nil
			//				UIImageView().sd_setImageWithURL(historyChatroom.image.url, completed: { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, url: NSURL!) -> Void in
			//					self.updateUI()
			//				})
			//			} else {
			//				let percentage = self.historyChatroom.chatProgress
			//				let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
			//				dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
			//					var radius: CGFloat = 0.0
			//					radius = (33 - CGFloat(percentage < 98 ? percentage : 98) % 33) / 33.0 * 4.0
			//					print(radius)
			//					let blurImage = UIImage().gaussianBlurImage(imageFromCache, andInputRadius: radius)
			//					dispatch_async(dispatch_get_main_queue(), { () -> Void in
			//						self.userProfileImageView.image = blurImage
			//					})
			//				})
			//			}
		}
		userNameLabel.text = (historyChatroom.name != "" ? historyChatroom.name : " ")
		userQuestionLabel.text = " "
		let prefixString = (ColorgyChatContext.sharedInstance().userId == historyChatroom.lastSpeaker ? "你：" : "")
		let lastMessage = (historyChatroom.lastContent != "" ? historyChatroom.lastContent : " ") ?? " "
		userLastMessageLabel.text = prefixString + lastMessage
		timeStampLabel.text = historyChatroom.lastContentTime.timeStampString()
		userQuestionLabel.text = historyChatroom.lastAnswer
		//		if historyChatroom.unread {
		//			userLastMessageLabel.font = UIFont.boldSystemFontOfSize(14.0)
		//			userLastMessageLabel.textColor = UIColor.blackColor()
		//		} else {
		//			userLastMessageLabel.font = UIFont.systemFontOfSize(14.0)
		//			userLastMessageLabel.textColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
		//		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		userProfileImageView.clipsToBounds = true
		userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
		userProfileImageView.image = nil
		
		let separatorLine = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5))
		separatorLine.backgroundColor = UIColor.lightGrayColor()
		separatorLine.frame.origin.y = self.frame.height - 0.5
		separatorLine.alpha = 0.8
		self.addSubview(separatorLine)
		
		self.selectionStyle = .None
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

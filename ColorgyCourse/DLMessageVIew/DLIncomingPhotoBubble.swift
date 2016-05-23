//
//  DLIncomingPhotoBubble.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DLIncomingPhotoBubble: UITableViewCell {
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var contentImageView: UIImageView!
	
	var delegate: DLMessageDelegate?
	var message: ChatMessage! {
		didSet {
			if message.content.isValidURLString {
				self.contentImageView.sd_setImageWithURL(message.content.url, placeholderImage: nil)
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		userImageView.layer.cornerRadius = userImageView.bounds.width / 2
		userImageView.clipsToBounds = true
		userImageView.contentMode = .ScaleAspectFill
		
		userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnUserImageView)))
		
		contentImageView.layer.cornerRadius = 10.0
		contentImageView.clipsToBounds = true
		contentImageView.contentMode = .ScaleAspectFill
		userImageView.backgroundColor = UIColor.lightGrayColor()
		
		contentImageView.backgroundColor = UIColor.lightGrayColor()
		userImageView.userInteractionEnabled = true
		
		contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnImageView)))
		contentImageView.userInteractionEnabled = true
		
		self.selectionStyle = .None
    }
	
	func tapOnUserImageView() {
		print("tapOnUserImageView")
		delegate?.DLMessage(didTapOnUserImageView: userImageView.image, message: message)
	}
	
	func tapOnImageView() {
		delegate?.DLMessage(didTapOnSentImageView: contentImageView)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

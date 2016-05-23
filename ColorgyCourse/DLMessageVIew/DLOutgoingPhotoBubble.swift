//
//  DLOutgoingPhotoBubble.swift
//  ColorgyCourse
//
//  Created by David on 2016/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import SDWebImage

class DLOutgoingPhotoBubble: UITableViewCell {
	
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
		contentImageView.layer.cornerRadius = 10.0
		contentImageView.clipsToBounds = true
		contentImageView.contentMode = .ScaleAspectFill
		contentImageView.backgroundColor = UIColor.lightGrayColor()
		
		contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnImageView)))
		contentImageView.userInteractionEnabled = true
		
		self.selectionStyle = .None
    }
	
	func tapOnImageView() {
		delegate?.DLMessage(didTapOnSentImageView: contentImageView)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

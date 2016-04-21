//
//  DLIncomingMessageBubble.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/19.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DLIncomingMessageBubble: UITableViewCell {
    
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
	
	var delegate: DLMessageDelegate?
	var message: ChatMessage! {
		didSet {
			self.textlabel.text = message.content
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textlabel.layer.cornerRadius = 10.0
        textlabel.layer.borderColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1).CGColor
        textlabel.layer.borderWidth = 1.0
//        textlabel.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        print(textlabel.frame)
        textlabel.font = UIFont.systemFontOfSize(16.0)
        textlabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.clipsToBounds = true
        userImageView.contentMode = .ScaleAspectFill
		userImageView.backgroundColor = UIColor.lightGrayColor()
		
		userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnUserImageView)))
		userImageView.userInteractionEnabled = true
        
        self.selectionStyle = .None
    }
	
	func tapOnUserImageView() {
		print("tapOnUserImageView")
		delegate?.DLMessage(didTapOnUserImageView: userImageView.image, message: message)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

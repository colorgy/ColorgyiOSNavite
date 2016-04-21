//
//  DLOutgoingMessageBubble.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/19.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DLOutgoingMessageBubble: UITableViewCell {
    
    @IBOutlet weak var textlabel: UILabel!
	var message: ChatMessage! {
		didSet {
			self.textlabel.text = message.content
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textlabel.layer.cornerRadius = 10.0
        textlabel.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9).CGColor
        textlabel.layer.borderWidth = 1.0
        //        textlabel.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        print(textlabel.frame)
        textlabel.font = UIFont.systemFontOfSize(16.0)
        textlabel.backgroundColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9)
        textlabel.textColor = UIColor.whiteColor()
        textlabel.clipsToBounds = true
        
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

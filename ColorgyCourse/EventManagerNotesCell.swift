//
//  EventManagerNotesCell.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class EventManagerNotesCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentTextView: UITextView!
	
	@IBOutlet weak var upperSeperatorLine: UIView!
	@IBOutlet weak var bottomSeperatorLine: UIView!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		titleLabel.textColor = ColorgyColor.grayContentTextColor
		titleLabel.text = "備註"
		
		contentTextView.delegate = self
		contentTextView.textColor = ColorgyColor.grayContentTextColor
		contentTextView.text = "寫下一點東西吧！"
		
		selectionStyle = .None
		
		upperSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
		bottomSeperatorLine.backgroundColor = ColorgyColor.BackgroundColor
    }

}

extension EventManagerNotesCell : UITextViewDelegate {
	
	public func textViewDidBeginEditing(textView: UITextView) {
		if textView.textColor == ColorgyColor.grayContentTextColor {
			// clear placeholder, change text color
			textView.textColor = ColorgyColor.TextColor
			textView.text = ""
		}
	}
	
	public func textViewDidEndEditing(textView: UITextView) {
		if textView.textColor == ColorgyColor.TextColor {
			if textView.text == nil || textView.text == "" {
				// no input, set plcaeholder
				textView.textColor = ColorgyColor.grayContentTextColor
				textView.text = "寫下一點東西吧！"
			}
		}
	}
}
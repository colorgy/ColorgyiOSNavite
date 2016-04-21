//
//  TextInputView.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class TextInputView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
	
	private var cameraButton: UIButton!
	private let cameraButtonSize: CGSize = CGSize(width: 30, height: 24)
    private var sendMessageButton: UIButton!
    private let sendMessageButtonSize: CGSize = CGSize(width: 61, height: 30)
    private var messageTextView: UITextView!
    var messageTextViewPlaceholder: String = "來點訊息吧..." {
        didSet {
            if messageTextView.text.isEmpty {
                if messageTextView.textColor == UIColor.grayColor() {
                    messageTextView.text = messageTextViewPlaceholder
                }
            }
        }
    }
    private let leftInset: CGFloat = 8
    private let sendButtonAndMessageTextViewGap: CGFloat = 4.0
    private var messageTextViewWidth: CGFloat {
        get {
            if sendMessageButton.hidden {
                return UIScreen.mainScreen().bounds.width - 2 * leftInset
            } else {
                return UIScreen.mainScreen().bounds.width - 2 * leftInset - sendMessageButton.bounds.width
            }
        }
    }
    private var currentMessageTextViewContentHeight: CGFloat! = 36.0 {
        didSet {
            if currentMessageTextViewContentHeight <= maxMessgeBarHeight {
                currentMessageBarHeight = currentMessageTextViewContentHeight + 8
                // update the view
                updateAlign()
                // tell the delegate that i am updating
                delegate?.textInputView(didUpdateFrame: self)
            }
            //            print("current message bar h")
            //            print(currentMessageBarHeight)
        }
    }
    private let initialMessageTextViewHeight: CGFloat = 36.0
    private var currentMessageBarHeight: CGFloat = 44.0
    private let initialBarHeight: CGFloat = 44.0
    var maxMessgeBarHeight: CGFloat = 120.0
    private var minMessageBarHeight: CGFloat = 44.0
    
    var delegate: TextInputViewDelegate?
    
    convenience init() {
        self.init(frame: CGRectZero)
        self.frame = UIScreen.mainScreen().bounds
        self.frame.size.height = initialBarHeight
        self.backgroundColor = UIColor.whiteColor()
        
        sendMessageButton = UIButton(type: UIButtonType.System)
        sendMessageButton.frame = CGRectZero
        sendMessageButton.frame.size = sendMessageButtonSize
        sendMessageButton.setTitle("傳送", forState: UIControlState.Normal)
        sendMessageButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        sendMessageButton.contentHorizontalAlignment = .Center
        sendMessageButton.contentVerticalAlignment = .Center
        sendMessageButton.tintColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9)
        sendMessageButton.layer.cornerRadius = 2.0
        sendMessageButton.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9).CGColor
        sendMessageButton.layer.borderWidth = 1.0
//        sendMessageButton.backgroundColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9)
		sendMessageButton.addTarget(self, action: #selector(sendMessageButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(sendMessageButton)
		
		// camera button
		cameraButton = UIButton(type: UIButtonType.System)
		cameraButton.frame.origin.x = leftInset
		cameraButton.frame.size = cameraButtonSize
		cameraButton.setImage(UIImage(named: "CameraButton"), forState: UIControlState.Normal)
		cameraButton.addTarget(self, action: #selector(openCameraButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
		cameraButton.tintColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9)
		self.addSubview(cameraButton)
        
        messageTextView = UITextView(frame: self.frame)
        messageTextView.frame.size.width -= 2 * leftInset + sendButtonAndMessageTextViewGap
        messageTextView.frame.origin.x += leftInset + cameraButton.frame.maxX
        messageTextView.frame.size.width -= sendMessageButtonSize.width
		messageTextView.frame.size.width -= cameraButtonSize.width + leftInset
        messageTextView.frame.size.height = initialMessageTextViewHeight
        messageTextView.center.y = self.bounds.midY
        messageTextView.textAlignment = .Natural
        messageTextView.bounces = false
        //        print(messageTextView.contentSize)
        //        print(messageTextView.frame)
        messageTextView.backgroundColor = UIColor.clearColor()
        //        messageTextView.layer.borderWidth = 2.0
        //        messageTextView.layer.borderColor = UIColor.blackColor().CGColor
        messageTextView.font = UIFont.systemFontOfSize(16)
        messageTextView.delegate = self
        //        print(messageTextView.contentSize)
        messageTextView.textColor = UIColor.lightGrayColor()
        messageTextView.text = messageTextViewPlaceholder
//        messageTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        messageTextView.layer.borderWidth = 1.0
        self.addSubview(messageTextView)
        
        sendMessageButton.frame.origin.x = messageTextView.frame.maxX + sendButtonAndMessageTextViewGap
        sendMessageButton.center.y = messageTextView.center.y
        cameraButton.center.y = messageTextView.center.y
		
        let a = ATrickyView()
        a.delegate = self
        messageTextView.inputAccessoryView = a
        messageTextView.sendSubviewToBack(a)
        
        // make self view has a orange bar on top of it
        let orangeBarView = UIView(frame: UIScreen.mainScreen().bounds)
        orangeBarView.frame.size.height = 1
        orangeBarView.backgroundColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9)
        self.addSubview(orangeBarView)
        
        disableSendMessageButton()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAlign() {
        
        UIView.animateWithDuration(0.2) { () -> Void in
            // first, get the offset that you are going to animate
            // this is the change of the self.frame.height size
            let offset = self.frame.size.height - (self.currentMessageTextViewContentHeight + 8)
            // expand the size of the frame
            self.frame.size.height = self.currentMessageTextViewContentHeight + 8
            // move frame position
            self.frame.origin.y += offset
            // move the sendMessageButton y postion
            self.sendMessageButton.center.y = self.frame.height - self.initialBarHeight / 2
            // expand the messageTextview size
            self.messageTextView.frame.size.height = self.currentMessageTextViewContentHeight
            // move it
            self.messageTextView.center.y = self.bounds.midY
			// move camera
			self.cameraButton.center.y = self.sendMessageButton.center.y
        }
        
        if let a = messageTextView.inputAccessoryView as? ATrickyView {
            // tell keyboard that this bar height has changed
            a.barHeight = self.currentMessageBarHeight
        }
    }
    
    internal func sendMessageButtonClicked() {
        if self.messageTextView.textColor != UIColor.lightGrayColor() {
            let trimmedString: NSString = messageTextView.text
            delegate?.textInputView(didClickedSendMessageButton: trimmedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            self.messageTextView.text = ""
            self.currentMessageTextViewContentHeight = initialMessageTextViewHeight
            disableSendMessageButton()
        }
    }
	
	internal func openCameraButtonClicked() {
		print("openCameraButtonClicked")
		delegate?.textInputViewDidClickCameraButton()
	}
    
    private func disableSendMessageButton() {
        
        //        let t1 = CGAffineTransformMakeScale(0.1, 1)
        //        let t2 = CGAffineTransformMakeTranslation(self.sendMessageButton.bounds.midX, 0)
        //        let trans = CGAffineTransformConcat(t1, t2)
        //
        //        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
        //            self.sendMessageButton.transform = trans
        //            self.messageTextView.frame.size.width = UIScreen.mainScreen().bounds.width - 2 * self.leftInset
        //            }) { (finished) -> Void in
        //                if finished {
        //                    self.sendMessageButton.hidden = true
        //
        //                }
        //        }
        
        self.sendMessageButton.enabled = false
        self.sendMessageButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        self.sendMessageButton.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    private func enableSendMessageButton() {
        //        self.sendMessageButton.hidden = false
        //        UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
        ////            self.sendMessageButton.transform = CGAffineTransformMakeScale(1, 1)
        //            self.sendMessageButton.transform = CGAffineTransformIdentity
        //            self.messageTextView.frame.size.width = UIScreen.mainScreen().bounds.width - 2 * self.leftInset - self.sendMessageButton.bounds.width
        //            }, completion: nil)
        
        self.sendMessageButton.enabled = true
        self.sendMessageButton.setTitleColor(self.sendMessageButton.tintColor, forState: UIControlState.Normal)
        self.sendMessageButton.layer.borderColor = UIColor(red: 248/255.0, green: 150/255.0, blue: 128/255.0, alpha: 0.9).CGColor
    }
}

extension TextInputView : UITextViewDelegate {
    func textViewDidChange(messageTextView: UITextView) {
        if messageTextView.contentSize.height >= self.currentMessageTextViewContentHeight {
            self.currentMessageTextViewContentHeight = messageTextView.contentSize.height
        } else {
            // smaller size
            self.currentMessageTextViewContentHeight = messageTextView.contentSize.height
        }
        // detect text change
        
        if messageTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
            disableSendMessageButton()
        } else {
            enableSendMessageButton()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.textColor = UIColor.blackColor()
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = messageTextViewPlaceholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}

protocol TextInputViewDelegate {
    func textInputView(didUpdateKeyboardFrame kbRect: CGRect?, textInputView :TextInputView)
    func textInputView(didUpdateFrame textInputView: TextInputView)
    func textInputView(didClickedSendMessageButton message: String?)
	func textInputViewDidClickCameraButton()
}

extension TextInputView : ATrickyViewDelegate {
    func aTrickyViewDelegate(currentKeyboardRect keyboardRect: CGRect?) {
        delegate?.textInputView(didUpdateKeyboardFrame: keyboardRect, textInputView: self)
    }
}

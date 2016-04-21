//
//  DLMessagesViewController.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

struct DLMessageControllerIdentifier {
    static let DLIncomingMessageBubbleIdentifier = "DLIncomingMessageBubble"
    static let DLOutgoingMessageBubbleIdentifier = "DLOutgoingMessageBubble"
	
	static let DLIncomingPhotoBubbleIdentifier = "DLIncomingPhotoBubble"
	static let DLOutgoingPhotoBubbleIdentifier = "DLOutgoingPhotoBubble"
}

protocol DLMessagesViewControllerDelegate {
    func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?)
	func DLMessagesViewControllerDidClickedCameraButton()
	func DLMessagesViewControllerDidTapOnBubbleTableView()
}

class DLMessagesViewController: UIViewController {
    
    var bubbleTableView: UITableView!
    var keyboardTextInputView: TextInputView!
    var kbHeight: CGFloat! = 0.0
    var keyboardAndMessageGap: CGFloat = 8.0
    
    var delegate: DLMessagesViewControllerDelegate?
	
	// tap to dismiss keyboard
	var tapToDismissKeyboard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
		automaticallyAdjustsScrollViewInsets = false
		
        registerForNibs()
		
		configureKeyboardTextInputView()
		
		configureBubbleTableView()
    }
	
	private func registerForNibs() {
		bubbleTableView = UITableView(frame: UIScreen.mainScreen().bounds)
		self.view.addSubview(bubbleTableView)
		bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier)
		bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier)
		bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier)
		bubbleTableView.registerNib(UINib(nibName: DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, bundle: nil), forCellReuseIdentifier: DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier)
	}
	
	private func configureBubbleTableView() {
		bubbleTableView.delegate = self
		bubbleTableView.dataSource = self
		
		bubbleTableView.estimatedRowHeight = 197
		bubbleTableView.rowHeight = UITableViewAutomaticDimension
		
		bubbleTableView.keyboardDismissMode = .Interactive
		
		bubbleTableView.separatorStyle = .None
		
		bubbleTableView.scrollsToTop = false
		
		// adjust inset
		bubbleTableView.contentInset.bottom = keyboardAndMessageGap + keyboardTextInputView.bounds.height
		
		// check if there is a navigation controller on it
		if navigationController != nil {
			print("there is a navi")
			bubbleTableView.contentInset.top = navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
		}
		// customize top inset
		bubbleTableView.contentInset.top += 10
		
		bubbleTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnBubbleTableView)))
	}
	
	private func configureKeyboardTextInputView() {
		keyboardTextInputView = TextInputView()
		keyboardTextInputView.frame.origin.y = UIScreen.mainScreen().bounds.maxY - keyboardTextInputView.bounds.height
		if UIApplication.sharedApplication().statusBarFrame.height == 40 {
			// move up 20
			keyboardTextInputView.frame.origin.y -= 20
		}
		keyboardTextInputView.delegate = self
		self.view.addSubview(keyboardTextInputView)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		registerForNotifications()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		unregisterNotifications()
	}
	
	private func registerForNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(frameWillChangeNotification), name: UIApplicationWillChangeStatusBarFrameNotification, object: nil)
		let kStatusBarTappedNotification = "statusBarTappedNotification"
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tapOnStatusBarNotification), name: kStatusBarTappedNotification, object: nil)
		registerKeyboardNotifications()
	}
	
	func registerKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIKeyboardWillShowNotification, object: nil)
	}
	
	func unregisterNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func tapOnStatusBarNotification(notification: NSNotification) {
		if bubbleTableView.numberOfRowsInSection(0) > 0 {
			bubbleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: true)
		}
	}
	
	func frameWillChangeNotification(notification: NSNotification) {
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		print("statusBarHeight \(statusBarHeight)")
		
		// check if there is a navi controller
		var topInset: CGFloat = 0
		if navigationController != nil {
			topInset = navigationController!.navigationBar.frame.height + 20
		} else {
			topInset = statusBarHeight
		}
		print("will change top inset \(topInset)")
		if statusBarHeight == 20 {
			UIView.animateWithDuration(0.35, animations: { () -> Void in
				self.keyboardTextInputView.frame.origin.y += 20
				self.bubbleTableView.contentInset.top = topInset
			})
		} else if statusBarHeight == 40 {
			UIView.animateWithDuration(0.35, animations: { () -> Void in
				self.keyboardTextInputView.frame.origin.y -= 20
				self.bubbleTableView.contentInset.top = topInset
			})
		}
	}
	
	/// Instantly close the keyboard
	func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	func keyboardWillHideNotification(notification: NSNotification) {
		let animationKey = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey])?.unsignedIntegerValue
		let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey])?.doubleValue
		
		var offset = UIScreen.mainScreen().bounds.height - keyboardTextInputView.bounds.height
		if UIApplication.sharedApplication().statusBarFrame.height == 40 {
			offset -= 20
		}
		
		UIView.animateKeyframesWithDuration(animationDuration!, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: animationKey!), animations: { () -> Void in
			self.keyboardTextInputView.frame.origin.y = offset
			}, completion: nil)
		
		let bottomInset = UIScreen.mainScreen().bounds.height - keyboardTextInputView.frame.origin.y + keyboardAndMessageGap
		bubbleTableView.contentInset.bottom = bottomInset
	}
	
	func keyboardWillShowNotification(n: NSNotification) {
		scrollToButtom(animated: false)
	}
	
	func tapOnBubbleTableView() {
		if tapToDismissKeyboard {
			delegate?.DLMessagesViewControllerDidTapOnBubbleTableView()
			dismissKeyboard()
		}
	}
    
    func scrollToButtom(animated animated: Bool) {
        let numbers = bubbleTableView.numberOfRowsInSection(0)
        let indexPath = NSIndexPath(forRow: numbers - 1, inSection: 0)
		if numbers >= 1 {
			bubbleTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
			print(bubbleTableView.contentSize.height)
		}
    }
    
//    func finishedSendingMessage() {
//		let rows = bubbleTableView.numberOfRowsInSection(0)
//		print("rows \(rows)")
//		// rows is always actul count
//		// pass in rows in inserting
//		let insertIndex = rows - 1
////		if insertIndex > 0 {
//			bubbleTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: insertIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
//			// rows here no need to -1
//			bubbleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: insertIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
////		}
//    }
	
	func messageRecieved() {
//		finishedSendingMessage()
		messageRecievedButDontReload()
		recievingABunchMessages()
	}
	
	func messageRecievedButDontReload() {
		let rows = bubbleTableView.numberOfRowsInSection(0)
//		print("rows \(rows)")
		// rows is always actul count
		// pass in rows in inserting
		bubbleTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: rows, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
//		print("after \(bubbleTableView.numberOfRowsInSection(0))")
	}
	
	func recievingABunchMessages() {
		let rows = bubbleTableView.numberOfRowsInSection(0) - 1
//		print("about to reload \(bubbleTableView.numberOfRowsInSection(0))")
		if rows >= 0 {
			bubbleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: rows, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
		}
	}
	
	func recieveMessageAndInsertAtFront() {
		bubbleTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
	}
}

extension DLMessagesViewController : TextInputViewDelegate {
    func textInputView(didUpdateKeyboardFrame kbRect: CGRect?, textInputView: TextInputView) {
        if let kbRect = kbRect {
            keyboardTextInputView.frame.origin.y = kbRect.origin.y - textInputView.frame.height
            kbHeight =  UIScreen.mainScreen().bounds.height - kbRect.origin.y
            // adjust inset
            let bottomInset = UIScreen.mainScreen().bounds.height - keyboardTextInputView.frame.origin.y + keyboardAndMessageGap
            bubbleTableView.contentInset.bottom = bottomInset
//            scrollToButtom(animated: false)
        }
    }
	
    func textInputView(didUpdateFrame textInputView: TextInputView) {
        
    }
	
    func textInputView(didClickedSendMessageButton message: String?) {
        delegate?.DLMessagesViewControllerDidClickedMessageButton(withReturnMessage: message)
    }
	
	func textInputViewDidClickCameraButton() {
		delegate?.DLMessagesViewControllerDidClickedCameraButton()
	}
}

extension DLMessagesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
        
        return cell
    }
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		
	}
}

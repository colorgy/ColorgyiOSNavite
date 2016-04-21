//
//  ChatRoomViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import Photos
import ImagePickerSheetController

final public class ChatroomViewController: DLMessagesViewController {
	
	// MARK: - Parameters
	/// **Need history chatroom to check blur percentage
	var historyChatroom: HistoryChatroom!
	
	// MARK: Views
	private var dropDownButton: UIBarButtonItem!
	private var floatingOptionView = FloatingOptionView()
	
	// MARK: View Model
	private var viewModel: ChatroomViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
	
		self.delegate = self
        // Do any additional setup after loading the view.
		setupViewModel()
		
		configureFloatingOptionView()
		addRightNavButton()
    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		viewModel?.connectToChatRoom()
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	deinit {
		print("deinit")
	}
	
	// MARK: - Configuration
	private func setupViewModel() {
		viewModel = ChatroomViewModel(delegate: self)
		viewModel?.chatroomId = self.historyChatroom.chatroomId
	}
	
	private func configureFloatingOptionView() {
		let barHeight = (navigationController != nil ? navigationController!.navigationBar.frame.height : 0) + 20
		print(barHeight)
		floatingOptionView.frame.origin.y = barHeight - floatingOptionView.frame.height
		view.addSubview(floatingOptionView)
		floatingOptionView.delegate = self
	}
	
	private func addRightNavButton() {
		dropDownButton = UIBarButtonItem(image: UIImage(named: "chatDropDownIcon"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(toggleDropDownMenu))
		navigationItem.rightBarButtonItem = dropDownButton
	}
	
	@objc private func toggleDropDownMenu() {
		if floatingOptionView.isShown {
			// hide it
			floatingOptionView.isShown = false
			dropDownButton.image = UIImage(named: "chatDropDownIcon")
			UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
				self.floatingOptionView.frame.origin.y -= self.floatingOptionView.frame.height
				}, completion: nil)
		} else {
			// show it
			floatingOptionView.isShown = true
			dropDownButton.image = UIImage(named: "chatPullUpIcon")
			UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
				self.floatingOptionView.frame.origin.y += self.floatingOptionView.frame.height
				}, completion: nil)
		}
	}
	
	// MARK: Photo
	func needPermission() {
		let alert = UIAlertController(title: "需要存取照片權限", message: "如果要上傳照片，請至\"設定\">\"Colorgy\"的APP中打開存取照片的權限。", preferredStyle: UIAlertControllerStyle.Alert)
		let ok = UIAlertAction(title: "前往設定", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
			UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
			print(UIApplicationOpenSettingsURLString)
		})
		let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alert.addAction(ok)
		alert.addAction(cancel)
		presentViewController(alert, animated: true, completion: nil)
	}
}

extension ChatroomViewController : DLMessagesViewControllerDelegate {
	
	public func DLMessagesViewControllerDidClickedCameraButton() {
		viewModel?.openImagePicker()
	}
	
	public func DLMessagesViewControllerDidTapOnBubbleTableView() {
		if floatingOptionView.isShown {
			toggleDropDownMenu()
		}
	}
	
	public func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		viewModel?.sendTextMessage(message)
	}
	
	public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if viewModel != nil {
			return viewModel!.messageList.count
		} else {
			return 0
		}
	}
	
	public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if viewModel?.messageList[indexPath.row].userId != ColorgyChatContext.sharedInstance().userId {
			// incoming
			if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
//				cell.userImageView.image = userProfileImage
				cell.message = viewModel?.messageList[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingPhotoBubble
				
				//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
//				cell.userImageView.image = userProfileImage
				cell.message = viewModel?.messageList[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				cell.delegate = self
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				cell.delegate = self
				
				return cell
			}
		} else {
			if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				
				return cell
			} else if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messageList[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messageList[indexPath.row]
				
				return cell
			}
		}
	}
}

extension ChatroomViewController : DLMessageDelegate {
	
	func DLMessage(didTapOnSentImageView imageView: UIImageView?) {
		
	}
	
	func DLMessage(didTapOnUserImageView image: UIImage?, message: ChatMessage) {
		
	}
}

extension ChatroomViewController : ChatroomViewModelDelegate {
	public func chatroomViewModelDidRecieveMessages() {
		recievingABunchMessages()
	}
	
	public func chatroomViewModelDidConnectToChatRoom() {
		print(viewModel?.messageList.messageList)
		recievingABunchMessages()
	}
	
	public func chatroomViewModelRecievedOneMessage() {
		messageRecievedButDontReload()
	}
	
	// MARK: Photo
	public func chatroomViewModelRequestPhotoAccess() {
		
	}
	
	public func chatroomViewModelNeedPermissionToAccessPhoto() {
		needPermission()
	}
	
	public func chatroomViewModelOpenImagePicker() {
		let imagePickerController = ImagePickerSheetController(mediaType: ImagePickerMediaType.Image)
		
		imagePickerController.addAction(ImagePickerAction(title: "照片圖庫", secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("你已經選了 %lu 張照片", comment: "Action Title"), $0) as String}, style: ImagePickerActionStyle.Default, handler: { (action: ImagePickerAction) -> () in
			print("go to photo library")
			self.dismissKeyboard()
			let controller = UIImagePickerController()
			controller.delegate = self
			controller.sourceType = .PhotoLibrary
			self.presentViewController(controller, animated: true, completion: nil)
			}, secondaryHandler: { (action: ImagePickerAction, counts: Int) -> () in
				print(imagePickerController.selectedImageAssets.count)
				for asset in imagePickerController.selectedImageAssets {
					
					let options = PHImageRequestOptions()
					options.deliveryMode = .FastFormat
					
					PHImageManager.defaultManager().requestImageDataForAsset(asset, options: options, resultHandler: { (data: NSData?, string: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) -> Void in
						print(string)
						print(orientation)
						if let data = data, let image = UIImage(data: data) {
							self.viewModel?.sendImage(image)
						}
					})
				}
		}))
		
		imagePickerController.addAction(ImagePickerAction(title: "取消", handler: { (action: ImagePickerAction) -> () in
			print("hihi")
		}))
		
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			self.presentViewController(imagePickerController, animated: true, completion: nil)
		})
	}
	
	public func chatroomViewModelFailToSendMessage(error: ChatAPIError, afError: AFError?) {
		
	}
}

extension ChatroomViewController : FloatingOptionViewDelegate {
	
	func floatingOptionViewShouldNameUser() {
		
	}
	
	func floatingOptionViewShouldBlockUser() {
		
	}
	
	func floatingOptionViewShouldLeaveChatroom() {
		
	}
}

extension ChatroomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		viewModel?.sendImage(image)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
//
//  ChatRoomViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class ChatroomViewController: DLMessagesViewController {
	
	// MARK: - Parameters
	/// **Need chatroomId to create chatroom**
	var chatroomId: String!
	/// **Need userId to create chatroom**
	var userId: String!
	/// **Need uuid to create chatroom**
	var uuid: String!
	/// **Need history chatroom to check blur percentage
	var historyChatroom: HistoryChatroom!
	
	private var viewModel: ChatroomViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupViewModel()
    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		viewModel?.connectToChatRoom()
	}
	
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	// MARK: - Configuration
	private func setupViewModel() {
		viewModel = ChatroomViewModel(delegate: self)
		viewModel?.chatroomId = self.chatroomId
		viewModel?.userId = self.userId
		viewModel?.uuid = self.uuid
	}
}

extension ChatroomViewController : DLMessagesViewControllerDelegate {
	
	public func DLMessagesViewControllerDidClickedCameraButton() {
		
	}
	
	public func DLMessagesViewControllerDidTapOnBubbleTableView() {
		
	}
	
	public func DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message: String?) {
		
	}
	
	public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if viewModel != nil {
			return viewModel!.messages.count
		} else {
			return 0
		}
	}
	
	public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if viewModel?.messages[indexPath.row].userId != userId {
			// incoming
			if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
//				cell.userImageView.image = userProfileImage
				cell.message = viewModel?.messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingPhotoBubble
				
				//				cell.userImageView.sd_setImageWithURL(userProfileImageString.url, placeholderImage: nil)
//				cell.userImageView.image = userProfileImage
				cell.message = viewModel?.messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLIncomingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLIncomingMessageBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				cell.delegate = self
				
				return cell
			}
		} else {
			if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Text {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingMessageBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingMessageBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				
				return cell
			} else if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Image {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				cell.delegate = self
				
				return cell
			} else if viewModel?.messages[indexPath.row].type == ChatMessage.MessageType.Sticker {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCellWithIdentifier(DLMessageControllerIdentifier.DLOutgoingPhotoBubbleIdentifier, forIndexPath: indexPath) as! DLOutgoingPhotoBubble
				
				cell.message = viewModel?.messages[indexPath.row]
				
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
		recievingABunchMessages()
	}
	
	public func chatroomViewModelRecievedOneMessage() {
		messageRecievedButDontReload()
	}
}
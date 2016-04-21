//
//  FloatingOptionView.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/21.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol FloatingOptionViewDelegate {
	func floatingOptionViewShouldBlockUser()
	func floatingOptionViewShouldLeaveChatroom()
	func floatingOptionViewShouldNameUser()
}

class FloatingOptionView: UIView {
	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	var isShown = false
	var delegate: FloatingOptionViewDelegate?
	
	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
		self.frame.size.height = 90.0
		self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
		
		let leaveView = generateView(UIImage(named: "LeaveChatroom"), title: "離開")
		
		let blockView = generateView(UIImage(named: "blockUser"), title: "封鎖")
		
		let nameUserView = generateView(UIImage(named: "nameUserIcon"), title: "幫取名")
		
		// arrange
		leaveView.center.y = self.bounds.midY
		blockView.center.y = self.bounds.midY
		nameUserView.center.y = self.bounds.midY
		leaveView.center.x = self.bounds.maxX * (2.0 / 4.0)
		blockView.center.x =  self.bounds.maxX * ((3.0 + 0.2) / 4.0)
		nameUserView.center.x =  self.bounds.maxX * ((1.0 - 0.2) / 4.0)
		
		// add to view
		self.addSubview(leaveView)
		self.addSubview(blockView)
		self.addSubview(nameUserView)
		
		// tap ges
		leaveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leaveChatroom)))
		blockView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blockuser)))
		nameUserView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameUser)))
	}
	
	func nameUser() {
		delegate?.floatingOptionViewShouldNameUser()
	}
	
	func blockuser() {
		delegate?.floatingOptionViewShouldBlockUser()
	}
	
	func leaveChatroom() {
		delegate?.floatingOptionViewShouldLeaveChatroom()
	}
	
	private func generateView(image: UIImage?, title: String?) -> UIView {
		// option views
		let sizeOfView = CGSize(width: 28, height: 38)
		
		let view = UIView(frame: CGRectZero)
		view.frame.size = sizeOfView
		let label = UILabel()
		label.text = title
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.font = UIFont.systemFontOfSize(14)
		label.sizeToFit()
		let imageView = UIImageView(frame: CGRectMake(0, 0, 18, 18))
		imageView.image = image
		// arrange
		label.center.x = view.bounds.midX
		imageView.center.x = view.bounds.midX
		imageView.frame.origin.y = 0
		label.frame.origin.y = imageView.frame.maxY + 8
		view.addSubview(imageView)
		view.addSubview(label)
		
		return view
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

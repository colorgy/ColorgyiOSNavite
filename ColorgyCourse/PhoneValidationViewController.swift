//
//  PhoneValidationViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneValidationViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let k = PhoneValidationView(delegate: self)
		view.addSubview(k)
		k.frame.origin.y = 170
		k.targetPhoneNumber = "0988913868"
		
		let bb = ColorgyBillboardView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 170)))
		bb.billboardText = "驗證手機"
		view.insertSubview(bb, belowSubview: k)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
    }

}
extension PhoneValidationViewController : PhoneValidationViewDelegate {
	public func phoneValidationViewRequestReenterPhoneNumber() {
		print("phoneValidationViewRequestReenterPhoneNumber")
	}
	
	public func phoneValidationViewRequestResendValidationCode() {
		print("phoneValidationViewRequestResendValidationCode")
	}
}
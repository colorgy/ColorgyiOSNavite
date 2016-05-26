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
		
		let bb = ColorgyBillboardView(initialImageName: "PhoneAuthBillboard", errorImageName: "PhoneAuthErrorBillboard")
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
//
//  PhoneValidationViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneValidationViewController: UIViewController {
	
	var transitionManager: ReenterPhoneNumberViewControllerTransitioningDelegate?
	private var viewModel: PhoneValidationViewModel?

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel = PhoneValidationViewModel(delegate: self)
		
		let k = PhoneValidationView(delegate: self)
		view.addSubview(k)
		k.frame.origin.y = 170
		k.targetPhoneNumber = ColorgyUserInformation.sharedInstance().userUnconfirmedMobile
		print(ColorgyUserInformation.sharedInstance().userUnconfirmedMobile)
		
		let bb = ColorgyBillboardView(initialImageName: "PhoneAuthBillboard", errorImageName: "PhoneAuthErrorBillboard")
		view.insertSubview(bb, belowSubview: k)
		
		view.backgroundColor = ColorgyColor.BackgroundColor
		
		let sendCode = ColorgyFullScreenButton(title: "送出驗證碼", delegate: self)
		sendCode.frame.origin.y = k.frame.maxY + 24
		view.addSubview(sendCode)
    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		viewModel?.requestValidationSMS()
	}

}

extension PhoneValidationViewController : PhoneValidationViewModelDelegate {
	
}

extension PhoneValidationViewController : PhoneValidationViewDelegate {
	public func phoneValidationViewRequestReenterPhoneNumber() {
		print("phoneValidationViewRequestReenterPhoneNumber")
	}
	
	public func phoneValidationViewRequestResendValidationCode() {
		print("phoneValidationViewRequestResendValidationCode")
		viewModel?.requestValidationSMS()
	}
	
	/// This method will get called when user input 4 digits.
	/// Only trigger when input is 4 digits.
	public func phoneValidationView(validationCodeUpdatedTo code: String) {
		<#code#>
	}
}

extension PhoneValidationViewController : ColorgyFullScreenButtonDelegate {
	public func colorgyFullScreenButtonClicked(button: ColorgyFullScreenButton) {
		transitionManager = ReenterPhoneNumberViewControllerTransitioningDelegate()
		transitionManager?.mainViewController = self
		let a = ReenterPhoneViewController(title: "重新輸入手機", subtitle: "請檢查不要再寫錯囉～")
		transitionManager?.presentingViewController = a
		presentViewController(a, animated: true, completion: nil)
	}
}
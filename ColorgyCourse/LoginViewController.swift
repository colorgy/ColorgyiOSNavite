//
//  LoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var fbLoginButton: UIButton!
	@IBOutlet weak var emailLoginButton: UIButton!
	@IBOutlet weak var emailRegisterButton: UIButton!

	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoginButton()
		
		navigationController?.navigationBarHidden = true
	}
	
	// MARK: - Configure
	func configureLoginButton() {
		emailLoginButton.layer.cornerRadius = 4.0
		emailRegisterButton.layer.cornerRadius = 4.0
	}
	
	// MARK: - Storyboard
	struct Storyboard {
		static let emailLoginSegue = "Email Login Segue"
	}
}

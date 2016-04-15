//
//  EmailLoginViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class EmailLoginViewController: UIViewController {
	
	// MARK: - Parameters
	private var emailInputView: IconedTextInputView!
	private var passwordInputView: IconedTextInputView!
	private var viewModel: EmailLoginViewModel?

	// MARK: - Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// configure view
		configureLoginView()
		
		// assign view model
		viewModel = EmailLoginViewModel(delegate: self)
    }
	
	private func configureLoginView() {
		emailInputView = IconedTextInputView(imageName: "grayEmailIcon", placeholder: "輸入信箱", keyboardType: .Default, isPassword: false, delegate: self)
		passwordInputView = IconedTextInputView(imageName: "grayPasswordIcon", placeholder: "輸入密碼", keyboardType: .Default, isPassword: true, delegate: self)
	}
	
	private func configureLoginButton() {
		
	}
}

extension EmailLoginViewController : EmailLoginViewModelDelegate {
	
}

extension EmailLoginViewController : IconedTextInputViewDelegate {
	
	public func iconedTextInputViewShouldReturn(textInputView: IconedTextInputView) {
		
		if textInputView == emailInputView {
			passwordInputView.becomeFirstResponder()
		} else if textInputView == passwordInputView {
			
		}
	}
	
	public func iconedTextInputViewTextChanged(textInputView: IconedTextInputView, changedText: String?) {
		
		if textInputView == emailInputView {
			viewModel?.email = changedText
		} else if textInputView == passwordInputView {
			viewModel?.password = changedText
		}
	}
}
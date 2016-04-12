//
//  LoginViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

// MARK: - Delegate
public protocol LoginViewModelDelegate: class {
	func loginViewModel(failToLoginToFacebook error: ColorgyFacebookLoginError)
	func loginViewModel(failToLoginToColorgy error: ColorgyLoginError, afError: AFError?)
	func loginViewModel(failToGetDataFromServer error: APIError, afError: AFError?)
	func loginViewModel(loginToColorgy userHasPossibleOrganization: Bool)
}

final public class LoginViewModel {
	
	// MARK: - Parameters
	// MARK: Public
	public weak var delegate: LoginViewModelDelegate?
	// MARK: Private
	private let colorgyAPI: ColorgyAPI
	/// Use to check if its able to login
	private weak var periodRawData: PeriodRawData?
	private weak var apiMEResult: ColorgyAPIMeResult?
	
	// MARK: - Methods
	/// Call this to perform login using fb token
	public func facebookLogin() {
		ColorgyLogin.getFacebookAccessToken(success: { (token) in
			// Success login from facebook,
			// continue to get data from server
			ColorgyLogin.loginToColorgyWithFacebookToken(token, success: { (result) in
				// get me data after login
				
				//
				// need to fetch data as follow:
				// 1. me data
				// 2. period data
				// 
				self.colorgyAPI.me(success: { (result) in
					let organization = self.checkUserOrganization()
					self.colorgyAPI.getSchoolPeriodData(organization, success: { (periodData) in
						PeriodRawDataRealmObject.storePeriodRawData(periodData)
						// check user's possible organization code
						let state = ColorgyUserInformation.sharedInstance().userPossibleOrganization != nil ? true : false
						self.delegate?.loginViewModel(loginToColorgy: state)
						}, failure: { (error, afError) in
							self.delegate?.loginViewModel(failToGetDataFromServer: error, afError: afError)
					})
					}, failure: { (error, afError) in
						self.delegate?.loginViewModel(failToGetDataFromServer: error, afError: afError)
				})
				
				}, failure: { (error, afError) in
					// fail to login to colorgy
					self.delegate?.loginViewModel(failToLoginToColorgy: error, afError: afError)
			})
			}, failure: { (error) in
				self.delegate?.loginViewModel(failToLoginToFacebook: error)
		})
	}
	
	/// Call this to perform login using email
	public func emailLogin() {
		colorgyAPI.GETAllStoredDeviceToken(success: { (tokens) in
			print(tokens)
			}, failure: nil)
	}
	
	public func emailRegister() {
		
	}
	
	// MARK: - Helper
	private func checkUserOrganization() -> String {
		// TODO: handle no orgnization
		return ColorgyUserInformation.sharedInstance().userOrganization ?? ColorgyUserInformation.sharedInstance().userPossibleOrganization ?? "error orgnization"
	}
	
	// MARK: - Init
	init(delegate: LoginViewModelDelegate?) {
		self.delegate = delegate
		self.colorgyAPI = ColorgyAPI()
	}
}

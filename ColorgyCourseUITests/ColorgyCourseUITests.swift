//
//  ColorgyCourseUITests.swift
//  ColorgyCourseUITests
//
//  Created by David on 2016/4/9.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
import Quick
import Nimble

class ColorgyCourseUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let app = XCUIApplication()
		app.buttons["信箱登入"].tap()
		app.textFields["輸入信箱"].tap()
		app.textFields["輸入信箱"].typeText("colorgy-test-account-94@test.colorgy.io")
		app.secureTextFields["輸入密碼"].tap()
		app.secureTextFields["輸入密碼"].typeText("colorgy-test-account-94")
		app.buttons["登入"].tap()
		
		expect(app.buttons["信箱登入"].exists).toNot(beTrue())
    }
	
	func testLoginFail() {
		// Use recording to get started writing UI tests.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		
		
		let app = XCUIApplication()
		app.buttons["信箱註冊"].tap()
		app.textFields["輸入名稱"].tap()
		app.textFields["輸入名稱"].typeText("yoyo")
		app.textFields["輸入信箱"].tap()
		app.textFields["輸入信箱"].typeText("yoyo")
		app.buttons["註冊"].tap()
		expect(app.alerts["你輸入的資料有誤哦！"].collectionViews.buttons["知道了"].exists).to(beTrue())
		app.alerts["你輸入的資料有誤哦！"].collectionViews.buttons["知道了"].tap()
		app.secureTextFields["輸入密碼"].tap()
		app.secureTextFields["輸入密碼"].typeText("yoyoyoyo")
		app.secureTextFields["再次輸入密碼"].tap()
		app.secureTextFields["再次輸入密碼"].typeText("yoyoyoyo")
		app.buttons["註冊"].tap()
		expect(app.alerts["你輸入的資料有誤哦！"].collectionViews.buttons["知道了"].exists).to(beTrue())
		app.alerts["你輸入的資料有誤哦！"].collectionViews.buttons["知道了"].tap()
		
		
		
	}
	
}

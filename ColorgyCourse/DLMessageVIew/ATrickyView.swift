//
//  ATrickyView.swift
//  CustomMessengerWorkout
//
//  Created by David on 2016/1/13.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

protocol ATrickyViewDelegate {
    func aTrickyViewDelegate(currentKeyboardRect keyboardRect: CGRect?)
}

class ATrickyView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var isObserverAdded = false
    var pointer: UnsafeMutablePointer<Void> = nil
    
    var delegate: ATrickyViewDelegate?
    var barHeight: CGFloat = 44 {
        didSet {
//            print("bar height update \(barHeight)")
            if self.constraints.count > 0 {
                self.constraints[0].constant = barHeight
//                print(self.constraints)
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.mainScreen().bounds
        self.frame.size.height = barHeight
        self.backgroundColor = UIColor.clearColor()
//        self.layer.borderColor = UIColor.greenColor().CGColor
//        self.layer.borderWidth = 3.0
        self.userInteractionEnabled = false
//        print("acc view setup with height \(barHeight)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        if isObserverAdded {
            self.superview?.removeObserver(self, forKeyPath: "center", context: pointer)
            self.superview?.removeObserver(self, forKeyPath: "frame", context: pointer)
        }
        
        newSuperview?.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.init(rawValue: 0), context: pointer)
        newSuperview?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.init(rawValue: 0), context: pointer)
        isObserverAdded = true
        
//        print(newSuperview)
        super.willMoveToSuperview(newSuperview)
    }
    
    deinit {
        if isObserverAdded {
            self.superview?.removeObserver(self, forKeyPath: "frame", context: pointer)
            self.superview?.removeObserver(self, forKeyPath: "center", context: pointer)
//            print("deinit")
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "center" {
            if let object = object {
                if object.isEqual(self.superview) {
                    var frame = self.superview!.frame
                    frame.size.height -= barHeight
                    frame.origin.y += barHeight
                    if UIApplication.sharedApplication().statusBarFrame.height == 40 {
                        frame.origin.y -= 20
                    }
//                    print("check keyboard")
//                    print("status bar rect")
//                    print(UIApplication.sharedApplication().statusBarFrame)
//                    print("main bounds")
//                    print(UIScreen.mainScreen().bounds)
//                    print("keyboard frame")
//                    print(frame)
//                    print("atucal kb frame")
//                    print(self.superview!.frame)
                    if frame.origin.y <= UIScreen.mainScreen().bounds.height {
                        delegate?.aTrickyViewDelegate(currentKeyboardRect: frame)
                    }
                }
            }
        }
    }
    
    
}
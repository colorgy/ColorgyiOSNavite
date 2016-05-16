//
//  BlurWallViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class BlurWallViewController: UIViewController {
	
	private var blurWall: BlurWallView!
	private var viewModel: BlurWallViewModel?
	private var gender: Gender = .Unspecified
	
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureBlurWall()
		viewModel = BlurWallViewModel(delegate: self)
    }
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		print("load shit")
		viewModel?.loadWallWithGender(gender)
	}
	
	func configureBlurWall() {
		blurWall = BlurWallView(frame: UIScreen.mainScreen().bounds, delegate: self)
		view.addSubview(blurWall)
	}
}

extension BlurWallViewController : BlurWallViewModelDelegate {

	public func blurWallViewModel(failToLoadWall error: ChatAPIError, afError: AFError?) {
		
	}
	
	public func blurWallViewModel(failToRequestMoreData error: ChatAPIError, afError: AFError?) {
		
	}
	
	public func blurWallViewModel(updateWallWithGender gender: Gender, andUpdatedTargetList targetList: AvailableTargetList) {
		blurWall.targetList = targetList
	}
	
	
}

extension BlurWallViewController : BlurWallViewDelegate {
	
	public func blurWallViewAboutToTouchTheEnd() {
		print("about to touch the end")
		viewModel?.requestMoreTarget(gender)
	}
}
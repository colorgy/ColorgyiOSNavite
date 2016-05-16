//
//  BlurWallViewController.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class BlurWallViewController: UIViewController {
	
	public var blurWall: BlurWallView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureBlurWall()
    }
	
	func configureBlurWall() {
		blurWall = BlurWallView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
		view.addSubview(blurWall)
	}
}

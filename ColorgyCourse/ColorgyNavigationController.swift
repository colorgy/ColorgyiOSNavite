//
//  ColorgyNavigationController.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/19.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ColorgyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.navigationBar.barTintColor = UIColor.whiteColor()
		self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorgyColor.NavigationbarTitleColor]
		self.navigationBar.tintColor = ColorgyColor.MainOrange
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

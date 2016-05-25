//
//  PhoneValidationView.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneValidationView: UIView {
	
	private var titleLabel: UILabel!
	private var subtitleLabel: UILabel!
	
	private var digit1: PhoneDigitValidationField!
	private var digit2: PhoneDigitValidationField!
	private var digit3: PhoneDigitValidationField!
	private var digit4: PhoneDigitValidationField!

	public init() {
		super.init(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

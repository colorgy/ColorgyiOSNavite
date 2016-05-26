//
//  PhoneNumberTextField.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

final public class PhoneNumberTextField: UITextField {

	public override func textRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 18, 0)
	}
	
	public override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 18, 0)
	}

}

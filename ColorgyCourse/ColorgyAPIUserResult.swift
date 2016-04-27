//
//  File.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

final public class ColorgyAPIUserResult : ColorgyAPIMeResult {
	
	public override var description: String { return "ColorgyAPIUserResult: {\n\tid => \(id)\n\tuuid => \(uuid)\n\tusername => \(username)\n\tname => \(name)\n\tavatar_url => \(avatar_url)\n\tcover_photo_url => \(cover_photo_url)\n\t_type => \(_type)\n\torganization => \(organization)\n\tdepartment => \(department)\n\tpossible_organization_code => \(possible_organization_code)\n\tpossible_department_code => \(possible_department_code)\n}" }
}
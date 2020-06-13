//
//  UserRegistrationRequest.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 10/06/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Foundation

struct UserRegistrationRequest: Encodable {
    var email: String
    var password: String
    var confirm: String
}

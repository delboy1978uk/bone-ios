//
//  BoneUser.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 01/05/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Foundation

class BoneUser: Decodable {
    var id: Int!
    var email: String!
    var state: Int!
    var registrationDate: String? = nil
    var lastLoginDate: String? = nil
    var person: BonePerson? = nil

    enum BoneUserKey: String, CodingKey {
        case id = "id"
        case email = "email"
        case state = "state"
        case registrationDate = "registrationDate"
        case lastLoginDate = "lastLoginDate"
    }

    init(id: Int, email: String, state: Int, registrationDate: String?, lastLoginDate: String?) {
        self.id = id
        self.email = email
        self.state = state
        self.registrationDate = registrationDate
        self.lastLoginDate = lastLoginDate
    }
  
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: BoneUserKey.self)
        let id: Int = try values.decode(Int.self, forKey: .id)
        let email: String = try values.decode(String.self, forKey: .email)
        let state: Int = try values.decode(Int.self, forKey: .state)
        let registrationDate: String = try values.decode(String.self, forKey: .registrationDate)
        let lastLoginDate: String = try values.decode(String.self, forKey: .lastLoginDate)
        
        self.init(id: id, email: email, state: state, registrationDate: registrationDate, lastLoginDate: lastLoginDate)
    }
}

//
//  BonePerson.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 06/05/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Foundation

class BonePerson: Decodable {
    var id: Int!
    var firstname: String? = nil
    var middlename: String? = nil
    var lastname: String? = nil
    var aka: String? = nil
    var dob: String? = nil
    var birthplace: String? = nil
    var country: String? = nil

    enum BonePersonKey: String, CodingKey {
        case id = "id"
        case firstname = "firstname"
        case middlename = "middlename"
        case lastname = "lastname"
        case aka = "aka"
        case dob = "dob"
        case birthplace = "birthplace"
        case country = "country"
    }
    
    enum BoneCountryKey: String, CodingKey {
        case id = "id"
        case iso = "iso"
        case numCode = "num_code"
        case flag = "flag"
    }

    init(id: Int, firstname: String?, middlename: String?, lastname: String?, aka: String?, dob: String?, birthplace: String?, country: String?) {
        self.id = id
        self.firstname = firstname
        self.middlename = middlename
        self.lastname = lastname
        self.aka = aka
        self.dob = dob
        self.birthplace = birthplace
        self.country = country
    }
  
    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: BonePersonKey.self)
        let id: Int = try values.decode(Int.self, forKey: .id)
        let firstname: String = try values.decodeIfPresent(String.self, forKey: .firstname) ?? ""
        let middlename: String = try values.decodeIfPresent(String.self, forKey: .middlename) ?? ""
        let lastname: String = try values.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        let aka: String = try values.decodeIfPresent(String.self, forKey: .aka) ?? ""
        let dob: String = try values.decodeIfPresent(String.self, forKey: .dob) ?? ""
        let birthplace: String = try values.decodeIfPresent(String.self, forKey: .birthplace) ?? ""
        let country = try values.nestedContainer(keyedBy: BoneCountryKey.self, forKey: .country)
        let countryIso: String = try country.decode(String.self, forKey: .iso)
        
        self.init(id: id, firstname: firstname, middlename: middlename, lastname: lastname, aka: aka, dob: dob, birthplace: birthplace, country: countryIso)
    }
}

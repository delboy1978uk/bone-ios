//
//  ClientRegistrationRequest.swift
//  Bone iOS
//
//  Created by Derek Stephen McLean on 01/06/2020.
//  Copyright © 2020 Derek Stephen McLean. All rights reserved.
//

import Foundation

class ClientRegistrationRequest: Encodable {
    var redirect_uris: [URL]
    var client_name: String
    var token_endpoint_auth_method: String
    var logo_uri: URL

    enum Key: String, CodingKey {
        case redirect_uris = "redirect_uris"
        case client_name = "client_name"
        case token_endpoint_auth_method = "token_endpoint_auth_method"
        case logo_uri = "logo_uri"
    }

    init(redirect_uris: Array<URL>, client_name: String, logo_uri: URL) {
        self.redirect_uris = redirect_uris
        self.client_name = client_name
        self.token_endpoint_auth_method = "client_secret_basic"
        self.logo_uri = logo_uri
    }
}

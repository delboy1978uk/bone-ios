import Foundation
import Moya

enum ApiServices {
    case registerClient
    case getProfile
    case registerUser(email: String, password: String, confirm: String)
}

extension ApiServices: TargetType {
    static let baseURLPath = "https://api.mcleandigital.co.uk"

    var baseURL: URL { return URL(string: ApiServices.baseURLPath)! }
    var path: String {
        switch self {
        case .registerClient:
            return "/oauth2/register"
        case .registerUser:
            return "/api/user/register"
        case .getProfile:
            return "/api/user/profile"
        }
    }
    var method: Moya.Method {
        switch self {
        case .registerClient:
            return .post
        case .registerUser:
            return .post
        case .getProfile:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .registerClient:
            let settings = OAuthManager.shared.clientSettings
            let uris = settings["redirect_uris"] as! [String]
            let redirect = uris[0]
            let config = AppConfig()
            
            return .requestJSONEncodable([
                "redirect_uris": redirect,
                "client_name": config.clientName,
                "token_endpoint_auth_method": "client_secret_basic",
                "logo_uri": config.LogoUri
            ])
        case .getProfile:
            return .requestPlain
        case .registerUser(let email, let password, let confirm):
            return .requestJSONEncodable([
                "email" : email,
                "password" : password,
                "confirm" : confirm
            ])
        }
    }
    var sampleData: Data {
        switch self {
        case .registerClient, .getProfile, .registerUser:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return [
            "Accept": "application/vnd.api+json",
            "Content-Type": "application/vnd.api+json"
        ]
    }
}

extension ApiServices: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .registerClient, .getProfile, .registerUser:
            return .none
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


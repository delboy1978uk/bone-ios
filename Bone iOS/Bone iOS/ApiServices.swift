import Foundation
import Moya

enum ApiServices {
    case getUser
    case getProfile
}

extension ApiServices: TargetType {
    static let baseURLPath = "https://api.mcleandigital.co.uk"

    var baseURL: URL { return URL(string: ApiServices.baseURLPath)! }
    var path: String {
        switch self {
        case .getUser:
            return "/api/user/me"
        case .getProfile:
            return "/api/user/profile"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .getProfile:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getUser: // Send no parameters
            return .requestPlain
        case .getProfile: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getUser, .getProfile:
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
        case .getUser, .getProfile:
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

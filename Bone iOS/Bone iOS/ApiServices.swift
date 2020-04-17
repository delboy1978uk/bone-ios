import Foundation
import Moya

enum ApiServices {
    case getUser
    case getAccount
}

extension ApiServices: TargetType {
    static let baseURLPath = "https://api.coinbase.com"

    var baseURL: URL { return URL(string: ApiServices.baseURLPath)! }
    var path: String {
        switch self {
        case .getUser:
            return "/v2/user"
        case .getAccount:
            return "/v2/accounts"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .getAccount:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getUser: // Send no parameters
            return .requestPlain
        case .getAccount: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getUser, .getAccount:
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
        case .getUser, .getAccount:
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

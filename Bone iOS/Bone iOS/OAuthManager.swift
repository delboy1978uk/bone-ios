import OAuth2


struct OAuthManager {
    static let shared = OAuthManager()

    var registrationClient = OAuth2ClientCredentials(settings: [
        "client_id": "cc52460765f08d0f29ceb0deaf37645f",
        "client_secret": "JDJ5JDEwJDNlOGZVQjdaWVl1cHl1WVZpSElLei5EcHM1MEhnWHY0dDVQNllBdzRyRGRneUdLb0RXNkFx",
        "authorize_uri": "https://api.mcleandigital.co.uk/oauth2/authorize",
        "token_uri": "https://api.mcleandigital.co.uk/oauth2/token",   
        "redirect_uris": ["bone://oauth2/callback"],   // register your own "myapp" scheme in Info.plist
        "scope": "basic register-user",
        "secret_in_body": true,    // Github needs this
        "keychain": true,
        ] as OAuth2JSON)
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "da03fbd98f3b52da981b2e50bba4bcd4",
        "client_secret": "JDJ5JDEwJGcyY0YweGNsM2dxUVBCZDg2NFlrVk81bDQuMW55blJPS09GT3cyMERIRWhISUM4RTdLa29T",
        "authorize_uri": "https://api.mcleandigital.co.uk/oauth2/authorize",
        "token_uri": "https://api.mcleandigital.co.uk/oauth2/token",
        "redirect_uris": ["bone://oauth2/callback"],   // register your own "myapp" scheme in Info.plist
        "scope": "basic",
        "use_pkce": true,
        "secret_in_body": true,    // Github needs this
        "keychain": true,
        ] as OAuth2JSON)
}

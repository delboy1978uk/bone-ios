import OAuth2


struct OAuthManager {
    static let shared = OAuthManager()

    var oauth2 = OAuth2ClientCredentials(settings: [
        "client_id": "cc52460765f08d0f29ceb0deaf37645f",
        "client_secret": "JDJ5JDEwJDNlOGZVQjdaWVl1cHl1WVZpSElLei5EcHM1MEhnWHY0dDVQNllBdzRyRGRneUdLb0RXNkFx",
        "authorize_uri": "https://api.mcleandigital.co.uk/oauth2/authorize",
        "token_uri": "https://api.mcleandigital.co.uk/oauth2/token",   // code grant only
        "redirect_uris": ["bone://oauth2/callback"],   // register your own "myapp" scheme in Info.plist
        "scope": "basic register-user",
        "secret_in_body": true,    // Github needs this
        "keychain": true,         // if you DON'T want keychain integration
        ] as OAuth2JSON)
}

import OAuth2


class OAuthManager {
    static var shared = OAuthManager()

    var registrationClient = OAuth2ClientCredentials(settings: [
        "client_id": "cc52460765f08d0f29ceb0deaf37645f",
        "client_secret": "JDJ5JDEwJDNlOGZVQjdaWVl1cHl1WVZpSElLei5EcHM1MEhnWHY0dDVQNllBdzRyRGRneUdLb0RXNkFx",
        "authorize_uri": "https://api.mcleandigital.co.uk/oauth2/authorize",
        "token_uri": "https://api.mcleandigital.co.uk/oauth2/token",   
        "redirect_uris": ["bone://oauth2/callback"],   // register your own "myapp" scheme in Info.plist
        "scope": "register",
        "secret_in_body": true,    // Github needs this
        "keychain": true,
        "keychain_account_for_tokens": "regClientTokens"
        ] as OAuth2JSON)
    //
    var clientSettings = [
        "authorize_uri": "https://api.mcleandigital.co.uk/oauth2/authorize",
        "token_uri": "https://api.mcleandigital.co.uk/oauth2/token",
        "redirect_uris": ["bone://oauth2/callback"],   // register your own "myapp" scheme in Info.plist
        "scope": "basic",
        "use_pkce": true,
        "secret_in_body": true,    // Github needs this
        "keychain": true,
        "keychain_account_for_tokens": "userTokens"
        ] as [String : Any]
    
    private var oauth2: OAuth2CodeGrant! = nil
    private var userClientInitialised: Bool = false
    
    func hasClientRegistered() -> Bool {
        let clientId = KeychainWrapper.standard.string(forKey: "client_id")
        
        if clientId != nil{
            print("client has registered")
            return true
        }
        print("client has not registered")
        return false
    }
    
    func storeClient(clientID: String, clientSecret: String) { 
        KeychainWrapper.standard.set(clientID, forKey: "client_id")
        KeychainWrapper.standard.set(clientID, forKey: "client_secret")
    }
    
    func hasUserClientInitialised() -> Bool {
        return userClientInitialised
    }
    
    func initUserClient() -> OAuth2CodeGrant {
        print ("creating user client")
        let clientId = KeychainWrapper.standard.string(forKey: "client_id")
        let clientSecret = KeychainWrapper.standard.string(forKey: "client_secret")
        clientSettings["client_id"] = clientId
        clientSettings["client_secret"] = clientSecret
        OAuthManager.shared.oauth2 = OAuth2CodeGrant(settings: clientSettings as OAuth2JSON)
        userClientInitialised = true
        
        return OAuthManager.shared.oauth2
    }
    
    func getClient() -> OAuth2CodeGrant {
        return oauth2
    }
}

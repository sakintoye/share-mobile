import Siesta
import SwiftyJSON

// Depending on your taste, a Service can be a global var, a static var singleton, or a piece of more carefully
// controlled shared state passed between pieces of the app.

let SPAPI = SharePaymentAPI()

class SharePaymentAPI: Service {
    
    // MARK: Configuration
    
//    private let service = Service(baseURL: "https://api.payment.akintoye.me")
//    var authToken: AuthToken?
    
    init() {
        
    //   #if DEBUG
    //       LogCategory.enabled = [.network, .staleness]
    //   #endif
        
        super.init(baseURL: "https://api.payment.akintoye.me")
        // Global default headers
        configure {
            if let auth = self.authToken {
                $0.config.headers["Access-Token"] = auth.accessToken
                $0.config.headers["Token-Type"] = auth.tokenType
                $0.config.headers["Client"] = auth.client
                $0.config.headers["Expiry"] = auth.expiry
                $0.config.headers["Uid"] = auth.uid
            }
            $0.config.pipeline[.parsing].add(SwiftyJSONTransformer, contentTypes: ["*/json"])
        }

        
        configureTransformer("/me") {
            (content: JSON, entity: Entity) -> User in
            User(json: content)
        }
        
        configureTransformer("/contacts") {
            (content: JSON, entity: Entity) -> [User] in
            content["data"]
                .arrayValue
                .map(User.init)
        }
        
        configureTransformer("/members") {
            (content: JSON, entity: Entity) -> [User] in
            content["data"]
                .arrayValue
                .map(User.init)
        }
        
        configureTransformer("/payments") {
            (content: JSON, entity: Entity) -> [Payment] in
            content["data"]
                .arrayValue
                .map(Payment.init)
        }
        
//        configureTransformer("/search/repositories") {
//            try ($0.content as JSON)["items"].arrayValue
//                .map(User.init)
//        }
    }
    
    var authToken: AuthToken? {
        didSet {
            // Rerun existing configuration closure using new value
            invalidateConfiguration()
            
            // Wipe any Siesta’s cached state if auth token changes
            wipeResources()
        }
    }
    
    var contact:      Resource { return resource("/contacts") }
    var invitation:   Resource { return resource("/invitations") }
    var me:           Resource { return resource("/me") }
    var member:       Resource { return resource("/members") }
    var payment:      Resource { return resource("/payments") }
    var stripe:       Resource { return resource("/stripe") }
    
    // MARK: Authentication
    
    func logIn(username: String, password: String) -> Request {
        return self.resource("auth/sign_in")
            .request(.POST, json: ["email": username, "password": password])
    }
    
    func signUp(fullname: String, email: String, password: String, confirm_password: String) -> Request {
        return self.resource("auth")
            .request(.POST, json: ["name": fullname, "email": email, "password": password, "confirm_password": confirm_password])
    }
    
    func logOut() {
        basicAuthHeader = nil
    }
    
    var isAuthenticated: Bool {
        return basicAuthHeader != nil
    }
    
    private var basicAuthHeader: String? {
        didSet {
            // These two calls are almost always necessary when you have changing auth for your API:
            
            self.invalidateConfiguration()  // So that future requests for existing resources pick up config change
            self.wipeResources()            // Scrub all unauthenticated data
        }
    }
    
}

private let SwiftyJSONTransformer =
    ResponseContentTransformer
        { JSON($0.content as AnyObject) }

import Foundation

extension UserDefaults {
    
    var onbordingLoaded: Bool? {
        get {
            return value(forKey: .onbordingLoaded) as? Bool
        }
        set {
            set(newValue, forKey: .onbordingLoaded)
            synchronize()
        }
    }
    
    var token: String? {
        get {
            return value(forKey: .token) as? String
        }
        set {
            set(newValue, forKey: .token)
            synchronize()
        }
    }
    
    var user: User? {
        get {
            if let decodedData = value(forKey: .user) as? Data {
                let decodedValue = try? JSONDecoder().decode(User.self, from: decodedData)
                return decodedValue
            }
            return nil
        }
        set {
            if let value = newValue {
                let encodedData = try? JSONEncoder().encode(value)
                set(encodedData, forKey: .user)
                synchronize()
            }
        }
    }
    
    var appLanguage: String? {
        get {
            return value(forKey: .appLanguage) as? String
        }
        set {
            set(newValue, forKey: .appLanguage)
            synchronize()
        }
    }
    
    var showSpotLight: Bool? {
        get {
            return value(forKey: .showSpotLight) as? Bool
        }
        set {
            set(newValue, forKey: .showSpotLight)
            synchronize()
        }
    }
    
    var showAlert: Int64? {
        get {
            return value(forKey: .showAlert) as? Int64
        }
        set {
            set(newValue, forKey: .showAlert)
            synchronize()
        }
    }
    
    func clearSpecifiedItems() {
        removeObject(forKey: .token)
        removeObject(forKey: .user)
        synchronize()
    }
}

extension String {
    static let onbordingLoaded     = "onbordingLoaded"
    static let token               = "token"
    static let user                = "user"
    static let appLanguage         = "appLanguage"
    static let showSpotLight       = "showSpotLight"
    static let showAlert           = "showMessageAlert"
}

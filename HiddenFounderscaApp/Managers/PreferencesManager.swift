import Foundation
import CoreBluetooth

class PreferencesManager {
    
    static let defaults = UserDefaults()
    
    static func getStringPreference(key: String) -> String {
        if let value = defaults.string(forKey: key) {
            return value
        }
        return ""
    }
    
    static func removePreference(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    static func getToken() -> String {
        return getStringPreference(key: "token")
    }
    
    static func saveToken(token: String) {
        defaults.set(token, forKey: "token")
    }
    
    static func removeToken() {
        removePreference(key: "token")
    }
    
    static func clearData() {
        removePreference(key: "token");
    }
}

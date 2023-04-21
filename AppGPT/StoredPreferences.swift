
import Foundation
import SwiftUI

public struct StoredPreferences {
    
    private static let ApiKeyUserDefaultKey: String = "TokenApiKey"
    private static let MaxTokenDefaultKey: String = "MaxTokenKey"
    private static let TemperatureDefaultKey: String = "TemperatureKey"
    
    public static func SetTokenApiKey(tokenApiKey: String) -> Void {
        UserDefaults.standard.set(tokenApiKey, forKey: ApiKeyUserDefaultKey)
    }
    
    public static func GetTokenApiKey() -> String? {
        return UserDefaults.standard.string(forKey: ApiKeyUserDefaultKey) ?? nil
    }
    
    public static func SetMaxToken(maxToken: Int) -> Void {
        UserDefaults.standard.set(maxToken, forKey: MaxTokenDefaultKey)
    }
    
    public static func GetMaxToken() -> Int {
        return UserDefaults.standard.integer(forKey: MaxTokenDefaultKey)
    }
    
    public static func SetTemperature(temperature: Double) -> Void {
        UserDefaults.standard.set(temperature, forKey: TemperatureDefaultKey)
    }
    
    public static func GetTemperature() -> Double {
        UserDefaults.standard.double(forKey: TemperatureDefaultKey)
    }
}


import Foundation
import SwiftUI
import Combine

struct SettingsView: View {
    
    private enum Tabs: Hashable {
            case general, informations
        }
    
    @State static var activeTabView: String = "General"
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label ("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .frame(width: 600, height: 300)
    }
    
    public static func GetActiveTabViewTitle() -> String {
        return activeTabView
    }
}

struct GeneralSettingsView: View {
    
    @State var settingApiKey: String = StoredPreferences.GetTokenApiKey() ?? ""
    
    @State var settingMaxToken: String = String(StoredPreferences.GetMaxToken())
    @State var settingTemperature: String = String(StoredPreferences.GetTemperature())
    
    var body: some View {
        Form {
            TextField("Clé d'API ChatGPT", text: $settingApiKey)
                .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 100))
                .onChange(of: settingApiKey) { _ in
                    StoredPreferences.SetTokenApiKey(tokenApiKey: settingApiKey)
                }
            
            TextField("Token maximums", text: Binding(
                get: {settingMaxToken},
                set: {
                    settingMaxToken = $0.filter{"0123456789".contains($0)}
                    StoredPreferences.SetMaxToken(maxToken: Int(settingMaxToken) ?? 50)
                })
            )
            .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 100))
            
            TextField("Température", text: Binding(
                get: {settingTemperature},
                set: {
                    settingTemperature = $0.filter{"0123456789.".contains($0)}
                    StoredPreferences.SetTemperature(temperature: Double(settingTemperature) ?? 0.7)
                })
            )
            .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 100))
        }
    }
}

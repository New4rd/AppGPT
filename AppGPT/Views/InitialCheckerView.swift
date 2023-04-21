
import Foundation
import SwiftUI

struct InitialCheckerView: View {
        
    @State private var apiStringKey: String = ""
    @State private var loggableKey: Bool = false
    
    
    var body: some View {
        
        Color.white
            .ignoresSafeArea()
            .frame(
                minWidth: 500,
                maxWidth: 500,
                minHeight: 500,
                maxHeight: 500).overlay {
                    
                Group {
                    VStack
                    {
                        Image("elogo")
                            .resizable()
                            .frame(width: 100, height: 100)
                        if loggableKey
                        {
                            HStack {
                                TextField("Entrer la clé d'API pour ChatGPT", text: $apiStringKey)
                                    .controlSize(.large)
                                    .textFieldStyle(.roundedBorder)
                                
                                Button("Envoyer") {
                                    StoredPreferences.SetTokenApiKey(tokenApiKey: apiStringKey)
                                    if InitialCheckerView.HasValidTokenApiKey()
                                    {
                                        NSApplication.shared.keyWindow?.close()
                                    }
                                }
                                .controlSize(.large)
                                .buttonStyle(.bordered)
                            }
                            .padding(EdgeInsets(top: 0, leading:50, bottom: 0,trailing:50))
                        }
                    }
                }
                .task (delayCkeck)
                .preferredColorScheme(.light)
            }
    }
    
    private func delayCkeck() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if (!InitialCheckerView.HasValidTokenApiKey()) {
            loggableKey = true
            return
        }
        
        await NSApplication.shared.keyWindow?.close()
    }
    
    public static func HasValidTokenApiKey() -> Bool {
        
        let key: String? = StoredPreferences.GetTokenApiKey()
        if (key == nil) { return false }
        if (key == "") { return false }
        
        return true
    }
}

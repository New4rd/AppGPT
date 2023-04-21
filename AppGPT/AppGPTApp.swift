//
//  AppGPTApp.swift
//  AppGPT
//
//  Created by Maxime Barre on 12/04/2023.
//

import SwiftUI

@main
struct AppGPTApp: App {
    
    @Environment(\.openWindow) var openWindow
        
    let usable: Bool = InitialCheckerView.HasValidTokenApiKey()
    
    var body: some Scene {
        
        /// initial window, checking for an API key
        WindowGroup {
            InitialCheckerView()
                .onDisappear(perform:{
                    if !InitialCheckerView.HasValidTokenApiKey() {
                        NSApplication.shared.terminate(nil)
                        return
                    }
                    
                    openWindow(id: "main-view")
                }
            )
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        /// main view
        WindowGroup(id: "main-view") {
            MainView()
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.automatic)
        
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button("Paramètres") {
                    openWindow(id: "settings")
                }
            }
        }
        
        WindowGroup(id: "settings") {
            SettingsView()
                .navigationTitle(SettingsView.GetActiveTabViewTitle())
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}

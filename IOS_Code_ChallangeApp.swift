//
//  IOS_Code_ChallangeApp.swift
//  IOS-Code-Challange
//
//  Created by Ibrahim Alperen Kurum on 12.12.2025.
//

import SwiftUI

@main
struct IOS_Code_ChallangeApp: App {
    init() {
        DataManager.shared.clearVisitedRepositories()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

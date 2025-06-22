//
//  ElephantMacApp.swift
//  Elephant
//
//  Created by 陸卉媫 on 4/14/25.
//

import SwiftUI
import Firebase

@main
struct ElephantMacApp: App {
    @StateObject private var taskListStorage = TaskListStorage()
    @StateObject var themeManager = ThemeManager()
    @StateObject var token = TokenLogic()
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // ask permission of notification
    init() {
        FirebaseApp.configure()
        NotificationView.shared.requestNotificationPermission()
        print(UserDefaults.standard.integer(forKey: "tokenNum"))
        //https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskListStorage)//defines storage for task list upon app build
                .environmentObject(themeManager)//sets settings mode and theme background upon app build
                .environmentObject(token) // sets token accesible to all
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 400, height: 500)
    }
}

//
//  AppDelegate.swift
//  Elephant
//
//  Created by 陸卉媫 on 6/21/25.
//

import SwiftUI
import FirebaseCore
import AppKit

// suggested by gemini to fix that issue that firebase instructions was ios based
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) { // <-- Use applicationDidFinishLaunching for macOS
            FirebaseApp.configure()
        print("Firebase has been configured for macOS!") // Add a print statement to confirm
            
            // You might add other macOS-specific setup here if needed,
            // for example, for push notifications using NSApplicationDelegate methods.
    }
    
    // You might also need this method if your app uses windows that need to be managed
    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }

    // This method is important if your app is designed to open files or reactivate after closing all windows
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Return true if the app should quit when the last window is closed
    }
}

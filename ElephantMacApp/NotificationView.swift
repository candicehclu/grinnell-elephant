/*
 ## File Name: NotificationView.swift
 
 ## File Description: A tempalte (singleton class) for creating a notification for each time.
 Used  Online Swift Playground (SwiftFiddle) for formatting the code.
 
 ## Creator Group: Elephant
 
 ## Author: Hyeyun
 
 ## Components:
 NotificationView class: singleton class for notificiaiotns pop up in the mac. (contains a function to generate
a new notification with times)
 
 ## Note:
   For global usage (sharing data), we can do:
   https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
   Use it like a envrionment thing we did for themeManager. (added to main)
  (Sinc we need to track states)
  References:
 https://developer.apple.com/documentation/usernotifications
 https://developer.apple.com/documentation/usernotifications/untimeintervalnotificationtrigger
 https://commitstudiogs.medium.com/how-to-implement-push-notifications-in-swift-d0f1a3caf49b
 https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent
 https://youtu.be/mIztoF9CzP8?si=-nreQJ0vAkKjscdU
 https://www.avanderlee.com/xcode/xcode-mark-line-comment/
 https://www.hackingwithswift.com/read/21/2/scheduling-notifications-unusernotificationcenter-and-unnotificationrequest
 */



import UserNotifications
import SwiftUI

//single ton class (Only one instance)
class NotificationView{
    // Purpose of singleton class: shared one instance `NotificationView` for convenient access across the app
    
    // Instantiation
    static let shared = NotificationView()
    
    
    // MARK: - requestNotificationPermission
    // ====================================================
    // Get permission from the user to display notification
    // ----------------------------------------------------
    // Called once when app luanches
    // ====================================================
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        // handle silently
        center.requestAuthorization(options: [.alert, .sound,.badge]){
            _,_ in
        }
        
        // following may be used for debugging:
        //        center.requestAuthorization(options: [.alert, .sound,.badge]){ granted, error in
        //            if let error = error{
        //                print("Notification Permission Error")
        //            }
        //            else{
        //                print(granted ? "Notification permission granted." : "Notification permission denied.")
        //            }
        //        }
        
    }//requestNotificationpermission()
        
        
        // MARK: - scheduleNotification
        // ====================================================
        // Function for scheduling notification
        // ----------------------------------------------------
        // Called when setting the notification with time.
        // ====================================================
        
        /*
         * ## Paramters:
         * notifyTime: how many minutes after do we notify
         * Title: title of the notification
         * Body: body of the notification.
         *
         * ## Example Usage:
         * First, request permission (say when app launches in main)
         * NotificationView.shared.requestNotificationPermission()
         * Next, schedule a notification (ex: like pomodor ends or not)
         * NotificationView.shared.scheduleNotification( notifyTime: 30, title: "Break Time", body: "Take a break")
         */
        func scheduleNotification(notifyTime seconds: TimeInterval, title: String, body: String){
            
            @AppStorage("curAvatar") var curAvatar = "mammal-elephant"

            // get the content
            let content   = UNMutableNotificationContent()
            content.title = title
            content.body  = body
            content.sound = UNNotificationSound.default
            
            // attach curavatar to the notification
            if let image = NSImage(named: curAvatar),
                   let tiffData = image.tiffRepresentation,
                   let bitmap = NSBitmapImageRep(data: tiffData),
                   let pngData = bitmap.representation(using: .png, properties: [:]) {

                    // Create a temporary file URL
                    let tempDir = FileManager.default.temporaryDirectory
                    let tempURL = tempDir.appendingPathComponent("notification_icon.png")

                    do {
                        try pngData.write(to: tempURL)
                        let attachment = try UNNotificationAttachment(identifier: "assetImage", url: tempURL, options: nil)
                        content.attachments = [attachment]
                    } catch {
                        print("Failed to write asset image to disk: \(error)")
                    }
                }

            
            // triger (when to show)
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
            
            // request (content + trigger)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: notificationTrigger
            )
            UNUserNotificationCenter.current().add(request)
        }// scheduleNotification
        
    } //end of class

var NotificationMusicDict = [
    "Arabian Nightfall": "arabian_nightfall.mp3",
    "Baroque Coffee House": "baroque_coffee_house.mp3",
    "Cartoon Bank Heist": "cartoon_bank_heist.mp3",
    "Rooster": "rooster.wav",
    "Sour Tennessee Red": "sour_tennessee_red.mp3",
    "None": ""
]

var WorkNotifications = [
    "Time to get back to work and be productive!",
    "Refreshed? Let’s make progress now!",
    "One step closer to your goal. Let’s go!",
    "Back to it — you've got this!",
    "You're making great progress! Keep it up!",
    "Let’s crush the next task!",
    "Your wellness buddy says: time to focus!",
    "Welcome back! Let’s do a little more.",
    "Your mind is rested. Let’s use that energy!",
    "Ready for your next level? Let’s go!",
    "Break’s done — time to power up!",
    "Let’s earn another token!",
    "Focus mode: ON. Let's win today!"
]

var BreakNotifications = [
    "Take a break and pick a wellness task!",
    "Take a breath, take a stretch.",
    "Step away and rest your mind for a few minutes.",
    "Great work! Take a well-deserved break.",
    "Break time! You've earned this one.",
    "Victory! Time to reward yourself with rest.",
    "Your wellness buddy says: unplug for a bit!",
    "Hydration check: drink some water while you break!",
    "The elephant says: nap, stretch, or dance!",
    "Break now, conquer later.",
    "Let your eyes rest. You've been working hard.",
    "Short break, big impact.",
]

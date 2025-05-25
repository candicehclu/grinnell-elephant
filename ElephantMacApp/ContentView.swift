//
//  ContentView.swift
//  Elephant
//
//  Description: App's homepage that appears once app is launched.
//
//  Author(s): Medhashree (main editor), Candice (creator)
//
//  The following pages are linked: Manual, Settings, Collectibles Shop, and widget Timer selection
//

/** References:
 https://developer.apple.com/documentation/swiftui/button -  Buttons
 https://developer.apple.com/documentation/swiftui/picker - Picker
 */

import SwiftUI

// Homepage
struct ContentView: View {
    @State private var isPressed = false
    @EnvironmentObject var themeManager: ThemeManager // theme manager
    @EnvironmentObject var storage: TaskListStorage // tasklist storage
    @EnvironmentObject var tokenLogic: TokenLogic //to modify tokens
    @AppStorage("curAvatar") private var curAvatar = "mammal-elephant"
    @AppStorage("timerMode") var timerMode: String = "stopwatch"

    var body: some View {
        NavigationStack{
            ZStack{
                //                (Mode ? Color.black : Color.white)//Background color
                //                    .edgesIgnoringSafeArea(.all)
                //                    .accessibilityIdentifier("homePage") // identifier for homepage
                // homepage structure
                VStack{
                    // structure the settings and manual page buttons
                    // put this HStack in general file to access from other pages
                    HStack{
                        Spacer()
                        ToSettingsPageButton() // Button to settings page
                        ToManualPageButton() // Button to manual page
                    } // manual and settings page button area
                    .padding([.top, .trailing], 15)

                    // Main title
                    Text("Elephant")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .kerning(2) // keep space between letters for better readability
                        .accessibilityIdentifier("mainPage")
                    // Subheadline following Elephant
                    Text("A Wellness Trunk")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .kerning(1)
                    // Subheadline following "A Wellness Trunk"
                    Text("♡🐘♡")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                    // App logo placeholder
                    Image(curAvatar)
                        .resizable()
                        .scaledToFit()
                    // Title area and button separator
                    Text("⸻⸻⸻")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                
                    // TIMERS MODE MENU
                    NavigationLink(destination: TimerView()) {
                        Picker("Mode", selection: $timerMode) {
                            Text("Stopwatch").tag("stopwatch")
                            Text("Pomodoro").tag("pomodoro")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 125, alignment: .center) // keeps the "mode: currentmode" padded and centered
                        .frame(width: 200, height: 60) // size of outer frame
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .background(themeManager.curTheme.main_color_2)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(themeManager.curTheme.background_1)
                    .foregroundColor(themeManager.curTheme.text_2)
                    .accessibilityIdentifier("timerPage")
                    .frame(alignment: .center)
                                                            
                    // COLLECTIBLES SHOP BUTTON
                    NavigationLink(destination: ShopMainPageView().environmentObject(themeManager)) {
                        Text("Collectibles Shop")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .frame(width: 200, height: 60)
                            .background(themeManager.curTheme.main_color_2)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }  // NavigationLink - set up and adjustments
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(themeManager.curTheme.background_1)
                    .foregroundColor(themeManager.curTheme.text_2)
                    .accessibilityIdentifier("shopPage")
                    
                    // CHECKLISTS SHOP BUTTON
                    NavigationLink(destination: ChecklistMainPageView().environmentObject(themeManager)) {
                        Text("Checklists")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .frame(width: 200, height: 60)
                            .background(themeManager.curTheme.main_color_2)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }  // NavigationLink - set up and adjustments
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(themeManager.curTheme.background_1)
                    .foregroundColor(themeManager.curTheme.text_2)
                    .padding(.bottom, 25)
                    .accessibilityIdentifier("checklistsPageLink")
                    
                } // VStack - structures whole page
                .background(themeManager.curTheme.background_1)
            } // ZStack
        } // NavigationStack
        .environmentObject(themeManager) // set this on NavStack to stay clean
        .frame(width: 400, height: 500)
        // .preferredColorScheme(themeManager.Mode ? .dark : .light)
//        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.background))
        .foregroundColor(themeManager.curTheme.text_1)
        .onAppear {
            NotificationView.shared.requestNotificationPermission()
            tokenLogic.updateDailyLimit()
            storage.updateTaskList()
        }
    } // main body
} // ContentView Struct

#Preview {
    let themeManager = ThemeManager()
    ContentView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

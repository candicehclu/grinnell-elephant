//
//  StopwatchView.swift
//  Elephant
//
//  Created by 陸卉媫 on 4/14/25.
//
// source:
// https://medium.com/@pwilko/how-not-to-create-stopwatch-in-swift-e0b7ff98880f
// https://stackoverflow.com/questions/71910830/create-a-stopwatch-in-swift-using-timeintervalsince
// https://medium.com/@iOSchandra0/how-to-create-a-stopwatch-in-swift-5-viewcontroller-viewmodel-swiftui-cefa5c5e3d0
// https://developer.apple.com/documentation/widgetkit/appintenttimelineprovider
// https://developer.apple.com/documentation/widgetkit/appintenttimelineprovider/placeholder(in:)
// https://developer.apple.com/documentation/widgetkit/appintenttimelineprovider/snapshot(for:in:)
// https://developer.apple.com/documentation/widgetkit/appintenttimelineprovider/timeline(for:in:)

import SwiftUI

struct StopwatchView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var storage: TaskListStorage //for checklist access
    @EnvironmentObject var tokenLogic: TokenLogic //to modify tokens
    
    //checklist variables
    @State private var selectedChecklist: Checklist? = nil
    @State private var showingChecklist = false
    
    // whether the timer is running or not
    @State private var isRunning: Bool = false
    // timer start time
    @State private var startTime: Date = Date()
    // how many seconds has passed
    @State private var elapsedTime: Double = 0.0
    // string to display on timer
    @State private var timerString: String = "00:00:00"
    // timer that updates everysecond and triggers re-render
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // use user defaults to ensure generalizability to widget
    let timerValues = UserDefaults(suiteName: "group.elephant.widget")
    
    // returns a formatted string based on how many seconds have passed
    func formatTime(secs: Int) -> String {
        let hours = Int(secs) / 3600
        let minutes = (Int(secs) % 3600) / 60
        let seconds = Int(secs) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // updates timer as long as timer is running
    func updateTimer() {
        // manually add values to user default
        timerValues?.set(isRunning, forKey: "isRunning")
        timerValues?.set(startTime, forKey: "startTime")
        timerValues?.set(elapsedTime, forKey: "elapsedTime")
        let timeInterval =  Int(Date().timeIntervalSince(startTime))
        timerString = formatTime(secs: timeInterval)
    }
    
    var body: some View {
        VStack{
            VStack{
                // show timer string and update
                Text(timerString)
                    .font(Font.system(.largeTitle, design: .monospaced))
                    .onReceive(timer) { _ in
                        if isRunning {
                            updateTimer()
                        }
                    }
//                    .foregroundColor(themeManager.Mode ? themeManager.textColor(for: themeManager.curTheme.background) : themeManager.textColor(for: themeManager.curTheme.main_color_1))
                    .foregroundColor(themeManager.curTheme.text_1)
                
                HStack{
                    ElephantButton(
                        buttonText: "Start",
                        action: {
                            // only does something if the timer is not already running
                            if (isRunning != true) {
                                startTime = Date().addingTimeInterval( -elapsedTime)
                                isRunning = true
                            }
                        },
                        color: themeManager.curTheme.main_color_1
                    )
                    ElephantButton(
                        buttonText: "Reset",
                        action: {
                            isRunning = false
                            elapsedTime = 0.0
                            timerString = formatTime(secs: 0)
                        },
                        color: themeManager.curTheme.main_color_1
                    )
                    ElephantButton(
                        buttonText: "Pause",
                        action: {
                            let now = Date()
                            // store how long the timer has ran so we can resume later
                            elapsedTime += now.timeIntervalSince(startTime)
                            isRunning = false
                        },
                        color: themeManager.curTheme.main_color_1
                    )
                }
            }
            
//            //currently selected checklist display
//            VStack(spacing: 15){
////                Divider()
////                    .padding(.vertical, 10)
//                //Checklist title text
//                Text("Checklist: ")
//                    .font(.system(.title2, design: .rounded).weight(.bold))
//                    .foregroundColor(themeManager.Mode ? themeManager.textColor(for: themeManager.curTheme.background) : themeManager.textColor(for: themeManager.curTheme.main_color_1))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 15)
//                
//                if storage.checklists.isEmpty  {
//                    Text("No checklists available..")
//                        .foregroundColor(themeManager.Mode ? themeManager.textColor(for: themeManager.curTheme.background).opacity(0.7) : themeManager.textColor(for: themeManager.curTheme.main_color_1).opacity(0.7))
//                        .padding()
//                } else {
//                    ScrollView(.horizontal, showsIndicators: true){
//                        HStack(spacing: 10){
//                            ForEach(storage.checklists){ checklist in
//                                checklistButton(for: checklist)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//
//            }
//            .padding(.top, 20)
        }
        .environmentObject(themeManager)
        .padding(10)
        .accessibilityIdentifier("stopwatchView")
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
        .background(themeManager.curTheme.background_1)
        //displays currently selected checklist button
        .sheet(item: $selectedChecklist) { checklist in
            NavigationView {
                    CheckListView(
                        checklistId: checklist.id,
                        checklistName: checklist.name,
                        initialTasks: checklist.tasks
                    )
                    .environmentObject(storage)
                    .environmentObject(themeManager)
                    .environmentObject(tokenLogic)
            }
            .frame(width: 500, height: 500)
        }
    }
    
    //checklist button from ChecklistMainPageView
//    private func checklistButton(for checklist: Checklist) -> some View {
//            
//        Button(action: {
//            selectedChecklist = checklist
//        }) {
//            VStack {
//                Text(checklist.name) //displays checklist name
//                    .font(.system(.title3, design: .rounded).weight(.medium))
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1))
//                
//                Spacer()
//                
//                Text("\(checklist.tasks.filter { $0.isCompleted }.count)/\(checklist.tasks.count)") //displays number of completed tasks/total tasks
//                    .font(.system(.subheadline, design: .rounded))
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1).opacity(0.7))
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(themeManager.curTheme.main_color_1))
//            .fixedSize()
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
}

#Preview {
    let themeManager = ThemeManager()
    StopwatchView()
        .environmentObject(themeManager)
        .environmentObject(TokenLogic())
        .environmentObject(TaskListStorage())
}

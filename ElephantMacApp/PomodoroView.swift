//
//  PomodoroView.swift
//  Elephant
//
//  Created by Pruneda Turcios, Gabriela, modified by Candice Lu

import SwiftUI
import AVFoundation

struct PomodoroView: View{
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var storage: TaskListStorage //for checklist access
    @EnvironmentObject var tokenLogic: TokenLogic //to modify tokens
    
    //checklist variables
    @State private var selectedChecklist: Checklist? = nil
    @State private var showingChecklist = false
    
    // pomodoro break time variables
    @AppStorage("workDuration") private var selectedWorkTime = 25
    @AppStorage("shortBreakTime") private var shortBreakTime = 5
    @AppStorage("longBreakTime") private var longBreakTime = 15

    @AppStorage("selectedNotificationMusicPath") var selectedNotificationMusicPath = "rooster.wav"
    
    // whether timer is running
    @State private var isRunning: Bool = false
    // whether timer is paused
    @State private var isPaused: Bool = false
    // timer start time
    @State private var startTime: Date = Date()
    // how many seconds has passed
    @State private var elapsedTime: Double = 0.0
    // how many seconds is remaining
    @State private var remainingTime: Double = 0.0
//    // whether timer just ended or not
//    @State private var timerEnded: Bool = false
    // string to display on timer
    @State private var timerString: String = "00:00:00"
    // timer that updates everysecond and triggers re-render
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // track breaks
    @State private var breakCount: Int = 0
    @State private var isBreak: Bool = false
    
    // audio player
    @State private var player: AVAudioPlayer?
    
    public func playSound(file: String) {
        if file != "" {
            let fileComponents = file.split(separator: ".")
            let name = String(fileComponents[0])
            let ext = String(fileComponents[1])
            if let file = Bundle.main.url(forResource: name, withExtension: ext) {
                do {
                    player = try AVAudioPlayer(contentsOf: file)
                    player?.prepareToPlay()
                    player?.play()
                } catch {
                    print("Unable to play music: \(error)")
                }
            }
        }
    }
    
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
        if remainingTime > 0 {
            remainingTime -= 1
            if remainingTime == 0 {
                playSound(file: selectedNotificationMusicPath)
                if isBreak {
                    NotificationView.shared.scheduleNotification(notifyTime: 1, title: "Work time!", body: WorkNotifications.randomElement()!)
                } else {
                    NotificationView.shared.scheduleNotification(notifyTime: 1, title: "Break time!", body: BreakNotifications.randomElement()!)
                }
            }
            timerString = formatTime(secs: Int(remainingTime))
        } else {
            // if timer ends, start new session
            isRunning = false
            if isBreak {
                isBreak = false
                timerString = formatTime(secs: selectedWorkTime*60)
                remainingTime = Double(selectedWorkTime*60)
            } else {
                isBreak = true
                if breakCount % 4 != 3 {
                    timerString = formatTime(secs: shortBreakTime*60)
                    remainingTime = Double(shortBreakTime*60)
                }   else {
                    timerString = formatTime(secs: longBreakTime*60)
                    remainingTime = Double(longBreakTime*60)
                }
            }
            // startNewCycle()
        }
    }
    
    // resets timer and starts a new cycle
    // Developed under assistance of ChatGPT
    func startNewCycle() {
        // if it's not break: start a timer for work
        if !isBreak {
//            isBreak = false
            timerString = formatTime(secs: selectedWorkTime*60)
            remainingTime = Double(selectedWorkTime*60)
        } else {
            // if break: start a timer for break and increment break
//            isBreak = true
            breakCount += 1
            // long break if three breaks have passed
            if breakCount % 4 != 3 {
                timerString = formatTime(secs: shortBreakTime*60)
                remainingTime = Double(shortBreakTime*60)
            }   else {
                timerString = formatTime(secs: longBreakTime*60)
                remainingTime = Double(longBreakTime*60)
            }
        }
    }
    
    var body: some View{
        VStack{
//            for sound testing
//            Button("Test Sound") {
//                playSound(file: "rooster.wav")
//            }
            Text(timerString)
                .font(Font.system(.largeTitle, design: .monospaced))
                .onReceive(timer) { _ in
                                if isRunning {
                                    updateTimer()
                                }
                            }
                .foregroundColor(themeManager.curTheme.text_1)
                .padding(.top, -8)
                .padding(.bottom, -1)

            HStack{
                // start button:
                // if timer is already running, do nothing
                // if timer not running:
                    // if paused: resume
                    // if not paused:
                        // if we just finished a break cycle: reset to work interval and start new cycle
                        // if we just finished a work cycle: reset to break interval
                ElephantButton(
                    buttonText: "Start",
                    action: {
                        // only do something if it's not already running
                        if !isRunning {
                            if !isPaused {
                                startNewCycle()
                            }
                            isRunning = true
                        }
                    },
                    color: themeManager.curTheme.main_color_1)
                ElephantButton(
                    buttonText: "Reset",
                    // resets remaining time to selected work time
                    action: {
                        isRunning = false
                        elapsedTime = 0.0
                        breakCount = 0
                        isBreak = false
                        remainingTime = Double(selectedWorkTime*60)
                        timerString = formatTime(secs: selectedWorkTime * 60)
                    },
                    color: themeManager.curTheme.main_color_1)
                ElephantButton(
                    buttonText: "Pause",
                    action: {
                        let now = Date()
                        // store how long the timer has ran so we can resume later
                        elapsedTime += now.timeIntervalSince(startTime)
                        isRunning = false
                        isPaused = true
                    },
                    color: themeManager.curTheme.main_color_1)
                // strings for clarity and testing purpose
            }
            // testing!
//            ElephantText(displayText: "break count: \(breakCount)")
//            ElephantText(displayText: "is break?: \(isBreak)")
            if isBreak {
                ElephantText(displayText: "Break Time!")
//                    .foregroundColor(themeManager.Mode ? themeManager.textColor(for: themeManager.curTheme.background) : themeManager.textColor(for: themeManager.curTheme.main_color_1))
                    .foregroundColor(themeManager.curTheme.text_1)
            }
            
//            //currently selected checklist display
//            VStack(spacing: 15){
//                Divider()
//                    .padding(.vertical, 10)
//                
//                Text("Checklist: ")
//                    .font(.system(.title2, design: .rounded).weight(.bold))
//                    .foregroundColor(themeManager.Mode ? themeManager.textColor(for: themeManager.curTheme.background) : themeManager.textColor(for: themeManager.curTheme.background))
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
        .accessibilityIdentifier("pomodoroView")
        .background(themeManager.curTheme.background_1)
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
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
            .frame(width: 400, height: 500)
        }
        .onAppear() {
            if selectedWorkTime < 10 {
                timerString = "00:0\(selectedWorkTime):00"
            } else {
                timerString = "00:\(selectedWorkTime):00"
            }
        }
    }
    
    //checklist button from ChecklistMainPageView
    private func checklistButton(for checklist: Checklist) -> some View {
            
        Button(action: {
            selectedChecklist = checklist
        }) {
            VStack {
                Text(checklist.name) //displays checklist name
                    .font(.system(.title3, design: .rounded).weight(.medium))
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1))
                    .foregroundColor(themeManager.curTheme.main_color_1)
                
                Spacer()
                
                Text("\(checklist.tasks.filter { $0.isCompleted }.count)/\(checklist.tasks.count)") //displays number of completed tasks/total tasks
                    .font(.system(.subheadline, design: .rounded))
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1).opacity(0.7))
                foregroundColor(themeManager.curTheme.text_1)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.curTheme.main_color_1))
            .fixedSize()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let themeManager = ThemeManager()
    PomodoroView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

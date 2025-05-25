//
//  SettingsView.swift
//  Elephant
//
//  Created by 陸卉媫 on 3/14/25.
//  Authored by Gabriela Pruneda Turcios
//
 //Sources: preferredColorScheme mode:
/*https://developer.apple.com/documentation/swiftui/view/preferredcolorscheme(_:)*/

// source for Geometry Reader used for custom slider:
/*https://medium.com/@amitaswal87/understanding-geometryreader-in-swiftui-a-detailed-guide-2bd3031e5712*/
//

// source for searchable dropdown menu: https://medium.com/@wesleymatlock/creating-advanced-dropdown-menus-in-swiftui-74fd20cf9bab

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode //navigating to different presentation based on command
    
    @EnvironmentObject var themeManager: ThemeManager //found within ColorSettings, manages global theme settings
//    @AppStorage("displayMode") private var Mode: Bool = false // default light mode
    
    @AppStorage("timerMode") var timerMode: String = "pomodoro" //set default to pomodoro
    
    //Default time settings for Pomodoro and Stopwatch widget integration
    @AppStorage("workDuration") var selectedWorkTime: Double = 25
    @AppStorage("shortBreakTime") var shortBreakTime: Double = 5
    @AppStorage("longBreakTime") var longBreakTime: Double = 15
    @AppStorage("reminderTime") var selectedReminderTime: Double = 30
    
    // notification music
    @AppStorage("selectedNotificationMusic") var selectedNotificationMusic: String = "Select an Option"
    @AppStorage("selectedNotificationMusicPath") var selectedNotificationMusicPath: String = "Select an Option"
    
    // theme
    @AppStorage("selectedTheme") var selectedTheme = "default"
    @AppStorage("curTheme") var curTheme = "default"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Settings")
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -5)
                        .frame(alignment: .center)
                        .font(.system(size: 28, design: .rounded).weight(.bold))
                    Spacer()
                    ToHomePageButton() // Button to homepage
                    ToManualPageButton() // Button to manual page
                }

                // modeSection // Mode selection
                
                // themeSection // Theme selection
                sectionTitle(text: "Themes")
                SearchableDropdownMenu(
                    selectedOption: $selectedTheme,
                    options: allThemes.keys.sorted(),
                    onSelect: {selected in
                        curTheme = allThemes[selected] ?? "default"
                    })
                
                sectionTitle(text: "Notification Music")
                SearchableDropdownMenu(
                    selectedOption: $selectedNotificationMusic,
                    options: NotificationMusicDict.keys.sorted(),
                    onSelect: {selected in
                        selectedNotificationMusicPath = NotificationMusicDict[selected] ?? "rooster.wav"
                    })
                
                //checklistSection // Checklist button
                
                // sectionTitle(text: "Timer Settings", centered: true)
                // Pomodoro time settings
                pomodoroTimeSection
                // Stopwatch time settings
                stopwatchTimeSection
                
                //Spacer()
            }
        }
        .padding()
        .preferredColorScheme(themeManager.Mode ? .dark : .light) //based on user selection
        .background(themeManager.curTheme.background_1) //based on user selection
        .frame(width: 400, height: 500) //frames scroll view
    }
    
    //mode section Button that chooses between light and dark mode, applying the mode globally
    private var modeSection: some View {
        VStack(alignment: .leading) {
            sectionTitle(text: "Modes")
            ElephantButton(buttonText: themeManager.Mode ? "Dark Mode" : "Light Mode", action: {
                themeManager.toggleMode()
            }, color: themeManager.Mode ? .gray.opacity(0.7) : .gray.opacity(0.2))
        }
    }
    
    //Includes all current theme options
    //Utilizes ElephantButton from Utils for theme selection
    private var themeSection: some View {
        VStack(alignment: .leading) {
            sectionTitle(text: "Themes")
            HStack(spacing: 15) {
                // Create buttons for each theme
                //Default elephant theme
                ElephantButton(
                    buttonText: "Default",
                    action: { themeManager.setTheme(named: "defaultElephant") },
                    color: themeManager.curThemeKey == "defaultElephant" ?
                    themeManager.curTheme.main_color_1 : Color.gray.opacity(0.2))
                //Black and White theme
                ElephantButton(
                    buttonText: "Black & White",
                    action: { themeManager.setTheme(named: "blackWhite") },
                    color: themeManager.curThemeKey == "blackWhite" ?
                    themeManager.curTheme.main_color_1 : Color.gray.opacity(0.2))
                //Benny the Cow theme
                ElephantButton(
                    buttonText: "Benny",
                    action: { themeManager.setTheme(named: "benny") },
                    color: themeManager.curThemeKey == "benny" ?
                    themeManager.curTheme.main_color_1 : Color.gray.opacity(0.2))
            }
        }
    }
    
    // Displays Pomodoro time settings and sliders
    private var pomodoroTimeSection: some View {
        timeSection(title: "Pomodoro", sliders: [
            // ("Work Duration", $selectedWorkTime, 20, 60, 5),
            ("Work Duration", $selectedWorkTime, 0.1, 60, 0.1),
            ("Short Break Duration", $shortBreakTime, 5, 30, 5),
            ("Long Break Duration", $longBreakTime, 15, 30, 5)
        ])
    }
    
    //displays stopwatch time settings for reminder intervals
    private var stopwatchTimeSection: some View {
        timeSection(title: "Stopwatch", sliders: [
            ("Reminder Intervals", $selectedReminderTime, 20, 120, 10)
        ])
    }
    
    //reusable sectionTitle for various section headers
    func sectionTitle(text: String, centered: Bool = false) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .padding()
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }
    //displays time section for both pomodoro and stopwatch settings
    func timeSection(title: String, sliders: [(String, Binding<Double>, Double, Double, Double)]) -> some View {
        VStack(alignment: .leading) {
            sectionTitle(text: title)
            ForEach(0..<sliders.count, id: \.self) { index in
                let time_set = sliders[index]
                HStack {
                    Text(time_set.0)
                        .font(.title3)
                        .fontWeight(.thin)
                        .fontDesign(.rounded)
                    
                    Spacer()
                    //displays user currently selected time above each slider
                    Text("Current Setting: \(Int(time_set.1.wrappedValue)) min")
                        .font(.headline)
                        .foregroundColor(themeManager.curTheme.main_color_2)
                }//calls customSlider based on interval ranges
                customSlider(selectedTime: time_set.1, minTime: time_set.2, maxTime: time_set.3, interval: time_set.4)
            }
        }
    }
        
}//bottom of SettingsView


 /*Custom slider for various time settings for pomodoro and stopwatch.
  Slider customizable between minimum, maximum and break time intervals between work breaks*/
struct customSlider: View {

    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTime: Double
    let minTime: Double
    let maxTime: Double
    let interval: Double
    
    var body: some View {
        VStack { //builds slider for various settings
            Slider(value: $selectedTime, in: minTime...maxTime, step: interval)
                .accentColor(.clear)
                .background(
                    GeometryReader { geo in
                        Capsule()
                            .fill(themeManager.curTheme.main_color_3)
                            .frame(height: 4)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    }
                )
            
            HStack {
                Text("\(Int(minTime)) min") //displays lowest interval in the range
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundColor(themeManager.curTheme.main_color_3)
                Spacer()
                Text("\(Int(maxTime)) min") //displays highest interval in the range
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundColor(themeManager.curTheme.main_color_3)
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .preferredColorScheme(themeManager.Mode ? .dark : .light) //based on user selection

    }
}

struct SearchableDropdownMenu: View {

    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedOption: String
    @State private var isExpanded = false
    @State private var searchText = ""
    
    let options: [String]
    var onSelect: ((String) -> Void)? = nil

  var filteredOptions: [String] {
    if searchText.isEmpty {
      return options
    } else {
      return options.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
  }

  var body: some View {
    ZStack {
        Button(action: { isExpanded.toggle() }) {
            HStack {
              Text(selectedOption)
              Spacer()
              Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.curTheme.main_color_1)
            )
//            .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_2))
            .foregroundColor(themeManager.curTheme.text_1)
        }.buttonStyle(PlainButtonStyle())

      if isExpanded {
        VStack {
          TextField("Search...", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(3)

          ForEach(filteredOptions, id: \.self) { option in
              Text("\(option)")
                  .padding(.bottom, 5)
                  .onTapGesture {
                      selectedOption = option
                      onSelect?(option)
                      isExpanded = false
                  }
            }
        }
        .background(themeManager.curTheme.main_color_1)
        .cornerRadius(8)
        .shadow(radius: 5)
      }
    }
    .padding(.horizontal)
  }
}


//SettingsView preview
#Preview {
    let themeManager = ThemeManager()
    SettingsView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}


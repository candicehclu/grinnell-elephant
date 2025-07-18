/*
 ## File Name: ManualView.swift
 Used  Online Swift Playground (SwiftFiddle) for formatting the code.
 
 ## File Description: This file defines the manual and onboarding views for the Elephant app. The manual contains link to description of each funtionality
 
 ## Components:
 - ManualTemplateView: A reusable SwiftUI template providing navigation, layout, and dynamic styling for each page in manual pages.
 - Struct for each oage
 
 ## References:
 https://developer.apple.com/documentation/swiftui/font
 https://stackoverflow.com/questions/24002092/what-is-the-difference-between-let-and-var-in-swift
 https://developer.apple.com/documentation/swiftui/anyview
 https://medium.com/@jaberi.mohamedhabib/understanding-some-view-and-anyview-in-swiftui-erased-and-opaque-return-types-2c7a69903335
 https://www.swiftbysundell.com/tips/creating-custom-swiftui-container-views/
 https://sarunw.com/posts/custom-back-button-action-in-swiftui/
 https://developer.apple.com/documentation/swiftui/navigationstack
 https://developer.apple.com/documentation/swiftui/navigationlink
 https://www.swiftyplace.com/blog/better-navigation-in-swiftui-with-navigation-stack
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/
 https://stackoverflow.com/questions/55213078/what-is-the-difference-between-swift-structs-and-objective-c-structs
 https://makeapppie.com/2019/10/23/checklists-in-swift-ui/
 https://developer.apple.com/documentation/swiftui/state
 https://www.hackingwithswift.com/quick-start
 https://developer.apple.com/documentation/swiftui/plainbuttonstyle
 https://www.avanderlee.com/xcode/xcode-mark-line-comment/
 */
import SwiftUI


// MARK: - Manual Template
// ====================================================
// Manual Template
// ----------------------------------------------------
// Template for each manual page
// ====================================================

/*
 `ManualTemplateView` is a reusable SwiftUI component for layout for pages for each manual page
 
 ## Purpose:
 - Provide a consistent and reusable layout wrapper for manual/help pages.
 - No needto  manually configure each page.
 
 ## Parameters:
 - `currentPageIdentifier`: A unique string identifier for each page
 - `content`: Content to display
 - `backPage`: Navigate back button to go back to page (optional)
 - `nextPage`: Navigate forward button to go front (optional)
 - `homePage`: Navigate home button to go to main page of the app.
 
 */
struct ManualTemplateView<Content: View>:  View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    //--------------------------
    // Variable Initializiation
    //--------------------------
    var currentPageIdentifier: String
    var content: Content
    var backPage: AnyView?
    var nextPage: AnyView?
    var homePage: AnyView?
    
    
    init(
        currentPageIdentifier: String,
        content: () -> Content,
        backPage: AnyView? = nil,
        nextPage: AnyView? = nil,
        homePage: AnyView? = nil
    )
    {
        self.currentPageIdentifier = currentPageIdentifier
        self.content = content()
        self.backPage = backPage
        self.nextPage = nextPage
        self.homePage = homePage
    }//init
    
    var body: some View {
        
        //--------------------
        // Main Layout Start
        //--------------------
        VStack(spacing: 0) {
            //-------------------
            // Content Area Start
            //-------------------
            ScrollView {
                content
                    .padding()
                    .background(
                        Color.clear
                            .accessibilityElement(children: .combine)
                            .accessibilityIdentifier(currentPageIdentifier)
                            .shadow(color: themeManager.curTheme.text_1.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                    .id(currentPageIdentifier)
            }//ScrollView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //--------------------
            // Button Stack Starts
            //--------------------
            // Footer stack with navigation buttons
            HStack {
                if let backPage = backPage {
                    NavigationLink(destination: backPage) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(themeManager.curTheme.main_color_2)
                            .accessibilityIdentifier("backButton")
                            .allowsHitTesting(true)
                    }//NavigationLink
                    .buttonStyle(PlainButtonStyle()) // get rid of the white box behind
                }// if backPage
                
                Spacer()//expands leftward
                
                if let nextPage = nextPage {
                    NavigationLink(destination: nextPage) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(themeManager.curTheme.main_color_2)
                            .accessibilityIdentifier("nextButton")
                            .allowsHitTesting(true)
                    }//NavigationLink
                    .buttonStyle(PlainButtonStyle()) // get rid of the white box behind
                }//nextPage
            }//HStack
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
        .frame(width: 400, height: 500)
        .background(themeManager.curTheme.background_1)
    }//VStack
}// var body


//ManualTemplateView

// MARK: - Main OverView Page
// ====================================================
// OverView
// ----------------------------------------------------
// First page of the manual.
// Shows a brief overview and links to sections.
// ====================================================

struct ManualView:View{
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "manualFirstPage",
            content: {
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {// Header stack with home button
                        Text("Welcome!")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    Text(
                        "Are you ready to incorporate wellness tasks into your work routine with us? Balance your work and wellness routine through Elephant. Let’s get started!"
                    )
                    Text("To turn on notifications, go to ")
                    + Text("System Settings > Notifications ").bold()
                    + Text("and allow notification from Elephant: A Wellness Trunk.")
                    NavigationLink(destination: StopwatchPageView()) {
                        
                        Text("Stopwatch Mode")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(themeManager.curTheme.main_color_1)
                            .cornerRadius(10)
                    }// NavigationLink stopwatch
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: PomodoroPageView()) {
                        Text("Pomodoro Mode")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(themeManager.curTheme.main_color_1)
                            .cornerRadius(10)
                        
                    }//NavigationLink pomodoro
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: TokensPageView()) {
                        Text("Earn Tokens")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(themeManager.curTheme.main_color_1)
                            .cornerRadius(10)
                        
                    }//NavigationLink tokenspageview
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: ExamplesPageView()) {
                        Text("Example User Cases")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(themeManager.curTheme.main_color_1)
                            .cornerRadius(10)
                        
                    }//NavigationLink examplespage
                    .buttonStyle(PlainButtonStyle())
                    
                    //                    NavigationLink(destination: WidgetSetupPageView()) {
                    //                        Text("Set Up Widget")
                    //                            .font(.system(.title2, design: .rounded).weight(.semibold))
                    //                            .frame(maxWidth: .infinity, alignment: .leading)
                    //                            .padding()
                    //                            .background(themeManager.curTheme.main_color_1)
                    //                            .cornerRadius(10)
                    //
                    //                    }//NavigationLink widgetsetup
                    //                    .buttonStyle(PlainButtonStyle())
                }//vstack
            }//content
            ,
            homePage: AnyView(ContentView())
            
        )//ManualTemplateView
        .frame(maxWidth: .infinity, alignment: .leading)
    }//body
}//ManualView

// MARK: - StopwatchPageView
// ====================================================
// Stopwatch Mode
// ----------------------------------------------------
// Page for explaining stopwatch
// ====================================================
// Stopwatch Page
struct StopwatchPageView: View {
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "stopwatchPage",
            content: {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {// Header stack with home button
                        Text("Stopwatch Mode")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    
                    Text("Turn on the stopwatch when you start working. Receive wellness reminders at custom intervals, and turn it off when you're done.")
                        .font(.body)
                    
                    //probably insert something for settings on how to use
                }// vstack
            },
            backPage: AnyView(ManualView()), // back to home
            homePage: AnyView(ContentView())
        )//ManualTemplateView
    }//var body
}//StopwatchPageView

// MARK: - PomodoroPageView
// ====================================================
// Pomodoro Mode
// ----------------------------------------------------
// Page for explaining pomodoro
// ====================================================
// Stopwatch Page

struct PomodoroPageView: View {
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "pomodoroPage",
            content: {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {// Header stack with home button
                        Text("Pomodoro Mode")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    
                    Text("Work in focused intervals with short breaks in between. After four work sessions, enjoy a longer break to recharge!")
                        .font(.body)
                    //probably insert something for settings on how to use
                }//Vstack
            },
            backPage: AnyView(ManualView()),
            homePage: AnyView(ContentView())
        )//ManualTemplateview
    }//var body
}//pomodoropage

// MARK: - TokensPageView
// ====================================================
// Tokens Page
// ----------------------------------------------------
// Page for explaining token
// ====================================================
struct TokensPageView: View {
    @EnvironmentObject var token: TokenLogic
    
    // TODO: add example when the widget is completed
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "tokensPage",
            content: {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {// Header stack with home button
                        Text("Earn Tokens")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    
                    Text("How To")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                    Text("Complete wellness tasks to earn tokens. Redeem tokens to collect fun avatars and customize your experience!")
                        .font(.body)
                    Text("Every time you complete the task, you earn one token. The tokens can be used to purchase avatar in the collectible shop.")
                        .font(.body)
                    Text("Daily limit: 5 ")
                        .font(.body)
                    
                    Divider() //divide example and
                    
                    Text("Example Task & Token") //from Sam
                        .font(.system(.title2, design: .rounded).weight(.bold))
                    ChecklistView(items: [
                        ChecklistItem(label: "Take a 10min walk", isChecked: false),
                        ChecklistItem(label: "Dance", isChecked: false),
                        ChecklistItem(label: "Eat a banana", isChecked: true)
                    ])//checklistview
                    
                    //problem since unchdkcing and checking abck adds token
                    // Token count
                    
                    Text("Tokens: \(token.exampleTokenNum)")
                        .font(.body)
                        .padding(.top, 5)
                }//vstack
                .onAppear(){
                    token.exampleTokenNum = 0
                }
            }//content
            ,
            backPage: AnyView(ManualView()),
            homePage: AnyView(ContentView())
        )//ManualTemplateView
    }// body
}// TokensPageView



/*
 Each item inside the checklist
 */
struct ChecklistItem: Identifiable {
    let id = UUID()
    let label: String
    var isChecked: Bool //applying feedback about allowing the check demo
}//ChecklistItem

/*
 CbeckBoxView Template View
 
 References:
 https://www.hackingwithswift.com/quick-start/swiftui/building-a-menu-using-list
 https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-binding-property-wrapper
 */
struct CheckBoxView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isChecked: Bool  // <-- binding to allow toggling
    
    // Action after the checkmark
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .foregroundColor(isChecked ? themeManager.curTheme.main_color_3 : Color.secondary)
            .onTapGesture {
                if(isChecked == false){ //once checked only checking possible unchecking impossible
                    isChecked=true
                }
            }//.onTapGesture
    }// var body
    
}//CheckBoxView

/*
 ChecklistView struct template
 
 References:
 https://developer.apple.com/documentation/swiftui/foreach
 https://fatbobman.com/en/posts/avoid_repeated_calculations_of_swiftui_views/
 https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-binding-property-wrapper
 */

// TODO: try out token
//https://www.avanderlee.com/swiftui/environmentobject/
//https://stackoverflow.com/questions/76714373/static-method-buildexpression-requires-that-myapp-conform-to-view
//https://developer.apple.com/documentation/swiftui/view/onchange(of:perform:)
//https://stackoverflow.com/questions/78919404/how-do-i-fix-my-onchangeofperform-to-avoid-xcode-giving-me-a-deprecation-war
struct ChecklistView: View {
    @EnvironmentObject var token: TokenLogic //need this whever you use it in some view
    @State var items: [ChecklistItem] // @state will allow update
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            ForEach($items) { $item in
                HStack {
                    
                    Text(item.label) // allow to be checked.
                    CheckBoxView(isChecked: $item.isChecked)
                    
                    
                        .onChange(of: item.isChecked) { oldValue, newValue  in //onChange is part of view
                            if newValue == true && oldValue == false  {
                                token.addFakeToken()
                            }
                        }//Hstack
                }//ForEach
            }//Vstack
        }//var body
    }//ChecklistView
}

// MARK: - ExamplesPageView
// ====================================================
// ExamplesPageView
// ----------------------------------------------------
// Page for showing sample suercases
// ====================================================

struct ExamplesPageView: View {
    @EnvironmentObject var token: TokenLogic
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "examplesPage",
            content: {
                
                VStack(alignment: .leading, spacing: 24) {
                    HStack {// Header stack with home button
                        Text("Fit Your Needs")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    
                    //example sam's story
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sam's Story")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                        
                        Text("Sam is a software engineer that sits in front of his computer for long hours. Sam gets so immersed that they forget to eat or rest.")
                            .font(.body)
                        
                        Text("Here is how Sam uses Elephant as Wellness Reminders")
                            .font(.headline)
                        
                        Text("Mode: Stopwatch")
                            .italic()
                        
                        ChecklistView(items: [
                            ChecklistItem(label: "Take a 10min walk", isChecked: true),
                            ChecklistItem(label: "Grab a coffee", isChecked: false),
                            ChecklistItem(label: "Eat an apple", isChecked: true)
                        ])//checklistview
                    }//vstack sam
                    
                    //Cam Story Vstack
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cam's Story")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                        
                        Text("Cam is a college student that finds it hard to stay on top of class and extracurriculars. Cam wants some motivation to get the tasks done.")
                            .font(.body)
                        
                        Text("Here is how Cam uses Elephant for Task Management")
                            .font(.headline)
                        
                        Text("Mode: Pomodoro")
                            .italic()
                        
                        ChecklistView(items: [
                            ChecklistItem(label: "2 Paragraphs for Political Science Paper", isChecked: true),
                            ChecklistItem(label: "Meet Advisor", isChecked: true),
                            ChecklistItem(label: "Email Follow-Ups", isChecked: false)
                        ])// checklistview
                    }//vstack cam
                }//vstack
                .onAppear(){
                    token.exampleTokenNum = 0 //since it would be weird if we keep token num  when come back
                }
            },//conetent
            backPage: AnyView(ManualView()),
            homePage: AnyView(ContentView())
        )//ManualTemplateView
    }//body
}//ExamplesPageView

// MARK: - ExamplesPageView
// ====================================================
// WidgetSetupPageView
// ----------------------------------------------------
// Page for showing the instruction of how to set
// up widget
// ====================================================
struct WidgetSetupPageView: View {
    // TODO: add vidoe link?
    var body: some View {
        ManualTemplateView(
            currentPageIdentifier: "widgetSetupPage",
            content: {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {// Header stack with home button
                        Text("Add to Widget Bar")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        Spacer()//expands leftward
                        ToHomePageButton()
                        ToSettingsPageButton()
                    }//HStack
                    
                    
                    Text("""
                    (1) Open Notification Center by clicking the date/time in the menu bar of the mac book (Desktop) or swiping left from the right side of the trackpad.
                    (1) Open Notification Center by clicking the date/time in the menu bar of the mac book (Desktop) or swiping left from the right side of the trackpad.
                    (2) Scroll to 'Edit Widgets'.
                    (3) Search for 'ElephantMacApp'.
                    (4) Add and enjoy quick access to your wellness reminders!
                    """)
                    .font(.body)
                    .lineSpacing(5)
                }//Vstack
            }, //content
            backPage: AnyView(ManualView()),
            homePage: AnyView(ContentView())
        )//ManualTemplateView
    }// var body
}//WidgetSetupPageView

#Preview {
    let themeManager = ThemeManager()
    ManualView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}


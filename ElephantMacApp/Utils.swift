//
//  Utils.swift
//  Elephant
//
//  Created by 陸卉媫 on 3/31/25.
//      Contains reuseable components for the app:
//          ElephantConfirmationDialogue: confirmation dialogue that pops up when user presses a button (such as for purchasing)
//          ElephantButton: styled button that allows customization and can be used anywhere for any purpose
//          ElephantTitle: title text
//          ElephantText: text

import SwiftUI

// Elephant confirmation dialogue
// Parameters:
//      title: string, text displayed on button
//      buttonImage: string, name of image displayed on button
//      action: function, what happens once you click on button
//      color: color of button background

struct ElephantConfirmationDialogue: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let title: String
    let message: String
    let confirmButtonText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack{
            Image("mammal-elephant")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            Text(message)
                .font(.title3)
                .fontDesign(.rounded)
            // defaulted to having cancel and confirm options, can be adjusted to have optional parameters if more functionality is needed
            HStack{
                ElephantButton(
                    buttonText: "Cancel",
                    action: onCancel,
                    color: themeManager.curTheme.main_color_1
                )
                ElephantButton(
                    buttonText: "Confirm",
                    action: onConfirm,
                    color: themeManager.curTheme.main_color_2
                )
            }
        }
        .padding()
        .frame(width: 350, height: 200, alignment: .center)
        .cornerRadius(20)
        .background(themeManager.curTheme.background_2)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(themeManager.curTheme.text_2, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.3), radius: 20)
    }
}

// confirmation but with only one button, does nothing on click
struct ElephantPopup: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let title: String
    let message: String
    let onConfirm: ()->Void
    
    var body: some View {
        VStack{
            Image("mammal-elephant")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text(title)
                .font(.title2)
                .fontDesign(.rounded)
                .fontWeight(.bold)
            Text(message)
                .font(.title3)
            HStack{
                ElephantButton(
                    buttonText: "Confirm",
                    action: onConfirm,
                    color: themeManager.curTheme.main_color_2
                )
            }
        }
        .padding()
        .frame(width: 350, height: 200, alignment: .center)
        .cornerRadius(20)
        .background(themeManager.curTheme.background_2)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(themeManager.curTheme.text_2, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.3), radius: 20)
    }
}

// Elephant buttons
// Parameters:
//      buttonText: string, text displayed on button
//      buttonImage: string, name of image displayed on button
//      action: function, what happens once you click on button
//      color: color of button background
//      textColor: color of button text

struct ElephantButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let buttonText: String
    let buttonImage: String?
    let action: () -> Void
    let color: Color?
    let textColor: Color?
    
    init(
        buttonText: String,
        buttonImage: String? = "mammal-elephant",
        action: @escaping () -> Void,
        color: Color? = nil,
        textColor: Color? = nil) {
            self.buttonText = buttonText
            self.buttonImage = buttonImage
            self.textColor = textColor
            self.action = action
            self.color = color
        }
        
    
    var body: some View{
        Button (action: action) {
            Text("\(buttonText)")
                .fontWeight(.bold)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .padding(13)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color ?? themeManager.curTheme.main_color_2, lineWidth: 2)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(textColor ?? themeManager.curTheme.text_2, lineWidth: 2)
                )
        }
        .background(color ?? themeManager.curTheme.main_color_2)
        .cornerRadius(20)
//        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_2))
         .foregroundColor(themeManager.curTheme.text_2)
        .buttonBorderShape(.capsule)
        .buttonStyle(PlainButtonStyle())
    }
}

// Elephant title
// Parameters:
//      displayText: string, title text displayed

struct ElephantTitle: View {
    let displayText: String
    
    var body: some View {
        Text("\(displayText)")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .fontWeight(.bold)
            .padding()
            .frame(alignment: .center)
    }
}

// Elephant text
// Parameters:
//      displayText: string, default text displayed

struct ElephantText: View {
    let displayText: String
    
    var body: some View {
        Text("\(displayText)")
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .font(.headline)
            .padding(10)
    }
}


// Button to settings page
// Parameters: none

struct ToSettingsPageButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: SettingsView()) {
            Text("⛭")
                .font(.system(size: 25).weight(.bold))
                .frame(width: 40, height: 40)
                .background(themeManager.curTheme.main_color_2)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(themeManager.curTheme.text_2)
        .accessibilityIdentifier("settingsPageButton")
    }
}

// Button to manual page
// Parameters: none

struct ToManualPageButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: ManualView()) {
            Text("?")
                .font(.system(size: 25).weight(.bold))
                .frame(width: 40, height: 40)
                .background(themeManager.curTheme.main_color_2)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(themeManager.curTheme.text_2)
        .accessibilityIdentifier("manualPageButton")
    }
}

// Button to homepage
// Parameters: none

struct ToHomePageButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: ContentView()) {
            Image(systemName: "house.fill")
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(themeManager.curTheme.main_color_2)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(themeManager.curTheme.text_2)
        .accessibilityIdentifier("homeButton")
    }
}

struct ToMyAvatarsButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: MyAvatarView()) {
            Image(systemName: "star.circle.fill")
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(themeManager.curTheme.main_color_2)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(themeManager.curTheme.text_2)
        .accessibilityIdentifier("toMyAvatarsButton")
    }
}

struct TokenDisplay: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tokenLogic: TokenLogic
    
    var body: some View {
        let tokenNum = tokenLogic.tokenNum
        Image(systemName: "dollarsign.circle.fill")
            .font(.title2)
            .frame(width: 40, height: 40)
            .symbolRenderingMode(.palette)
            .foregroundStyle(themeManager.curTheme.text_2, themeManager.curTheme.main_color_2)
//            .clipShape(Circle())
            .padding(-20)
        ElephantText(displayText: "\(tokenNum)")
    }
}

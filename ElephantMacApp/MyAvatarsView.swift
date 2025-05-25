//
//  MyAvatarsView.swift
//  Elephant
//
//  Created by 陸卉媫 on 5/7/25.
//

import SwiftUI

struct MyAvatarView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var showConfirmation = false
    @State private var selectedAvatar: String? = nil
    
    var body: some View {
        ZStack{
            
            VStack {
                ScrollView{
                    HStack {
                        Text("My Avatars")
                            .fontWeight(.bold)
                            .padding()
                            .frame(alignment: .center)
                            .font(.system(size: 28, design: .rounded).weight(.bold))
                        Spacer()
                        TokenDisplay()
                        ToHomePageButton() // Button to homepage
                        ToSettingsPageButton() // Button to settings page
                        ToManualPageButton() // Button to manual page
                    }
                    DisplayAllItems(action: { avatar in
                        selectedAvatar = avatar
                        showConfirmation = true
                    })
                }
                .padding()
            }
            .frame(width: 400, height: 500)
            .background(themeManager.curTheme.background_1)
            .preferredColorScheme(themeManager.Mode ? .dark : .light)
            
            if(showConfirmation) {
                ElephantConfirmationDialogue(
                    title: "Change to this avatar?",
                    message: "Do you want to change to this avatar?",
                    confirmButtonText: "Yes!",
                    onConfirm: {
                        showConfirmation = false
                        UserDefaults.standard.set(selectedAvatar, forKey: "curAvatar")
                    },
                    onCancel: {
                        showConfirmation = false
                    })
                .zIndex(1)
            }
        }
        .accessibilityIdentifier("myAvatarsPage")
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
//        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.background_1))
        .foregroundColor(themeManager.curTheme.text_1)
    }
    
}

struct DisplayItemBlock : View {
    @EnvironmentObject var themeManager: ThemeManager
    let item: ShopItem
    let action: ((String)->Void)
    
    var body: some View {
        VStack {
            Button(action: {
                action(item.id)
            }) {
                    Image("\(item.id)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
            }
            .accessibilityIdentifier("myAvatarButton_\(item.id)")
            .cornerRadius(10)
            .padding(5)
            .background(themeManager.curTheme.main_color_2)
            .cornerRadius(10)
            Text("\(item.name)")
                // .font(.system(size: 16, weight: .light))
                .frame(width: 100, height: 20)
                .font(.system(size: 16, design: .rounded).weight(.bold))
        }
    }
}

struct DisplayAllItems: View {
    @EnvironmentObject var themeManager: ThemeManager
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let action: ((String)->Void)
    
    var body: some View {
        let purchasedAvatars = UserDefaults.standard.stringArray(forKey: "purchasedAvatars") ?? ["mammal-elephant"]
        let allDisplayingAvatars: [ShopItem] = allCollectibles.filter{purchasedAvatars.contains($0.id)}
        VStack{
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(allDisplayingAvatars) { avatar in
                        DisplayItemBlock(item: avatar, action: action)
                            .padding(5)
                    }
                }
            }
        }
    }
}

#Preview {
    let themeManager = ThemeManager()
    MyAvatarView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

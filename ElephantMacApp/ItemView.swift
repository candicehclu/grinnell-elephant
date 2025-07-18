//
//  ItemView.swift
//  Elephant
//
//  Created by 陸卉媫 on 4/14/25.
//
//## File Description: This file defines the item view. The view contains name and image of the chosen collectible, and a purchase button that will react differently depending on whether user has purchased the item and remaining tokens.
//
//## Components:
//- ItemView: A reusable SwiftUI template that generates a item purchase page when clicked. It is accessible through clicking on the item listings on the main shop page.

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tokenLogic: TokenLogic
    
    let item: ShopItem
    @State var showConfirmation = false
    @State var showNotEnoughTokens = false
    @State var showUserAlreadyHave = false
    @State var showPurchaseConfirmation = false
    
    var body: some View {
        var purchasedAvatars = UserDefaults.standard.stringArray(forKey: "purchasedAvatars")
        let tokenNum = tokenLogic.tokenNum

        ZStack{
            ScrollView{
                VStack {
                    HStack {
                        NavigationLink(destination: ShopMainPageView()) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(themeManager.curTheme.main_color_2)
                                .frame(width: 50, height: 30)
                                .overlay(
                                    Text("Back").foregroundColor(themeManager.curTheme.text_2))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(10)
                        .accessibilityIdentifier("itemButton_back_\(item.id)")
                        
                        Spacer()
                        TokenDisplay()
                        ToMyAvatarsButton()
                        ToHomePageButton() // Button to homepage
                        ToSettingsPageButton() // Button to settings page
                        // ToManualPageButton() // Button to manual page
                    }
                    Text("\(item.name)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    ZStack{
                        Circle()
                            .foregroundStyle(themeManager.curTheme.background_1)
                            .frame(width: 250)
                        Image(item.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
                    ElephantText(displayText: "Price: \(item.price) tokens")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding(.bottom, 10)

                    Button(action: {
                        // if enough tokens show confirmation, otherwise show not enough tokens
                        if (purchasedAvatars!.contains(item.id)) {
                            showUserAlreadyHave = true
                        } else {
                            if (tokenNum >= item.price) {
                                showConfirmation = true
                            } else {
                                showNotEnoughTokens = true
                            }
                        }                        
                    }){
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(themeManager.curTheme.main_color_2)
                            .frame(width: 150, height: 50)
                            .overlay{
                                Text("Buy")
                                    .fontWeight(.bold)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(15)
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .cornerRadius(20)
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_2))
                    .foregroundColor(themeManager.curTheme.text_2)
                    .buttonBorderShape(.capsule)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .accessibilityIdentifier("itemButton_price_\(item.id)")
                }
            }
            .padding(10)
            .frame(width: 400, height: 500)
            .background(themeManager.curTheme.background_1)
            // .preferredColorScheme(themeManager.Mode ? .dark : .light)
            
            if(showConfirmation) {
                ElephantConfirmationDialogue(
                    title: "Purchase?",
                    message: "Purchase this item for \(item.price) tokens?",
                    confirmButtonText: "Yes!",
                    onConfirm: {
                        showConfirmation = false
                        // update purchased avatars
                        purchasedAvatars!.append(item.id)
                        UserDefaults.standard.set(purchasedAvatars, forKey: "purchasedAvatars")
                        // update token
                        tokenLogic.buySubtractToken(cost: item.price)
                        showPurchaseConfirmation = true
                    },
                    onCancel: {
                        showConfirmation = false
                    })
                .zIndex(1)
            }
            
            if (showNotEnoughTokens) {
                ElephantPopup(
                    title: "Not enough tokens : (",
                    message: "Complete wellness tasks to earn tokens!",
                    onConfirm: {
                        showNotEnoughTokens = false
                    }
                )
                .zIndex(1)
            }
            
            if (showUserAlreadyHave) {
                ElephantPopup(
                    title: "Avatar already purchased",
                    message: "We see how much you love this item!",
                    onConfirm: {
                        showUserAlreadyHave = false
                    }
                )
                .zIndex(1)
            }
            
            if (showPurchaseConfirmation) {
                ElephantPopup(
                    title: "Avatar successfully purchased",
                    message: "Go ahead and give your timer a new look!",
                    onConfirm: {
                        showPurchaseConfirmation = false
                    }
                )
                .zIndex(1)
            }
        }
        .accessibilityIdentifier("itemView_\(item.id)")
        // .preferredColorScheme(themeManager.Mode ? .dark : .light)
//        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.background))
        .foregroundColor(themeManager.curTheme.text_1)
    }
    
}
#Preview {
    let themeManager = ThemeManager()
    ItemView(item: ShopItem(id: "mammal-lion", name: "Lion", price: 10))
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

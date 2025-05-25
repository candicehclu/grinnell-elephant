//
//  ShopMainPageView.swift
//  Elephant
//
//  Created by 陸卉媫 on 3/14/25.
//
//## File Description: This file defines the shop main view. The view lists all available collectibles based on which pack the collectible belongs to.
//
//## Components:
//- ShopMainPageView: Accessible through clicking on the button on the content view page.

import SwiftUI

struct ShopMainPageView: View {
    
    @AppStorage("curPalette") var curPalette: String = "defaultElephant"
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject var tokenLogic: TokenLogic
    
    // only initialize it once
    init() {
        if (UserDefaults.standard.array(forKey: "purchasedAvatars") == nil) {
            UserDefaults.standard.set(["mammal-elephant"], forKey: "purchasedAvatars")
        }
    }
    
    var body: some View {
        VStack {
            ScrollView{
                NavigationStack{
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Shop")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .padding()
                                .padding(.leading, 5)
                                .frame(alignment: .center)
                            Spacer()
                            TokenDisplay()
                            ToMyAvatarsButton()

                            ToHomePageButton() // Button to homepage
                            ToSettingsPageButton() // Button to settings page
                            ToManualPageButton() // Button to manual page
                        }
                        .padding([.top, .trailing], 15)
                        
                        PackBlock(pack: mammals, packName: "Mammal")
                        PackBlock(pack: marines, packName: "Marine")
                        PackBlock(pack: birds, packName: "Bird")
                        PackBlock(pack: monsters, packName: "Monster")
                        PackBlock(pack: unicorns, packName: "Unicorn")
                        PackBlock(pack: magic, packName: "Magic")
                    }
                }
                .frame(alignment: .leading)
                .padding(.bottom, 15)
            }
        }
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.curTheme.background_1)
        .accessibilityIdentifier("shopMainPageView")
    }
}

#Preview {
    // theme manager
    let themeManager = ThemeManager()
    // themeManager.setTheme(named: "blackWhite")
    // themeManager.setTheme(named: "defaultElephant")
    return ShopMainPageView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

struct ShopItemBlock : View {
    let item: ShopItem
    
    var body: some View {
        NavigationLink(destination: ItemView(item: item))
        {
            Image("\(item.id)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
        }.accessibilityIdentifier("shopButton_\(item.id)")
    }
}

struct PackBlock : View {
    let pack: Array<ShopItem>
    let packName: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Text("\(packName) Pack")
            // .font(.headline)
            .padding(.leading, 20)
            .padding(.bottom, -8)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
        
        ScrollView(.horizontal){
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(themeManager.curTheme.main_color_1)
                    .frame(width: CGFloat(pack.count)*130, height: 130)
                    
                HStack{
                    ForEach(pack) { item in
                        ShopItemBlock(item:item)
                    }
                }
                .padding(.leading, -5)
            }
        }
        .padding(.leading, 20)
        .padding(.vertical, 10)
        .accessibilityIdentifier("shopView_scroll_\(packName)")
    }
}

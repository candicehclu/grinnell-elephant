//
//  ColorSettings.swift
//  Elephant
//
//  Created by 陸卉媫 on 4/15/25.
//

// resources: https://medium.com/@katramesh91/effortless-theming-in-swiftui-mastering-multiple-themes-and-best-practices-061113be6d3d
// grinnell theme: https://coolors.co/779ab8-9c3b2a-d8d5d0-92b848-73440a-c1b1a1-fa9a18
// thinking about using some variations of this palette: https://coolors.co/cfdbd5-e8eddf-f5cb5c-242423-333533

import SwiftUI

// data structure for each theme
protocol ThemeProtocol {
    var main_color_1: Color {get}
    var main_color_2: Color {get}
    var main_color_3: Color {get}
    var background_1: Color {get}
    var background_2: Color {get} // contrast background_1
    var text_1: Color {get} // contrast background_1
    var text_2: Color {get} // contrast background_2

//    var background: Color {get}
//    var shadow_1: Color {get}
//    var shadow_2: Color {get}
    
//    func textColor(for background: Color, isDarkMode: Bool) -> Color
//    var primaryTextColor: Color {get}
//    var secondaryTextColor: Color {get}
}

let allThemes = [
    "Elephant": "default",
    "Benny": "benny",
    "Black and White": "blackWhite",
    "Grinnell": "grinnell",
    "Matcha": "matcha",
]

class ThemeManager: ObservableObject {
    //sets the curThemeKey to default theme
    @AppStorage("curTheme") var curThemeKey: String = "defaultElephant" {
            didSet {
                objectWillChange.send()
            }
        }
    
    //sets the display mode to light mode by default
    @AppStorage("displayMode") var Mode: Bool = false{
        didSet{
            objectWillChange.send()
        }
    }
    
    // takes the string name of theme protocol and return the correct settings
    var curTheme: ThemeProtocol {
            switch curThemeKey {
                case "blackWhite":
                    return BlackWhite()
                case "benny":
                    return Benny()
                case "grinnell":
                    return Grinnell()
                case "matcha":
                    return Matcha()
                default:
                    return DefaultElephant()
            }
        }
        
    // function to set global theme
    func setTheme(named name: String) {
        curThemeKey = name
    }
    
    // Add to ThemeManager class
    var currentThemeName: String {
        return curThemeKey
    }

    //gets appropriate color for text based on background and current mode
//    func textColor(for background: Color) -> Color {
//        // Checks current state of mode
//        if Mode {
//            // For light backgrounds in dark mode, use black text
//            if background == curTheme.background && Mode {
//                return .black
//            }
//            //for dark backgrounds in dark mode, use white text
//            if background == curTheme.main_color_1{
//                return .white
//            }
//            // For other backgrounds in dark mode, use white text
//            return .white
//        } else {
//            // In light mode
//            // For dark backgrounds, use white text
//            if background == curTheme.main_color_2 && curThemeKey == "benny" {
//                return .white
//            }
//            // For light backgrounds, use black text
//            return .black
//        }
//    }
    
    //toggles between light/dark mode
    func toggleMode(){
        Mode.toggle()
    }
    

}//end of ThemeManager

//
////default settings for text based on defaultTheme
//extension ThemeProtocol{
//    func textColor(for background: Color, isDarkMode: Bool) -> Color {
//        if isDarkMode{
//            return .white
//        }else{
//            return .black
//        }
//    }
//    
//    var primaryTextColor: Color {return .primary}
//    var secondaryTextColor: Color {return .secondary}
//}

// color themes
struct DefaultElephant: ThemeProtocol {
    var main_color_1: Color {return Color(red: 255/255, green: 201/255, blue: 185/255)}
    var main_color_2: Color {return Color(red: 193/255, green: 150/255, blue: 109/255)}
    var main_color_3: Color {return Color(red: 76/255, green: 149/255, blue: 108/255)}
    var background_1: Color {return Color(red: 254/255, green: 254/255, blue: 227/255)}
    var background_2: Color {return Color(red: 254/255, green: 254/255, blue: 227/255)}
    var text_1: Color {return Color.black}
    var text_2: Color {return Color.black}
    
//    var primaryTextColor: Color { return Color(red: 50/255, green: 50/255, blue: 50/255)}
//    var secondaryTextColor: Color { return Color(red: 90/255, green: 90/255, blue: 90/255)}
//    
//    //dynamic text re-coloring based on mode
//    func textColor(for background: Color, isDarkMode: Bool) -> Color {
//        if isDarkMode{ //since the mode is in dark mode, we make changes with lighter text
//            return Color(red: 240/255, green: 240/255, blue: 240/255)
//        }else{//since the mode must be in light mode, we make changes to darken the text
//            return Color(red: 40/255, green: 40/255, blue: 40/255)
//        }
//    }
}

// https://coolors.co/7db3c2-f8bb11-bcbfb6-e8eddf-333533
struct Matcha: ThemeProtocol {
    var main_color_1: Color {return Color(hex: "95AC62")}
    var main_color_2: Color {return Color(hex: "67732E")}
    var main_color_3: Color {return Color(hex: "BCBFB6")}
    var background_1: Color {return Color(hex: "FFF9EE")}
    var background_2: Color {return Color(hex: "E8EDDF")}
    var text_1: Color {return Color(hex: "333533")} // contrast background_1
    var text_2: Color {return Color.white} // contrast main_color_2
    
//    var primaryTextColor: Color { return Color(red: 50/255, green: 50/255, blue: 50/255)}
//    var secondaryTextColor: Color { return Color(red: 90/255, green: 90/255, blue: 90/255)}
//
//    //dynamic text re-coloring based on mode
//    func textColor(for background: Color, isDarkMode: Bool) -> Color {
//        if isDarkMode{ //since the mode is in dark mode, we make changes with lighter text
//            return Color(red: 240/255, green: 240/255, blue: 240/255)
//        }else{//since the mode must be in light mode, we make changes to darken the text
//            return Color(red: 40/255, green: 40/255, blue: 40/255)
//        }
//    }
}

// palette: https://coolors.co/779ab8-9c3b2a-d8d5d0-92b848-73440a-c1b1a1-fa9a18
struct Grinnell: ThemeProtocol {

    var main_color_1: Color {return Color(hex: "779AB8")}
    var main_color_2: Color {return Color(hex: "9C3B2A")}
    var main_color_3: Color {return Color(hex: "FA9A18")}
    var background_1: Color {return Color(hex: "D8D5D0")}
    var background_2: Color {return Color(hex: "92B848")} // contrast background_1
    var text_1: Color {return Color(hex: "73440A")} // contrast background_1
    var text_2: Color {return Color.white} // contrast background_2
     // var shadow: Color {return Color(hex: "#FA9A18")} // contrast-ish background_2

}

struct BlackWhite: ThemeProtocol {
    var main_color_1: Color { return Color(red: 221/255, green: 221/255, blue: 221/255) }
    var main_color_2: Color { return Color(red: 188/255, green: 184/255, blue: 177/255) }
    var main_color_3: Color { return Color(red: 138/255, green: 129/255, blue: 124/255) }
    var background_1: Color { return Color(red: 244/255, green: 243/255, blue: 238/255) }
    var background_2: Color { return Color(red: 244/255, green: 243/255, blue: 238/255) }
    var text_1: Color      { return Color(red: 70/255, green: 63/255, blue: 58/255) }
    var text_2: Color      { return Color.black }
    
//    //High contrast text for black and white theme
//    var primaryTextColor: Color { return .black}
//    var secondaryTextColor: Color { return Color(white: 0.3)}
//    
//    //dynamic text re-coloring based on mode
//    func textColor(for background: Color, isDarkMode: Bool) -> Color {
//        if isDarkMode{ //since the mode is in dark mode, we make changes with lighter text
//            return .white
//        }else{//since the mode must be in light mode, we make changes to darken the text
//            return .black
//        }
//    }
}

struct Benny: ThemeProtocol {
    var main_color_1: Color {return Color(hex: "4B90CD")}
    var main_color_2: Color {return Color(hex: "094F98")}
    var main_color_3: Color {return Color(hex: "B8D2F0")}
    var background_1: Color {return Color(hex: "F3A3B5")}
    var background_2: Color {return Color(hex: "F0CC34")}
    var text_1: Color {return Color.black}
    var text_2: Color {return Color(hex: "B8D2F0")}
    
    
//    var primaryTextColor: Color { return Color(hex: "19171A")} //dark gray color
//    var secondaryTextColor: Color { return Color(hex: "094F98")} //dark blue color
    
//    //dynamic text re-coloring based on mode
//    func textColor(for background: Color, isDarkMode: Bool) -> Color {
//        if isDarkMode{
//            if background == self.background{ //pink background in dark mode needs even darker text
//                return Color(hex: "19171A")
//            }
//            // we'll want lighter text for blue or deeper color backgrounds
//            if background == self.main_color_1 || background == self.main_color_2 || background == self.main_color_3 {
//                return .white
//            }
//            return .white //defaults to white text
//        }else{//we're in light mode
//            if background == self.background { //on pink
//                return Color(hex: "19171A")
//            }
//            if background == self.main_color_2{//on dark blue
//                return .white
//            }
//            return Color(hex: "19171A")//defaults to dark text
//        }
//    }
}

// default color palette
//struct DefaultColors {
//    static let main_color_1 = Color(red: 255/255, green: 201/255, blue: 185/255)
//    static let main_color_2 = Color(red: 193/255, green: 150/255, blue: 109/255)
//    static let main_color_3 = Color(red: 76/255, green: 149/255, blue: 108/255)
//    static let background = Color(red: 254/255, green: 254/255, blue: 227/255)
//    static let shadow_1 = Color(red: 116/255, green: 79/255, blue: 42/255)
//    static let shadow_2 = Color(red: 44/255, green: 110/255, blue: 73/255)
//}

//converts Color to hexcode colors
extension Color{
    init(hex: String){
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF)/255.0
        let green = Double((rgb >> 8) & 0xFF)/255.0
        let blue = Double(rgb & 0xFF)/255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


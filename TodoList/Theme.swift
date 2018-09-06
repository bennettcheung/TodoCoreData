//
//  Theme.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import UIKit

class Theme: NSObject {
  
  //Theme related constants
  private let themePlist = "Theme"
  private let themeArrayKey = "Theme"
  private let selectedThemeKey = "SelectedTheme"
  private let fontColorKey = "FontColor"
  private let backgroundColorKey = "BackgroundColor"
  var themeDictionary:NSMutableDictionary?
  static let shared = Theme.init()
  
  private override init() {
    super.init()
    if let path = Bundle.main.path(forResource: themePlist, ofType: "plist"){
      themeDictionary = NSMutableDictionary(contentsOfFile: path)
    }
  }
  
  func getSelectedTheme()->Int {
      
      guard let themeDictionary = themeDictionary else{
        print("Dictionary is not populated")
        return 0
      }

      guard let savedThemeIndex = themeDictionary[selectedThemeKey] as? Int else{
        print("Saved theme is not correct")
        return 0
      }
      return savedThemeIndex
    
  }

  func getBackground()->UIColor {
    
    guard let themeDictionary = themeDictionary else{
      print("Dictionary is not populated")
      return UIColor.white
    }
    
    if let themeArray = themeDictionary[themeArrayKey] as? [Dictionary<String, String>]{
      let savedThemeIndex = getSelectedTheme()
      
      let selectedTheme = themeArray[savedThemeIndex]
      if let backgroundColor = selectedTheme[backgroundColorKey]{
        return UIColor.init(hex: backgroundColor)
      }
    }
    return UIColor.white
  }
  
  func saveTheme(theme: Int){
    guard let themeDictionary = themeDictionary else{
      return
    }
    themeDictionary.setValue(theme, forKey: selectedThemeKey)
    if let path = Bundle.main.path(forResource: themePlist, ofType: "plist"){
      NSMutableDictionary(dictionary: themeDictionary).write(toFile: path, atomically: true)
    }
  }
  
}


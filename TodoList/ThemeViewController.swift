//
//  ThemeViewController.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {
  @IBOutlet weak var themePickerView: UIPickerView!
  let theme = ["Dark", "Light"]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      themePickerView.delegate = self
      themePickerView.dataSource = self
      themePickerView.selectRow(Theme.shared.getSelectedTheme(), inComponent: 0, animated: true)
    }

  @IBAction func saveTheme(_ sender: Any) {
    Theme.shared.saveTheme(theme: themePickerView.selectedRow(inComponent: 0))
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ThemeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return theme.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return theme[row]
  }
  
  
}

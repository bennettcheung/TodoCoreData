//
//  DetailViewController.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate{
  func saveDetail()
}

class DetailViewController: UIViewController {

  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var priorityTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var completedSwitch: UISwitch!
  
  var delegate:DetailViewControllerDelegate?
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail = detailItem {
      if let title = titleTextField,
        let description = descriptionTextField,
        let priority = priorityTextField {
        title.text = detail.title
        description.text = detail.todoDescription
        priority.text = detail.priorityNumber.description
        completedSwitch.setOn(detail.isCompleted, animated: true)
      }
      setTheme()
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }


  var detailItem: ToDo? {
    didSet {
        // Update the view.
        configureView()
    }
  }

  // Mark: IBActions
  @IBAction func completedChanged(_ sender: Any) {
    detailItem?.isCompleted = completedSwitch.isOn
    if let delegate = self.delegate{
      delegate.saveDetail()
    }
  }
  
}
extension DetailViewController{
  func setTheme(){
    self.view.backgroundColor = Theme.shared.getBackground()
  }
}

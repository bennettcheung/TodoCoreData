//
//  DetailViewController.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var priorityTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail = detailItem {
      if let title = titleTextField,
        let description = descriptionTextField,
        let priority = priorityTextField {
        title.text = detail.title
        description.text = detail.todoDescription
        priority.text = detail.priorityNumber.description
      }
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var detailItem: ToDo? {
    didSet {
        // Update the view.
        configureView()
    }
  }


}


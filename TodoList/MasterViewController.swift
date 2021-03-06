//
//  MasterViewController.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil
  private let todoTitleDefault = "TodoDefaultTask"
  private let todoDescriptionDefault = "TodoDefaultDescription"
  private let todoPriorityDefault = "TodoDefaultPriority"


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    navigationItem.leftBarButtonItem = editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    setupUserDefaultValues()
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  func setupUserDefaultValues(){
    //only save the user defaults if they are not already there
    guard let _ = UserDefaults.standard.value(forKey: todoTitleDefault) as? String else{
      UserDefaults.standard.setValue("Default title", forKey: todoTitleDefault)
      UserDefaults.standard.setValue("Default description", forKey: todoDescriptionDefault)
      UserDefaults.standard.setValue(1, forKey: todoPriorityDefault)
      return
    }
  }

  @objc
  func insertNewObject(_ sender: Any) {
    
    let alert = UIAlertController(title: "Todo item", message: "Please enter the details:", preferredStyle: .alert)
    alert.addTextField(configurationHandler: { textField in
      if let defaultTitle = UserDefaults.standard.value(forKey: self.todoTitleDefault) as? String {
        textField.text = defaultTitle
      }
    })
    alert.addTextField(configurationHandler: { textField in
      if let defaultDescription = UserDefaults.standard.value(forKey: self.todoDescriptionDefault) as? String {
        textField.text = defaultDescription
      }
    })
    alert.addTextField(configurationHandler: { textField in
      if let defaultPriority = UserDefaults.standard.value(forKey: self.todoPriorityDefault) as? Int {
        textField.text = defaultPriority.description
      }
      textField.keyboardType = UIKeyboardType.numberPad
    })
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      
      guard let title = alert.textFields?[0].text else{
        print("Can't get title")
        return
      }
      guard let description = alert.textFields?[1].text else{
        print("Can't get description")
        return
      }
      guard let priority = alert.textFields?[2].text else{
        print("Can't get priority")
        return
      }
      let context = self.fetchedResultsController.managedObjectContext
      let newToDo = ToDo(context: context)
      
      // If appropriate, configure the new managed object.
      newToDo.title = title
      newToDo.todoDescription = description
      newToDo.priorityNumber = Int16(priority) ?? 0
      
      // Save the context.
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(alert, animated: true)
    

  }
  

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
        let object = fetchedResultsController.object(at: indexPath)
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let todo = fetchedResultsController.object(at: indexPath)
    configureCell(cell, withTodo: todo)
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let context = fetchedResultsController.managedObjectContext
        context.delete(fetchedResultsController.object(at: indexPath))
            
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
  }

  func configureCell(_ cell: UITableViewCell, withTodo todo: ToDo) {
    cell.textLabel!.text = todo.title
    cell.detailTextLabel?.text = todo.todoDescription
  }

  // MARK: - Fetched results controller

  var fetchedResultsController: NSFetchedResultsController<ToDo> {
      if _fetchedResultsController != nil {
          return _fetchedResultsController!
      }
      
      let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
      
      // Set the batch size to a suitable number.
      fetchRequest.fetchBatchSize = 20
      
      // Edit the sort key as appropriate.
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
      
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      // Edit the section name key path and cache name if appropriate.
      // nil for section name key path means "no sections".
      let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
      aFetchedResultsController.delegate = self
      _fetchedResultsController = aFetchedResultsController
      
      do {
          try _fetchedResultsController!.performFetch()
      } catch {
           // Replace this implementation with code to handle the error appropriately.
           // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
           let nserror = error as NSError
           fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
      
      return _fetchedResultsController!
  }    
  var _fetchedResultsController: NSFetchedResultsController<ToDo>? = nil

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
      switch type {
          case .insert:
              tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
          case .delete:
              tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
          default:
              return
      }
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      switch type {
          case .insert:
              tableView.insertRows(at: [newIndexPath!], with: .fade)
          case .delete:
              tableView.deleteRows(at: [indexPath!], with: .fade)
          case .update:
              configureCell(tableView.cellForRow(at: indexPath!)!, withTodo: anObject as! ToDo)
          case .move:
              configureCell(tableView.cellForRow(at: indexPath!)!, withTodo: anObject as! ToDo)
              tableView.moveRow(at: indexPath!, to: newIndexPath!)
      }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
  }

  /*
   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
   func controllerDidChangeContent(controller: NSFetchedResultsController) {
       // In the simplest, most efficient, case, reload the table view.
       tableView.reloadData()
   }
   */

}


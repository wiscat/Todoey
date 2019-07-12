//
//  CategoryViewController.swift
//  Todoey
//
//  Created by  oleg p on 11/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<RCategory>? // [RCategory]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "-"
//        cell.delegate = self
        cell.backgroundColor = UIColor.randomFlat
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        saveItems()
        
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
//            let category = Category(context: self.context)
            let category = RCategory()
            category.name = textField.text!
            
//            self.categoryArray.append(category) // MyItem(text: textField.text!))
            
            self.save(category: category)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "Create new item"
            textField = alerTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: RCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
//    func saveCategories() {
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//
//        tableView.reloadData()
//    }
    
    func loadCategories() { //_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        categoryArray = realm.objects(RCategory.self)
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print(error)
            }
        }
    }
}

//extension CategoryViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            print("delete")
//
//            if let category = self.categoryArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(category)
//                    }
//                } catch {
//                    print(error)
//                }
//
////                self.tableView.reloadData()
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
//}

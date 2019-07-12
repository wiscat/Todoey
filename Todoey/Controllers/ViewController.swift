//
//  ViewController.swift
//  Todoey
//
//  Created by  oleg p on 10/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var itemArray: Results<RItem>? // [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: RCategory? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(dataFilePath)
        
//        if let value = defaults.value(forKey: "TodoItemArray") as? [Item] {
//            itemArray = value
//        }
//        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        
//        tableView.cellForRow(at: indexPath)?.accessoryType =
//            tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            print(textField.text!)
            
            if let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = RItem() // context: self.context)
                        item.title = textField.text!
                        category.items.append(item)
                    }
                } catch {
                    print(error)
                }
                
//                item.done = false
//                item.parentCategory = self.selectedCategory
            }
//            self.itemArray.append(item) // MyItem(text: textField.text!))
            
//            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "Create new item"
            textField = alerTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems() {
////        let encoder = PropertyListEncoder()
//
//        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
//            try context.save()
//        } catch {
//            print(error)
//        }
//
//        //            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
//
//        tableView.reloadData()
//    }
    
//    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil) {
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            if let items = try? decoder.decode([Item].self, from: data) {
//                itemArray = items
//            }
//
//        }
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
        
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        let compountPredicate = predicate != nil ? NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, categoryPredicate]) : categoryPredicate
//
//        request.predicate = compountPredicate
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.itemArray?[indexPath.row] {
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

extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
////        request.predicate = predicate
//
//        let sortDesc = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDesc]
//
//        loadItems(request, predicate)

//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//
//        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


//
//  ViewController.swift
//  Todoey
//
//  Created by  oleg p on 10/07/2019.
//  Copyright © 2019  oleg p. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
//        if let value = defaults.value(forKey: "TodoItemArray") as? [Item] {
//            itemArray = value
//        }
//        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType =
//            tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            print(textField.text!)
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item) // MyItem(text: textField.text!))
            
            self.saveItems()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "Create new item"
            textField = alerTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
        
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print(error)
        }
        
        //            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
        
        tableView.reloadData()
    }
    
    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil) {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            if let items = try? decoder.decode([Item].self, from: data) {
//                itemArray = items
//            }
//
//        }
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        let compountPredicate = predicate != nil ? NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, categoryPredicate]) : categoryPredicate
        
        request.predicate = compountPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
}

extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
//        request.predicate = predicate
        
        let sortDesc = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDesc]
        
        loadItems(request, predicate)
        
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


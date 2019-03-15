//
//  ViewController.swift
//  Todoey
//
//  Created by Juliet Seidel on 31.01.19.
//  Copyright © 2019 Juliet Seidel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
   
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
     @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    
    override func viewWillApper(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.colour else { fatalError()}
            
            updateNavBar(withHexCode : colourHex)
        }
        override func viewWillDissapear(_ animated: Bool) {
            updateNavBar (withHexCode: "1D9BF6")
        }
    
// MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
    
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what wii happen once the user clicks the Add Item Button on our alert
            
         
            let newIem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK - Model Manipulation Methods

func saveItems() {
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        context.save()
    } catch {
      
    }
    
    self.tableView.reloadData()
}

func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
    let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error Decoding item array, \(error")
        }
    }
}

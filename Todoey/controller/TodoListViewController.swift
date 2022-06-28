//
//  ViewController.swift
//  Todoey
//
//  Created by Hrutik Mhatre on 27/06/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
     
        
       
        
        
        loadItems()
        
        
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]
//        {
//            itemArray = items
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
        
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
  
        SaveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       
        
    }
    // add new items
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title :"Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:"Add Item",style: .default) {
            (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.SaveItem()
         
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func SaveItem(){
        
        
        do{
            
            try context.save()
        }catch{
            print("Error saving context.................\(error)")
    }
        self.tableView.reloadData()
    }
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
            
        }
        catch{print("Error fetching data\(error)")
            
        }
        
    }
}


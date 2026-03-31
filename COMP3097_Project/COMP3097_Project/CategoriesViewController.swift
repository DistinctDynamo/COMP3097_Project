//
//  CategoriesViewController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-02-03.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddCategoryDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories:[Category]?
    //var listOfProducts:[[Product]]=[]
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var listOfCategories: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listOfCategories.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        listOfCategories.delegate=self
        listOfCategories.dataSource=self
        
        fetchCategories()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return self.categories?.count ?? 0
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as UITableViewCell
        let currentCategory = self.categories![indexPath.row]
        
        cell.textLabel?.text = currentCategory.name
        return cell
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        self.categories?[indexPath.row]
        print(indexPath.row)
        performSegue(withIdentifier:"viewAddProducts", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)->UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title:"Delete") {
            (action, view, completionHandler) in
            
            let categoryToRemove = self.categories![indexPath.row]
            
            self.context.delete(categoryToRemove)
            
            do{
               try self.context.save()
            }catch{
                
            }
            self.fetchCategories()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func didAddCategory(_ categoryName: String) {
        let newCategory = Category(context: self.context)
        newCategory.name = categoryName
        do{
            try self.context.save()
            DispatchQueue.main.async {
                self.listOfCategories.reloadData()
            }
        }catch{
            
        }
        self.fetchCategories()
        
        //listOfProducts.append([])
    }
    
    func fetchCategories(){
        do{
            self.categories = try context.fetch(Category.fetchRequest())
            DispatchQueue.main.async {
                self.listOfCategories.reloadData()
            }
        }catch{
            
        }
    }
    
  //  func didUpdateProducts(_ products: [Product], forCategoryAt index: Int) {
  //      listOfProducts[index] = products
  //  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue identifier:", segue.identifier ?? "nil")

        switch segue.identifier {
        case "viewAddProducts":
            if let dest = segue.destination as? addProductController {
                
            }

        case "viewAddCategory":
            if let dest = segue.destination as? addCategoryController {
                dest.delegate = self
            }
            
        case "totalsFromCategories":
            if let dest = segue.destination as? TotalsViewController {
                        
            }
        default:
            print("Unknown segue:", segue.identifier ?? "nil")
        }
    }
}

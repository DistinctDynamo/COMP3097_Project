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
    let cellReuseIdentifier = "cell"
    var selectedCategory: Category?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = self.categories![indexPath.row]
        performSegue(withIdentifier: "viewAddProducts", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)->UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title:"Delete") {
            (action, view, completionHandler) in
            
            let categoryToRemove = self.categories![indexPath.row]
            self.context.delete(categoryToRemove)
            
            do {
                try self.context.save()
                self.fetchCategories()
                completionHandler(true)
            } catch {
                self.showAlert(message: "Failed to delete category.")
                completionHandler(false)
            }
            
            self.fetchCategories()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let renameAction = UIContextualAction(style: .normal, title: "Rename") {
            (action, view, completionHandler) in

            let categoryToRename = self.categories![indexPath.row]

            let alert = UIAlertController(
                title: "Rename Category",
                message: "Enter a new category name.",
                preferredStyle: .alert
            )

            alert.addTextField { textField in
                textField.text = categoryToRename.name
                textField.placeholder = "Category name"
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            }

            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let newName = alert.textFields?.first?.text?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
                      !newName.isEmpty else {
                    self.showAlert(message: "Please enter a valid category name.")
                    completionHandler(false)
                    return
                }

                categoryToRename.name = newName

                do {
                    try self.context.save()
                    self.fetchCategories()
                    completionHandler(true)
                } catch {
                    self.showAlert(message: "Failed to rename category.")
                    completionHandler(false)
                }
            }

            alert.addAction(cancelAction)
            alert.addAction(saveAction)

            self.present(alert, animated: true)
        }

        renameAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(actions: [renameAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func didAddCategory(_ categoryName: String) {
        let newCategory = Category(context: self.context)
        newCategory.name = categoryName

        do {
            try self.context.save()
            self.fetchCategories()
        } catch {
            self.showAlert(message: "Failed to add category.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue identifier:", segue.identifier ?? "nil")

        switch segue.identifier {
        case "viewAddProducts":
            if let dest = segue.destination as? addProductController {
                dest.category = selectedCategory
                dest.categoryName = selectedCategory?.name
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

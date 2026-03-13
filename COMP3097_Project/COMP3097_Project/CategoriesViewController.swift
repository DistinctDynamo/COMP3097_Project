//
//  CategoriesViewController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-02-03.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories:[String] = []
    var category:Int = 0
    var listOfProducts:[[Product]]=[]
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var listOfCategories: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listOfCategories.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        listOfCategories.delegate=self
        listOfCategories.dataSource=self
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return self.categories.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableViiew:UITableView, didSelectRowAt indexPath: IndexPath){
        category=indexPath.row
        print(indexPath.row)
        performSegue(withIdentifier:"viewAddProducts", sender: self)
    }
    
    @IBAction func unwindToCategories(_ segue:UIStoryboardSegue){
        if let src = segue.source as? addCategoryController{
            categories.append(src.categoryName)
            listOfProducts.append([])
            print(categories)
            listOfCategories.reloadData()
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "viewAddProducts":
            if let dest = segue.destination as?
                addProductController{
                dest.listOfProducts = listOfProducts[category]
            }
        default:
            print("Unknown segue")
        }
    }

}

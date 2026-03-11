//
//  CategoriesViewController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-02-03.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories:[String] = []
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
        print(indexPath.row)
    }
    
    @IBAction func unwindToCategories(_ segue:UIStoryboardSegue){
        if let src = segue.source as? addCategoryController{
            categories.append(src.categoryName)
            listOfCategories.reloadData()
        }
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  addProductController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-03-13.
//

import UIKit

class addProductController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listOfProducts:[Product]=[]
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentListOfProducts.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        currentListOfProducts.delegate=self
        currentListOfProducts.dataSource=self    }
    
    @IBOutlet weak var currentListOfProducts: UITableView!
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return self.listOfProducts.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as UITableViewCell
        
        return cell
    }
    
    func tableView(_ tableViiew:UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
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

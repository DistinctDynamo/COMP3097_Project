//
//  addCategoryController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-03-10.
//

import UIKit

class addCategoryController: UIViewController {

    var categoryName:String = ""
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addCategoryAction(_ sender: Any) {
        self.categoryName = self.categoryNameField.text ?? ""
        self.dismiss(animated: true){
            print(self.categoryName)
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

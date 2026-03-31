//
//  addCategoryController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-03-10.
//

import UIKit

protocol AddCategoryDelegate: AnyObject {
    func didAddCategory(_ categoryName: String)
}

class addCategoryController: UIViewController {

    var categoryName:String = ""
    weak var delegate: AddCategoryDelegate?
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func addCategoryAction(_ sender: Any) {
        let trimmedName = categoryNameField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if trimmedName.isEmpty {
            showAlert(message: "Please enter a category name")
            return
        }
        
        self.categoryName = trimmedName
        delegate?.didAddCategory(trimmedName)
        dismiss(animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

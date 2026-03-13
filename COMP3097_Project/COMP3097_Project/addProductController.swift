//
//  addProductController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-03-13.
//

import UIKit

protocol AddProductDelegate: AnyObject {
    func didUpdateProducts(_ products: [Product], forCategoryAt index: Int)
}

class addProductController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listOfProducts:[Product]=[]
    var categoryIndex: Int = 0
    weak var delegate: AddProductDelegate?
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var currentListOfProducts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentListOfProducts.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        currentListOfProducts.delegate=self
        currentListOfProducts.dataSource=self    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        return self.listOfProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        let product = listOfProducts[indexPath.row]
        cell.textLabel?.text = "\(product.name) | Qty: \(product.quantity) | $\(product.price)"

        return cell
    }
    
    func tableView(_ tableViiew:UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func addProduct(_ sender: Any) {
        guard let name = nameTextField.text,
              !name.trimmingCharacters(in: .whitespaces).isEmpty
        else{
            showAlert(message: "Please enter a product name.")
            return
        }
        
        guard let priceText = priceTextField.text,
              let price = Double(priceText),
              price >= 0
        else {
            showAlert(message: "Please enter a valid price")
            return
        }
        
        guard let quantityText = quantityTextField.text,
              let quantity = Int(quantityText),
              quantity >= 0
        else {
            showAlert(message: "Please enter a valid quantity")
            return
        }
        
        let newProduct = Product(name: name, quantity: quantity, price: price)
            listOfProducts.append(newProduct)

            delegate?.didUpdateProducts(listOfProducts, forCategoryAt: categoryIndex)

            currentListOfProducts.reloadData()

            nameTextField.text = ""
            priceTextField.text = ""
            quantityTextField.text = ""
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

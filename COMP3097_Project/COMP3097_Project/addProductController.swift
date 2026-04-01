//
//  addProductController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-03-13.
//

import UIKit
import CoreData

//protocol AddProductDelegate: AnyObject {
 //   func didUpdateProducts(_ products: [Product], forCategoryAt index: Int)
//}

class addProductController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listOfProducts:[Product]=[]
    var categoryIndex: Int = 0
    //weak var delegate: AddProductDelegate?
    var category:Category?
    var categoryName:String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var currentListOfProducts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentListOfProducts.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        currentListOfProducts.delegate=self
        currentListOfProducts.dataSource=self
        
        fetchCategory()
        fetchProducts()
    }
    
    func fetchCategory(){
        do{
            let request = Category.fetchRequest() as NSFetchRequest<Category>
            
            let pred = NSPredicate(format: "name == %@", "\(categoryName ?? "")")
            request.predicate = pred
            request.fetchLimit = 1
            
            self.category = try context.fetch(request).first
    
            DispatchQueue.main.async {
                self.currentListOfProducts.reloadData()
            }
        }catch{
            
        }
    }
    
    func fetchProducts(){
        do{
            let request2 = Product.fetchRequest() as NSFetchRequest<Product>
            
            let pred2 = NSPredicate(format: "category.name == %@",  "\(categoryName ?? "")")
            request2.predicate = pred2
            
            self.listOfProducts = try context.fetch(request2
            )
            DispatchQueue.main.async {
                self.currentListOfProducts.reloadData()
            }
        }catch{
            
        }
    }
    
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
              let quantity = Int16(quantityText),
              quantity >= 0
        else {
            showAlert(message: "Please enter a valid quantity")
            return
        }
        
        let newProduct = Product(context: context)
        newProduct.name = name
        newProduct.price = price
        newProduct.quantity = quantity
        
        newProduct.category = category
        
        try! context.save()
    }

}

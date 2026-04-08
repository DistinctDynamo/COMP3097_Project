//
//  TotalsViewController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-02-03.
//

import UIKit
import CoreData

class TotalsViewController: UIViewController {
    
    @IBOutlet weak var totalsStackView: UIStackView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            calculateAndDisplayDynamicCategories()
        }
        
        func calculateAndDisplayDynamicCategories() {
            // 1. Fetch all Categories directly from Core Data
            var fetchedCategories: [Category] = []
            do {
                fetchedCategories = try context.fetch(Category.fetchRequest())
            } catch {
                print("Failed to fetch categories")
                return
            }
            
            // Variables for the Gray Box (Overall Totals)
            var overallTax = 0.0
            var overallGrandTotal = 0.0
            var grayBoxText = "Final Total:\n\n"
            
            // Array of colors to cycle through dynamically
            let boxColors: [UIColor] = [.systemGreen, .systemPurple.withAlphaComponent(0.3), .systemCyan, .systemOrange, .systemRed.withAlphaComponent(0.3), .systemYellow]
            
            // 2. Loop through every single category dynamically
            for (index, category) in fetchedCategories.enumerated() {
                guard let categoryName = category.name else { continue }
                
                var subtotal = 0.0
                var categoryText = "Category: \(categoryName.capitalized)\n\n"
                
                // 3. Fetch Products for this specific category from Core Data
                var categoryProducts: [Product] = []
                let productRequest = Product.fetchRequest() as NSFetchRequest<Product>
                productRequest.predicate = NSPredicate(format: "category == %@", category)
                
                do {
                    categoryProducts = try context.fetch(productRequest)
                } catch {
                    print("Failed to fetch products for \(categoryName)")
                }
                
                // 4. Calculate individual products in this category
                for product in categoryProducts {
                    guard let productName = product.name else { continue }
                    let itemTotal = product.price * Double(product.quantity)
                    subtotal += itemTotal
                    
                
                    categoryText += "\(productName)\t\t\(String(format: "%.2f", product.price)) * \(product.quantity) = \(String(format: "%.2f", itemTotal))\n"
                }
                
                // Calculate category totals
                let tax = subtotal * 0.13
                let grandTotal = subtotal + tax
                
                // Add to overall totals
                overallTax += tax
                overallGrandTotal += grandTotal
                
                // Add to gray box summary
                grayBoxText += "\(categoryName)\t\t\(String(format: "%.2f", grandTotal))\n"
                
                // Finish formatting the colored box text
                categoryText += "\nSubtotal\t\t\(String(format: "%.2f", subtotal))"
                categoryText += "\nTax(0.13)\t\t\(String(format: "%.2f", tax))"
                categoryText += "\nGrand Total\t\t\(String(format: "%.2f", grandTotal))"
                
                // 5. Create a dynamic text view for this category!
                let categoryBox = createTextView(text: categoryText, backgroundColor: boxColors[index % boxColors.count])
                totalsStackView.addArrangedSubview(categoryBox)
            }
            
            // 6. Finish formatting and create the overall Gray Box!
            grayBoxText += "\nTax Total(0.13)\t\t\(String(format: "%.2f", overallTax))"
            grayBoxText += "\nGrand Total\t\t\(String(format: "%.2f", overallGrandTotal))"
            
            let grayBox = createTextView(text: grayBoxText, backgroundColor: .lightGray)
            totalsStackView.addArrangedSubview(grayBox)
        }
        
        // Helper function to dynamically generate your text views in Swift
        func createTextView(text: String, backgroundColor: UIColor) -> UITextView {
            let textView = UITextView()
            textView.isScrollEnabled = false
            textView.sizeToFit()
            textView.text = text
            textView.backgroundColor = backgroundColor
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.isEditable = false
            
            // This makes sure the text view grows to fit its content inside the Stack View!
            textView.isScrollEnabled = false
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            return textView
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//
//  TotalsViewController.swift
//  COMP3097_Project
//
//  Created by Tech on 2026-02-03.
//

import UIKit

class TotalsViewController: UIViewController {
    
    var categories: [String] = []
    var listOfProducts: [[Product]] = []
    
    @IBOutlet weak var category1TextView: UITextView!
    @IBOutlet weak var category2TextView: UITextView!
    @IBOutlet weak var category3TextView: UITextView!
    @IBOutlet weak var overallTotalTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the calculation function as soon as the view loads
        calculateAndDisplayCategories()
    }
    
    func calculateAndDisplayCategories() {
        // 1. Hide all text views initially
        category1TextView.isHidden = true
        category2TextView.isHidden = true
        category3TextView.isHidden = true
        overallTotalTextView.isHidden = true
        
        // Variables to keep track of the OVERALL totals for the gray box
        var overallTax = 0.0
        var overallGrandTotal = 0.0
        var grayBoxText = ""
        
        // 2. Loop through the categories
        for (index, categoryName) in categories.enumerated() {
            if index > 2 { break }
            
            let products = listOfProducts[index]
            var categoryText = ""
            var subtotal = 0.0
            
            // Calculate individual products
            for product in products {
                let itemTotal = product.price * Double(product.quantity)
                subtotal += itemTotal
                categoryText += "\(product.name)\t\t\(String(format: "%.2f", product.price)) X \(product.quantity) = \(String(format: "%.2f", itemTotal))\n"
            }
            
            // Calculate category totals
            let tax = subtotal * 0.13
            let grandTotal = subtotal + tax
            
            // Add to the OVERALL totals
            overallTax += tax
            overallGrandTotal += grandTotal
            
            // Add this category's summary to the gray box text
            grayBoxText += "\(categoryName)\t\t\(String(format: "%.2f", grandTotal))\n"
            
            // Finish formatting the colored box text
            categoryText += "\nSubtotal\t\t\(String(format: "%.2f", subtotal))"
            categoryText += "\nTax(0.13)\t\t\(String(format: "%.2f", tax))"
            categoryText += "\nGrand Total\t\t\(String(format: "%.2f", grandTotal))"
            
            // 3. Put the text into the correct colored box
            if index == 0 {
                category1TextView.text = categoryText
                category1TextView.isHidden = false
            } else if index == 1 {
                category2TextView.text = categoryText
                category2TextView.isHidden = false
            } else if index == 2 {
                category3TextView.text = categoryText
                category3TextView.isHidden = false
            }
        }
        
        // 4. Finish formatting the gray box and display it!
        grayBoxText += "\nTax Total(0.13)\t\t\(String(format: "%.2f", overallTax))"
        grayBoxText += "\nGrand Total\t\t\(String(format: "%.2f", overallGrandTotal))"
        
        overallTotalTextView.text = grayBoxText
        overallTotalTextView.isHidden = false
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

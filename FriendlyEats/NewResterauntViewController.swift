//
//  NewResterauntViewController.swift
//  FriendlyEats
//
//  Created by Alex Logan on 28/11/2017.
//  Copyright © 2017 Firebase. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewResterauntViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet var categoryTextField: UITextField! {
        didSet {
            categoryTextField.inputView = categoryPickerView
        }
    }
    @IBOutlet var cityTextField: UITextField! {
        didSet {
            cityTextField.inputView = cityPickerView
        }
    }
    @IBOutlet var priceTextField: UITextField! {
        didSet {
            priceTextField.inputView = pricePickerView
        }
    }
    
    // MARK: Functions
    override func viewDidLoad(){
        
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
    func fieldsValid() -> Bool {
        return nameTextField.text != "" && categoryTextField.text != "" && cityTextField.text != "" && priceTextField.text != ""
    }
    
    // MARK: Private Views
    private lazy var pricePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var cityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var categoryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private let priceOptions = ["$", "$$", "$$$"]
    private let cityOptions = Restaurant.cities
    private let categoryOptions = Restaurant.categories
    

    // MARK: Actions
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        guard fieldsValid() else { return }
        let collection = Firestore.firestore().collection("restaurants")
        let restaurant = Restaurant(
            name: nameTextField.text!,
            category: categoryTextField.text!,
            city: cityTextField.text!,
            price: price(from: priceTextField.text!)!,
            ratingCount: 0,
            averageRating: 0
        )
        
        collection.addDocument(data: restaurant.dictionary)
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pricePickerView:
            return priceOptions.count
        case cityPickerView:
            return cityOptions.count
        case categoryPickerView:
            return categoryOptions.count
            
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        switch pickerView {
        case pricePickerView:
            return priceOptions[row]
        case cityPickerView:
            return cityOptions[row]
        case categoryPickerView:
            return categoryOptions[row]
            
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pricePickerView:
            priceTextField.text = priceOptions[row]
        case cityPickerView:
            cityTextField.text = cityOptions[row]
        case categoryPickerView:
            categoryTextField.text = categoryOptions[row]
            
        case _:
            fatalError("Unhandled picker view: \(pickerView)")
        }
    }
    
    private func price(from string: String) -> Int? {
        switch string {
        case "$":
            return 1
        case "$$":
            return 2
        case "$$$":
            return 3
            
        case _:
            return nil
        }
    }
    
}

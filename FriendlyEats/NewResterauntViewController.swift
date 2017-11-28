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
import FirebaseStorage

class NewResterauntViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
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
    
    var url: String = "";
    
    // MARK: Functions
    override func viewDidLoad(){
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
    func fieldsValid() -> Bool {
        return nameTextField.text != "" && categoryTextField.text != "" && cityTextField.text != "" && priceTextField.text != ""
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        guard let name = nameTextField.text else {
            return
        }
        let storageRef = Storage.storage().reference().child("\(name).png")
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                }
            }
        }
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
            averageRating: 0,
            url: self.url
        )
        
        collection.addDocument(data: restaurant.dictionary)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func uploadImage(_ sender: Any) {
        
        guard let _ = nameTextField.text else {
            let alertController = UIAlertController(title: "Add Resteraunt", message:
                "Please add a name for your resteraunt first.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true){}
    }
    
    // MARK: PickerViewDelegate
    @objc(imagePickerController:didFinishPickingMediaWithInfo:) func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            var indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            indicator.center = self.view.center
            self.view.addSubview(indicator)
            
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.white
            
            imageView.image = image;
            uploadMedia(completion: {
                (url) in
                print(url);
                indicator.stopAnimating()
                indicator.hidesWhenStopped = true
                self.url = url!
            })
        }
        self.dismiss(animated: true, completion: nil)
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

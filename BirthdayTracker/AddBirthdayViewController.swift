//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 16.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import UIKit
import CoreData

protocol AddBirthdayViewControllerDelegate{
    func addBirthdayViewController(_addBirthdayViewController:AddBirthdayViewController, didAddBirthday birthday:Birthday)
}

class AddBirthdayViewController: UIViewController{
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    var delegate: AddBirthdayViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date();
    }

    @IBAction func saveTapped(_sender: UIBarButtonItem){
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayID = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayID{
            print("birthdayID:\(uniqueId)")
        }
        
        do{
            try context.save()
        } catch let error {
            print("Не удалось сохранить из-за ошибки\(error).")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 16.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import UIKit

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
        let newBirthday = Birthday(firstName: firstName, lastName: lastName, birthdate: birthdate)
        delegate?.addBirthdayViewController(_addBirthdayViewController: self, didAddBirthday: newBirthday)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

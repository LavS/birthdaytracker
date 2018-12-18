//
//  AddBirthdayViewController.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 16.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController{
    
    // MARK: - Поля класса

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    // MARK: - Первая загрузка
    
    // После первой загрузки - ограничиваем выбор даты сегодняшним днём
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date();
    }

    // MARK: - Нажатие кнопок

    // При нажатии кнопки Сохранить - сохраняем день рождения
    @IBAction func saveTapped(_sender: UIBarButtonItem){
        
        // Сохранение значений полей в переменные
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        
        // Получение делегата и контекста
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Создание записи в БД
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayID = UUID().uuidString
        if let uniqueId = newBirthday.birthdayID{
            print("birthdayID:\(uniqueId)")
        }
        
        do{
            // Сохранение записи в БД
            try context.save()
            
            // Сохранение и настройка уведомления
            let message = "Сегодня \(firstName) \(lastName) празднует День Рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
            // Настройка триггера уведомления
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour = 19
            dateComponents.minute = 5
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Добавление уведомления в центр уведомлений
            if let identifier = newBirthday.birthdayID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print("Не удалось сохранить из-за ошибки\(error).")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // При нажатии кнопки Отменить - закрываем форму
    @IBAction func cancelTapped(_sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

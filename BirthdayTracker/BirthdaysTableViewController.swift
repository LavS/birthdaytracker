//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 17.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class BirthdaysTableViewController: UITableViewController {
    
    // MARK: - Подготовка данных
    
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()

    // После первой загрузки - выставляем формат даты
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
    }

    // Подготовка данных для отображения
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подготовка делегата, контекста и запроса к базе данных
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        // Сортировка дней рождений по алфавиту
        let sortDescriptorLastName = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptorFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorLastName, sortDescriptorFirstName]
        
        // Получение данных из базы данных и показ в таблице
        do{
            birthdays = try context.fetch(fetchRequest)
        } catch let error {
            print("Не удалось загрузить данные из-за ошибки: \(error).")
        }
        
        // Обновление данных таблицы
        tableView.reloadData()
    }
    
    // MARK: - Показ таблицы

    // Разбивка таблицы на секции (здесь только 1 секция)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Разбивка секции на строки (здесь количество строк = кол-ву записей в БД)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }

    // Отрисовка строк таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Получение данных текущей строки из БД
        let birthday = birthdays[indexPath.row]
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        
        // Заполнение текущей ячейки таблицы таблицы
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        cell.textLabel?.text = lastName + " " + firstName
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
        return cell
    }

    // MARK: - Удаление строк таблицы
    
    // Включение возможности редактирования таблицы (нужно для удаления строк)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Редактирование строк таблицы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Защита от ошибок неверного указания индекса
        if birthdays.count > indexPath.row{
            let birthday = birthdays[indexPath.row]
            
            // Удаление уведомления
            if let identifier = birthday.birthdayID{
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            // Удаление из контекста
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday)
            
            // Удаление строки из БД
            birthdays.remove(at: indexPath.row)
            do{
                try context.save()
            } catch let error {
                print("Не удалось сохранить из-за ошибки\(error).")
            }
            
            // Удаление строки из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

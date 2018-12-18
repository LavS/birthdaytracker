//
//  AppDelegate.swift
//  BirthdayTracker
//
//  Created by Sergey Lavrov on 16.12.2018.
//  Copyright © 2018 +1. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Запуск приложения
    
   // Запуск приложения
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Запрос разрешения на показ уведомлений
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in
            if granted {
                print("Разрешение на отправку уведомлений получено!")
            } else {
                print("В разрешении на отправку уведомлений отказано.")
            }
        })
        
        return true
    }

    // MARK: - Переопределение различных событий приложения
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Стек

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BirthdayTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Неизвестная ошибка \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Сохранение

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Неизвестная ошибка \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


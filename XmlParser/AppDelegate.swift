//
//  AppDelegate.swift
//  XmlParser
//
//  Created by iOS on 11.02.2019.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !ConnectivityManager.shared.isConnected {
           checkInternetConnection()
        }
        return true
    }

    func checkInternetConnection() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let message = "Нет соединения с сервером. Отсутствует подключение к Интернету."
        let attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let attributeString = NSAttributedString(string: message, attributes: attribute)
        alert.setValue(attributeString, forKey: "attributedMessage")
        let actionOK = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(actionOK)
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}


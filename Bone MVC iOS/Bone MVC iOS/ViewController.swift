//
//  ViewController.swift
//  Bone MVC iOS
//
//  Created by Derek Stephen McLean on 19/04/2019.
//  Copyright © 2019 Derek Stephen McLean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var host = ""
    var key = ""
    var secret = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the API settings and ping the server
        initSettings()
        pingServer()
    }
    

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func initSettings() {
        if let settingsUrl = Bundle.main.url(forResource: "apiKey", withExtension: "txt") {
            if let settingsContents = try? String(contentsOf: settingsUrl) {
                let settings = settingsContents.components(separatedBy: "\n")
                host = settings[0]
                key = settings[1]
                secret = settings[2]
                return
            }
        }
        showAlert(title: "Error", message: "settings could not be loaded")
    }
    
    func pingServer() {
        let urlString: String
        urlString = "\(host)/ping"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let stringData = String(data: data, encoding: String.Encoding.utf8) as String?
                    let ac = UIAlertController(title: "API Connection succeeded", message: stringData, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                    return
                }
            }
            self?.showAlert(title: "Loading error", message: "The API Server could not be reached.")
        }
    }
}


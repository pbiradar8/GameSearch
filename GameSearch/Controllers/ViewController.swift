//
//  ViewController.swift
//  GameSearch
//
//  Created by Biradar, Pravin on 1/15/19.
//  Copyright © 2019 Biradar, Pravin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoGames", let gamesTableVC = segue.destination as? GameTableViewController {
            if let gameName  = gameText.text {
                gamesTableVC.gameText = gameName
            }
        }
    }
    
    //method to hide the keyboard
    @objc func hideKeyboard() { 
        view.endEditing(true)
    }
    
}


//
//  ViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    
    @IBAction func startButtonPress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main" - имя вашего сториборда
        let viewController = storyboard.instantiateViewController(withIdentifier: "2") // идентификатор VC
        navigationController?.pushViewController(viewController, animated: false)    }
}

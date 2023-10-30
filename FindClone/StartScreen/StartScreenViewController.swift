//
//  StartScreenViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    
    @IBAction func startButtonPress(_ sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "2") else {return}
        navigationController?.pushViewController(viewController, animated: false)
    }

}

//
//  StartScreenViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var difficultButton: UIButton!
    @IBOutlet var difficultView: UIView!
    @IBOutlet var difficultSegmentController: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        difficultSegmentController.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        selectSegment()
    }

    @IBAction private func startButtonPress(_ sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "2") else {return}
        navigationController?.pushViewController(viewController, animated: false)
    }

    @IBAction private func difficultButtonPress(_ sender: UIButton) {
        difficultView.isHidden.toggle()
    }

    @IBAction private func difficultChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                saveConfigure(selectCase: sender.selectedSegmentIndex, value: 8)
            case 1:
                saveConfigure(selectCase: sender.selectedSegmentIndex, value: 6)
            case 2:
                saveConfigure(selectCase: sender.selectedSegmentIndex, value: 4)
            default:
                return
        }
    }

    private func selectSegment() {
        if let savedSegmentIndex = UserDefaults.standard.value(forKey: "selectedSegmentIndex") as? Int {
            difficultSegmentController.selectedSegmentIndex = savedSegmentIndex
        }
    }

    private func saveConfigure(selectCase: Int, value: Int) {
        UserDefaults.standard.setValue(value, forKey: "Difficult")
        UserDefaults.standard.set(selectCase, forKey: "selectedSegmentIndex")
    }

}

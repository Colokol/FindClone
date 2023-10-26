//
//  ChooseLevelViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 26.10.23.
//

import UIKit

class ChooseLevelViewController: UIViewController {

    var cardArray = [String]()
    var levelList = ["Children", "Animal"]

    @IBOutlet var levelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTableView.delegate = self
        levelTableView.dataSource = self
    }

}

extension ChooseLevelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = levelList[indexPath.row]
        let imageName = levelList[indexPath.row].lowercased() + "3"
        cell.imageView?.image = UIImage(named: imageName)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectModel: CardImageModel

        switch indexPath.row {
            case 0:
                selectModel = .children
            case 1:
                selectModel = .animal
            default:
                return
        }
        cardArray = selectModel.loadImage()
        if let gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "3") as? GameViewController {
            passImageArray(to: gameViewController)
            navigationController?.pushViewController(gameViewController, animated: false)
        }
    }

    func passImageArray(to viewController: GameViewController) {
        viewController.gameViewModel.imageCardArray = cardArray
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }

}

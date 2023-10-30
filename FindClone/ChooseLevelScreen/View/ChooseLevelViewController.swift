//
//  ChooseLevelViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 26.10.23.
//

import UIKit

final class ChooseLevelViewController: UIViewController {

    @IBOutlet var levelTableView: UITableView!

    private let gameCategory = Constants.gameCategoryList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    func setView() {
        levelTableView.delegate = self
        levelTableView.dataSource = self
        levelTableView.separatorStyle = .singleLine
        levelTableView.separatorColor = .black
    }

    deinit {
        print("TimerVC deinit")
    }

}

// MARK: - TableView DataSource method
extension ChooseLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameCategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Medium", size: 22)
        cell.textLabel?.text = gameCategory[indexPath.row]
        let imageName = gameCategory[indexPath.row].lowercased() + "4"
        cell.imageView?.image = UIImage(named: imageName)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.selectionStyle = .none
        return cell
    }

}

    // MARK: - TableView Delegate method
extension ChooseLevelViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
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

        guard let gameVC = storyboard?.instantiateViewController(identifier: "4") as? GameViewController else {return}
        gameVC.gameViewModel.imageCardArray = selectModel.loadImage()
        navigationController?.pushViewController(gameVC, animated: false)
    }

}

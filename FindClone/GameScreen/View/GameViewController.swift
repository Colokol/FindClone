//
//  GameViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

class GameViewController: UIViewController {

    var gameViewModel = GameViewModel()

    @IBOutlet var leftLivesLable: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var statusGameLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        gameViewModel.addCard()
        bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
    }

    @IBAction func reloadButtonPress(_ sender: UIButton) {
        self.statusGameLabel.isHidden = true
        self.reloadButton.isHidden = true
        gameViewModel.score = 0
        gameViewModel.leftLifes.value = 3
        gameViewModel.addCard()
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
        gameViewModel.gameIsActive = true
    }

    func bindView() {
        gameViewModel.scoreGame.bind { [weak self] score in
            if score == 6 {
                self?.statusGameLabel?.text = "You Win"
                self?.statusGameLabel.isHidden = false
                self?.reloadButton.isHidden = false
            }
        }
        gameViewModel.leftLifes.bind { [weak self] lives in
            if lives == 0 {
                self?.gameViewModel.gameIsActive = false
                self?.leftLivesLable.text = ""
                self?.statusGameLabel.isHidden = false
                self?.statusGameLabel?.text = "You Lose"
                self?.reloadButton.isHidden = false
            } else {
                self?.leftLivesLable.text = "Lives left: \(lives)"
            }
        }
    }

}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameViewModel.cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCollectionViewCell else {return UICollectionViewCell()}
            cell.presentCard(card: self.gameViewModel.cardArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard gameViewModel.gameIsActive else { return }
            gameViewModel.openCard(indexPath: indexPath, collectionView: collectionView)
    }

}

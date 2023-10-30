//
//  GameViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

final class GameViewController: UIViewController {

    @IBOutlet var leftLivesLable: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var statusGameLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var nextLevelButton: UIButton!

    var gameViewModel = GameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.hidesBackButton = true
        gameViewModel.addCard()
        bindView()
        setCollectionLayoutForLevel(level: gameViewModel.level)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
    }

    @IBAction func playAgainButtonPress(_ sender: UIButton) {
        reloadGame()
    }

    @IBAction func nextLevelButtonPress(_ sender: UIButton) {
        nextLevel()
    }

    @IBAction func backButtonPress(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    private func bindView() {
        gameViewModel.scoreGame.bind { [weak self] score in
            if score == self?.gameViewModel.level {
                self?.levelWon()
            }
        }

        gameViewModel.leftLifes.bind { [weak self] lives in
            if lives == 0 {

              //  self?.gameLose()
                self?.gameViewModel.gameIsActive = false
            } else {
                self?.leftLivesLable.text = "Lives left: \(lives)"
            }
        }
    }
}

// MARK: - CollectionView DataSource method
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameViewModel.cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCollectionViewCell else {return UICollectionViewCell()}
        cell.presentCard(card: self.gameViewModel.cardArray[indexPath.row])
        return cell
    }
}

// MARK: - Collection Delegate method
extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard gameViewModel.gameIsActive else { return }
        gameViewModel.openCard(indexPath: indexPath, collectionView: collectionView)
    }
}

    // MARK: Game level extension
extension GameViewController {

    private func setCollectionLayoutForLevel(level: Int) {
        func bindCollectionViewCell(cellWidth: CGFloat, cellHeight: CGFloat) {
            var width: CGFloat = 0
            var height: CGFloat = 0
            width = (collectionView.frame.width - (layout.minimumInteritemSpacing * cellWidth)) / cellWidth
            height = (collectionView.frame.height - (layout.minimumLineSpacing * cellHeight)) / cellHeight
            layout.itemSize = CGSize(width: width, height: height)
        }

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

            // размеры ячеек в зависимости от уровня
        switch level {
            case 2:
                bindCollectionViewCell(cellWidth: 2, cellHeight: 2)
            case 3:
                bindCollectionViewCell(cellWidth: 2, cellHeight: 3)
            case 4:
                bindCollectionViewCell(cellWidth: 2, cellHeight: 4)
            case 5:
                bindCollectionViewCell(cellWidth: 2, cellHeight: 5)
            case 6:
                bindCollectionViewCell(cellWidth: 3, cellHeight: 4)
            case 7:
                bindCollectionViewCell(cellWidth: 3, cellHeight: 5)
            case 8:
                bindCollectionViewCell(cellWidth: 4, cellHeight: 4)
            default:
                return
        }

        collectionView.collectionViewLayout = layout
    }

    private func levelWon() {
        statusGameLabel?.text = "Level passed"
        statusGameLabel.isHidden = false
        nextLevelButton.isHidden = false
        gameViewModel.level += 1
    }

    private func gameLose() {
        statusGameLabel?.text = "You Lose"
        leftLivesLable.text = ""
        statusGameLabel.isHidden = false
        playAgainButton.isHidden = false
    }

    private func reloadGame() {
        self.statusGameLabel.isHidden = true
        self.playAgainButton.isHidden = true

        gameViewModel.reloadGame()
        setCollectionLayoutForLevel(level: gameViewModel.level)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
        navigationItem.title = "Level: \(gameViewModel.level - 1)"
    }

    private func nextLevel() {
        statusGameLabel.isHidden = true
        nextLevelButton.isHidden = true
        navigationItem.title = "Level: \(gameViewModel.level - 1)"

        gameViewModel.nextLevel()
        setCollectionLayoutForLevel(level: gameViewModel.level)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
    }
}

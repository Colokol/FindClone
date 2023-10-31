//
//  GameViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

final class GameViewController: UIViewController {

    @IBOutlet var leftLivesLable: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var statusGameLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var nextLevelButton: UIButton!
    @IBOutlet var timerView: UIView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var openThreeHintButton: UIButton!
    @IBOutlet var showCardsHint: UIButton!
    @IBOutlet var hintsDescriptionView: UIView!

    var gameViewModel = GameViewModel()
    private var countdownTimer: Timer?
    private var secondsRemaining = Constants.timerSecondRemaining

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.hidesBackButton = true

        startTimer()
        gameViewModel.addCard()
        bindView()
        setCollectionLayoutForLevel(level: gameViewModel.level)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
    }

    @IBAction func playAgainButtonPress(_ sender: UIButton) {
        timerView.isHidden = false
        startTimer()
        reloadGame()
    }

    @IBAction func nextLevelButtonPress(_ sender: UIButton) {
        timerView.isHidden = false
        startTimer()
        nextLevel()
    }

    @IBAction func backButtonPress(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    private func bindView() {
        leftLivesLable.title = "Lives: \(gameViewModel.leftLifes.value)"
        timerLabel.text = "\(secondsRemaining)"

        gameViewModel.scoreGame.bind { [weak self] score in
            if score == self?.gameViewModel.level {
                self?.levelWon()
            }
        }

        gameViewModel.leftLifes.bind { [weak self] lives in
            if lives == 0 {
                self?.gameLose()
            } else {
                self?.leftLivesLable.title = "Lives: \(lives)"
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

// MARK: - Game level extension
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
        leftLivesLable.title = ""
        gameViewModel.gameIsActive = false
        statusGameLabel.isHidden = false
        playAgainButton.isHidden = false
    }

    private func reloadGame() {
        gameViewModel.reloadGame()
        setCollectionLayoutForLevel(level: gameViewModel.level)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)

        navigationItem.title = "Level: \(gameViewModel.level - 1)"
        self.statusGameLabel.isHidden = true
        self.playAgainButton.isHidden = true
    }

    private func nextLevel() {
        navigationItem.title = "Level: \(gameViewModel.level - 1)"
        statusGameLabel.isHidden = true
        nextLevelButton.isHidden = true

        gameViewModel.nextLevel()
        setCollectionLayoutForLevel(level: gameViewModel.level)
        gameViewModel.showCardsForInitialDuration(collectionView: collectionView)
    }
}

// MARK: - Timer
extension GameViewController {
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

            // CABasicAnimation для изменения размера текста
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 4.0
        scaleAnimation.duration = 3.0

        timerLabel.layer.add(scaleAnimation, forKey: "scaleAnimation")
    }

    @objc private func updateTimer() {
        if secondsRemaining > 1 {
            timerLabel.text = "\(secondsRemaining - 1)"
            secondsRemaining -= 1
        } else {
            countdownTimer?.invalidate()
            timerView.isHidden = true
            secondsRemaining = Constants.timerSecondRemaining
            self.timerLabel.text = "\(self.secondsRemaining)"
        }
    }

}

// MARK: - Hints
extension GameViewController {
    @IBAction func openThreeHintPress(_ sender: UIButton) {
        gameViewModel.openThreeRandomCardsHint(collectionView: collectionView)
        openThreeHintButton.setBackgroundImage(UIImage(named: "3.square.used"), for: .normal)
        openThreeHintButton.isUserInteractionEnabled = false
    }

    @IBAction func showCardsHintPress(_ sender: UIButton) {
        gameViewModel.showCardsHint(collectionView: collectionView)
        showCardsHint.setBackgroundImage(UIImage(named: "eye.slash"), for: .normal)
        showCardsHint.isUserInteractionEnabled = false
    }

    @IBAction func hintsHelp(_ sender: UIButton) {
        hintsDescriptionView.layer.cornerRadius = 30
        hintsDescriptionView.isHidden = false
    }

    @IBAction func hintsDescriptionClosseButtonPress(_ sender: UIButton) {
        hintsDescriptionView.isHidden.toggle()
    }
}

//
//  TimerScreenViewController.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 27.10.23.
//

import UIKit

final class TimerScreenViewController: UIViewController {

    var cardArray = [String]()

    @IBOutlet weak var timerLabel: UILabel!

    private var countdownTimer: Timer?
    private var secondsRemaining = Constants.timerSecondRemaining

    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "\(secondsRemaining)"
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        navigationItem.hidesBackButton = true
    }

     @objc private func updateTimer() {
        if secondsRemaining > 1 {
                // Начало анимации изменения текста и размера метки
            UIView.transition(with: timerLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.timerLabel.text = "\(self.secondsRemaining - 1)"
                self.timerLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
                    // Завершение анимации: восстановление начальных размеров
                UIView.transition(with: self.timerLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.timerLabel.transform = .identity
                })
            }
            secondsRemaining -= 1
        } else {
            countdownTimer?.invalidate()
            startGame()
        }
    }

    private func startGame() {
        guard let gameVC = storyboard?.instantiateViewController(identifier: "4") as? GameViewController else {return}
        gameVC.gameViewModel.imageCardArray = cardArray
        navigationController?.pushViewController(gameVC, animated: false)
    }

}

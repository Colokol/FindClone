//
    //  GameViewModel.swift
    //  FindClone
    //
    //  Created by Uladzislau Yatskevich on 23.10.23.
    //

import Foundation
import UIKit

final class GameViewModel {

    var level = Constants.startLevel
    var scoreGame = Dynamic(0)
    var leftLifes = Dynamic(Constants.numberOfLife) // Количество жизней
    var imageCardArray = [String]()
    var cardArray = [Card]()
    var openCards: [Card] = []
    var gameIsActive = true

    func showCardsForInitialDuration(collectionView: UICollectionView) {
        for card in cardArray {
            card.isHiden = false
        }
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hideAllCards()
            collectionView.reloadData()
        }
    }

    private func hideAllCards() {
        for card in cardArray {
            card.isHiden = true
        }
    }

    func addCard() {
        cardArray.removeAll()
        var array = imageCardArray
        for _ in 0..<level {
            let element = array.randomElement()
            array.removeAll {  $0 == element}
            let card = Card(image: element ?? "card1")
            let copyCard = Card(image: element ?? "card1")
            cardArray.append(card)
            cardArray.append(copyCard)
        }
        cardArray.shuffle()
    }

    func openCard(indexPath: IndexPath, collectionView: UICollectionView) {
        if !cardArray[indexPath.row].isHiden {return}

        cardArray[indexPath.row].isHiden = false
        collectionView.reloadItems(at: [indexPath])
        openCards.append(cardArray[indexPath.row])
            // Карты совпали, добавляем бал
        if openCards.count == 2 {
            gameIsActive = false
            if openCards[0].image == openCards[1].image {
                scoreGame.value += 1
                openCards.removeAll()
                gameIsActive = true
            } else {
            // Карты не совпали, скрываем по индексу
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    for openCard in self.openCards {
                        if let index = self.cardArray.firstIndex(where: { $0 === openCard }) {
                            self.cardArray[index].isHiden = true
                        }
                    }
                    self.gameIsActive = true
                    self.leftLifes.value -= 1
                    self.openCards.removeAll()
                    collectionView.reloadData()
                }
            }
        }
    }

    func reloadGame() {
        scoreGame.value = 0
        level = Constants.startLevel
        leftLifes.value = Constants.numberOfLife
        addCard()
        gameIsActive = true
    }
    
    func nextLevel() {
        scoreGame.value = 0
        leftLifes.value = Constants.numberOfLife
        addCard()
        gameIsActive = true
    }

}

//
//  CardCollectionViewCell.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageCard: UIImageView!

    func presentCard(card: Card) {
        if card.isHiden == true {
            imageCard.image = UIImage(named: "hidden")
        } else {
            imageCard.image = UIImage(named: card.image)
        }
    }

}

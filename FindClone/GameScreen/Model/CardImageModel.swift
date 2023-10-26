//
//  CardImageModel.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 26.10.23.
//

import Foundation

enum CardImageModel {

    case children

    func loadImage() -> [String] {
        switch self {
            case .children: return ["card1", "card2", "card3", "card4", "card5", "card6", "card7"]
        }
    }
}

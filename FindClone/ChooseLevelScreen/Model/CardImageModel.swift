//
    //  CardImageModel.swift
    //  FindClone
    //
    //  Created by Uladzislau Yatskevich on 26.10.23.
    //

import Foundation

enum CardImageModel {

    case children
    case animal

    func loadImage() -> [String] {
        switch self {
            case .children:
                return ["children1", "children2", "children3", "children4", "children5", "children6", "children7", "children8"]
            case .animal:
                return ["animal1", "animal2", "animal3", "animal4", "animal5", "animal6", "animal7", "animal8"]
        }
    }
}

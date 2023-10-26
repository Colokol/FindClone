//
//  Dynamic.swift
//  FindClone
//
//  Created by Uladzislau Yatskevich on 23.10.23.
//

import Foundation

class Dynamic<T> {
    typealias Lisner = (T) -> Void
    var lisner: Lisner?

    var value: T {
        didSet {
            lisner?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(lisner: Lisner?) {
        self.lisner = lisner
    }

}

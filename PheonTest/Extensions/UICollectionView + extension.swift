//
//  UICollectionView + extension.swift
//  PheonTest
//
//  Created by karaimchuk on 24.01.24.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T>(_:T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
    }
    
}

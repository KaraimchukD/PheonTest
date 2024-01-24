//
//  SelfMessageCollectionViewCell.swift
//  PheonTest
//
//  Created by karaimchuk on 24.01.24.
//

import UIKit

final class SelfMessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var messageContainer: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    @IBOutlet private weak var stackViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(with data: String) {
        messageLabel.text = data
    }
    
}

private extension SelfMessageCollectionViewCell {
    
    private func setupUI() {
        stackViewWidthConstraint.constant = UIScreen.main.bounds.width
        
        messageContainer.layer.cornerRadius = 18
        messageContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        messageContainer.clipsToBounds = true
    }
}

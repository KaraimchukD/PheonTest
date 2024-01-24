//
//  ChatViewController.swift
//  PheonTest
//
//  Created by karaimchuk on 24.01.24.
//

import UIKit

final class ChatViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var textView: UITextView!
    
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    
    private var messages = [ChatModel]() {
        didSet {
            if messages != oldValue {
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTextView()
        configureKeyboardSettings()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.transform = CGAffineTransform(rotationAngle: .pi)
        
        collectionView.registerCell(SelfMessageCollectionViewCell.self)
        collectionView.registerCell(AnotherMessageCollectionViewCell.self)
    }
    
    private func configureTextView() {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
    }
    
    private func configureAnotherMessage(with text: String) async {
        let reversedText = String(text.reversed())
        let message = ChatModel(text: reversedText, owner: .another)
        messages.insert(message, at: 0)
        textView.text = String()
    }
    
    @IBAction private func clickOnSendButton() {
        if !textView.text.isEmpty,
           textView.text.count < 300 {
            let message = ChatModel(text: textView.text, owner: .`self`)
            messages.insert(message, at: 0)
            
            Task {
                await configureAnotherMessage(with: textView.text)
            }
        }
    }
    
}

private extension ChatViewController {
    
    func configureKeyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
    }
        
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            textViewBottomConstraint.constant = keyboardHeight + 25
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        textViewBottomConstraint.constant = 30
    }
}

extension ChatViewController: UICollectionViewDelegate { }

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        switch message.owner {
        case .self:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelfMessageCollectionViewCell.self), for: indexPath) as? SelfMessageCollectionViewCell else { return UICollectionViewCell() }
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            cell.configure(with: message.text)
            return cell
            
        case .another:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AnotherMessageCollectionViewCell.self), for: indexPath) as? AnotherMessageCollectionViewCell else { return UICollectionViewCell() }
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            cell.configure(with: message.text)
            return cell
        }
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]
        
        switch message.owner {
        case .self:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelfMessageCollectionViewCell.self), for: indexPath) as? SelfMessageCollectionViewCell else { return CGSize() }
            cell.configure(with: message.text)
            let width = collectionView.bounds.width
            let size = cell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
            return CGSize(width: width, height: size.height)
            
        case .another:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AnotherMessageCollectionViewCell.self), for: indexPath) as? AnotherMessageCollectionViewCell else { return CGSize() }
            cell.configure(with: message.text)
            let width = collectionView.bounds.width
            let size = cell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height))
            return CGSize(width: width, height: size.height)
        }
    }
}

//
//  Extensions.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 28.12.2023.
//

import UIKit

extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        self.searchTextField.backgroundColor = color
    }
    
    func setIconColor(_ color: UIColor) {
        self.searchTextField.leftView?.tintColor = color
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func removeBorder() {
        self.backgroundImage = UIImage() // Bu, searchBar'ın etrafındaki varsayılan border ve shadow'ları kaldırır.
    }
    
    func setClearButtonColor(_ color: UIColor) {
        if let clearButton = self.searchTextField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = color
        }
    }
}

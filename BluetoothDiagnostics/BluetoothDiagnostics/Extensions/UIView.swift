//
//  UIView.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-02.
//

import Foundation
import UIKit

extension UIView {
    func centerInView(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func pinToView(view: UIView, padding: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
    
    func pinToLeft(view: UIView, padding: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
}

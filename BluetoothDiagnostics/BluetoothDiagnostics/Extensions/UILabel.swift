//
//  UILabel.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-04.
//

import Foundation
import UIKit

enum LabelType {
    case subText
}

extension UILabel {
    convenience init(type: LabelType) {
        self.init()
        switch type {
        case .subText:
            self.numberOfLines = 0
            self.textColor = UIColor.subTextGray()
        }
    }
}

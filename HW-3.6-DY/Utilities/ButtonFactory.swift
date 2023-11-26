//
//  ButtonFactory.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import UIKit

protocol ButtonFactory {
    func createButton() -> UIButton
}

final class FilledButtonFactory {
    let title: String
    let colorFG: UIColor
    let colorBG: UIColor
    let action: UIAction
    
    init(title: String, colorFG: UIColor, colorBG: UIColor, action: UIAction) {
        self.title = title
        self.colorFG = colorFG
        self.colorBG = colorBG
        self.action = action
    }
}

extension FilledButtonFactory: ButtonFactory {
    func createButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = colorBG
        configuration.baseForegroundColor = colorFG
        configuration.buttonSize = .medium
        
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 16)
        
        configuration.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

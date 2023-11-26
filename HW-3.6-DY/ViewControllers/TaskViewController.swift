//
//  TaskViewController.swift
//  HW-3.6-DY
//
//  Created by Denis Yarets on 25/11/2023.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func saveTask(with title: String)
}

final class TaskViewController: UIViewController {
    
    weak var delegate: TaskViewControllerDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task"
//        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
//        textField.layer.borderColor = UIColor.gray.cgColor
//        textField.textColor = UIColor.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buttonSave: UIButton = {
        let button: ButtonFactory = FilledButtonFactory(title: "Save", colorFG: .white, colorBG: .black, action: UIAction {
            [unowned self] _ in
            save()
        })
        return button.createButton()
    }()
    
    private lazy var buttonCancel: UIButton = {
        let button: ButtonFactory = FilledButtonFactory(title: "Cancel", colorFG: .white, colorBG: .black, action: UIAction {
            [unowned self] _ in
            navigationController?.popViewController(animated: true)
        })
        return button.createButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(textField, buttonSave, buttonCancel)
        setupConstraints()
    }
    
}

private extension TaskViewController {
    
    func save() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        delegate?.saveTask(with: text)
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonSave.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40),
            buttonSave.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonSave.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonCancel.topAnchor.constraint(equalTo: buttonSave.bottomAnchor, constant: 20),
            buttonCancel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonCancel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
}

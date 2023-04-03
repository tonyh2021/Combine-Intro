//
//  DemoViewController.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-02.
//

import UIKit
import Combine

/// just show some examples using Combine in UIKit
class DemoViewController: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    private func setupBinding() {
        // No good
        textField.publisher(for: \.text)
            .map { [weak self] _ in (
                self?.textField.text ?? "").count == 4
            }
            .assign(to: \.isEnabled, on: button1)
            .store(in: &cancellables)

        // textField editing event publisher
        let textFieldSubscriber = textField.publisher(for: .allEditingEvents)
            .map { [weak self] _ in (
                self?.textField.text ?? "").count == 4
            }

        textFieldSubscriber
            .assign(to: \.isEnabled, on: button1)
            .store(in: &cancellables)

        textFieldSubscriber
            .sink(receiveValue: { [weak self] enabled in
                self?.textField.layer.borderColor = enabled ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
            })
            .store(in: &cancellables)

        // Routing Notifications to Combine Subscribers
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { notifi in
                print("\(notifi.userInfo?.description ?? "")")
            })
            .store(in: &cancellables)

        // publisher of button
        button1.publisher(for: .touchUpInside)
            .sink(receiveValue: { control in
                // do something
                print("\(control)")
            })
            .store(in: &cancellables)

        button2.publisher(for: .touchUpInside)
            .sink(receiveValue: { control in
                // do something
                print("\(control)")
            })
            .store(in: &cancellables)

        // publisher of button merging
        button1.publisher(for: .touchUpInside)
            .merge(with: button2.publisher(for: .touchUpInside))
            .sink { control in
                print("\(control)")
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        title = "UIKit with Combine"
        view.backgroundColor = .white
        
        view.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.size.equalTo(button1)
            make.top.equalTo(button1.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(button1)
            make.top.equalTo(button2.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 1", for: .normal)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button 2", for: .normal)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Type something..."
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
}

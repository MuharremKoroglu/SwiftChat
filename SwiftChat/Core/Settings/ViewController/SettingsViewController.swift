//
//  SettingsViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 13.05.2024.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    
    private let settingsView = UIHostingController(rootView: SettingsSwiftUIView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSwiftUIView()
        setUpConstraints()
    }
    
}

private extension SettingsViewController {
    
    func setUpSwiftUIView() {
        
        addChild(settingsView)
        settingsView.didMove(toParent: self)
        
        view.addSubview(settingsView.view)

    }
    
    func setUpConstraints() {
        
        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            settingsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        
        ])
        
    }
    
    
    
    
}


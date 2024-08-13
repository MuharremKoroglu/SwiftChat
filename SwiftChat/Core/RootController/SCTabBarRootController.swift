//
//  SCTabBarController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 13.05.2024.
//

import UIKit

class SCTabBarRootController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarController()
    }
    
    private func setUpTabBarController () {
        
        let chatsViewModel = ChatsViewModel()
        let chatsVC = ChatViewController(viewModel: chatsViewModel)
        let settingsVC = SettingsViewController(viewModel: SettingsViewModel(), chatMessages: chatsViewModel.recentMessages)
        
        chatsVC.title = "Chats"
        settingsVC.title = "Settings"
        
        chatsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let chatVCNavigationController = UINavigationController(rootViewController: chatsVC)
        let settingsVCNavigationController = UINavigationController(rootViewController: settingsVC)
        
        chatVCNavigationController.tabBarItem = UITabBarItem(
            title: "Chats", 
            image: UIImage(systemName: "message.fill"),
            tag: 1
        )
        
        settingsVCNavigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear.circle.fill"),
            tag: 2
        )
        
        let vcControllers = [
            chatVCNavigationController,
            settingsVCNavigationController
        ]
        
        for vcController in vcControllers {
            vcController.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(vcControllers, animated: true)

    }
    
}

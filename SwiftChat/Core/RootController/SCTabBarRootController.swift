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
        
        let chatsVC = ChatViewController()
        let channelsVC = ChannelsViewController()
        let settingsVC = SettingsViewController()
        
        chatsVC.title = "Chats"
        channelsVC.title = "Channels"
        settingsVC.title = "Settings"
        
        chatsVC.navigationItem.largeTitleDisplayMode = .automatic
        channelsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let chatVCNavigationController = UINavigationController(rootViewController: chatsVC)
        let channelsVCNavigationController = UINavigationController(rootViewController: channelsVC)
        let settingsVCNavigationController = UINavigationController(rootViewController: settingsVC)
        
        chatVCNavigationController.tabBarItem = UITabBarItem(
            title: "Chats", 
            image: UIImage(systemName: "message.fill"),
            tag: 1
        )
        channelsVCNavigationController.tabBarItem = UITabBarItem(
            title: "Channels",
            image: UIImage(systemName: "tv.fill"),
            tag: 2
        )
        settingsVCNavigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear.circle.fill"),
            tag: 3
        )
        
        let vcControllers = [
            chatVCNavigationController,
            channelsVCNavigationController,
            settingsVCNavigationController
        ]
        
        for vcController in vcControllers {
            vcController.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(vcControllers, animated: true)

    }
    
}

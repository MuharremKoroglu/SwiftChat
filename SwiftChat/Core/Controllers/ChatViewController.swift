//
//  ViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 10.05.2024.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openPeoplList)
        ), animated: true)
        
    }
    
    @objc func openPeoplList () {
        print("Test")
    }


}


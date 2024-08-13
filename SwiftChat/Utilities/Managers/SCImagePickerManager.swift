//
//  SCImagePickerManager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 8.08.2024.
//

import Foundation
import UIKit

struct  SCImagePickerManager{

    @MainActor
    static func pickImage(from sourceType: UIImagePickerController.SourceType, in viewController: UIViewController) {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        
        viewController.present(picker, animated: true)
    }
    
}


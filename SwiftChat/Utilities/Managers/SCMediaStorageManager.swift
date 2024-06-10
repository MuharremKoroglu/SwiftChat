//
//  SCMediaManager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 9.06.2024.
//

import Foundation
import UIKit
import FirebaseStorage

final class SCMediaStorageManager {
    
    static let shared = SCMediaStorageManager()
    private init () {}
    
    private let storage = Storage.storage().reference()
    
    func uploadData (folderName : MediaStorageFolder, fileName : String, data : Data) async throws -> URL{
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let dataReference = storage
            .child(folderName.rawValue)
            .child("\(fileName).jpeg")
        
        let _ = try await dataReference.putDataAsync(data,metadata: metaData)
        
        let url = try await dataReference.downloadURL()
            
        return url
    
    }
    
}

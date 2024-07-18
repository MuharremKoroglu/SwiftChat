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
    
    func uploadData (folderName : MediaStorageFolderNames, fileName : String, secondFileName : String? = nil, data : Data) async throws -> URL{
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        var dataReference = storage.child(folderName.rawValue)
        
        if folderName == .messageMedia {
            dataReference = dataReference.child(fileName).child("\(secondFileName ?? "").jpeg")
        }else {
            dataReference = dataReference.child("\(fileName).jpeg")
        }
            
        let _ = try await dataReference.putDataAsync(data,metadata: metaData)
        
        let url = try await dataReference.downloadURL()
            
        return url
    
    }
    
}

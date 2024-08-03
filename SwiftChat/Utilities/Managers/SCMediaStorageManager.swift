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
    
    func uploadData (folderName : MediaStorageFolderNames, fileName : String, secondFileName : String? = nil, thirdFileName : String? = nil ,data : Data) async throws -> URL{
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        var dataReference = storage.child(folderName.rawValue)
        
        if let secondFileName = secondFileName {
            if let thirdFileName = thirdFileName {
                dataReference = dataReference.child(fileName).child(secondFileName).child("\(thirdFileName).jpeg")
            } else {
                dataReference = dataReference.child(fileName).child("\(secondFileName).jpeg")
            }
        } else {
            dataReference = dataReference.child("\(fileName).jpeg")
        }
        
        let _ = try await dataReference.putDataAsync(data,metadata: metaData)
        
        let url = try await dataReference.downloadURL()
        
        return url
        
    }
    
    func deleteSingleData(folderName : MediaStorageFolderNames, fileName : String, secondFileName : String? = nil, thirdFileName : String? = nil) async throws {
        
        var dataReference = storage.child(folderName.rawValue)
        
        if let secondFileName = secondFileName {
            if let thirdFileName = thirdFileName {
                dataReference = dataReference.child(fileName).child(secondFileName).child("\(thirdFileName).jpeg")
            } else {
                dataReference = dataReference.child(fileName).child("\(secondFileName).jpeg")
            }
        } else {
            dataReference = dataReference.child("\(fileName).jpeg")
        }
        
        try await dataReference.delete()
        
    }
    
    func deleteMultipleData(folderName: MediaStorageFolderNames, fileName: String, secondFileName: String? = nil) async throws {
        
        var folderReference = storage.child(folderName.rawValue)
        
        if let secondFileName = secondFileName {
            folderReference = folderReference.child(fileName).child(secondFileName)
        } else {
            folderReference = folderReference.child(fileName)
        }
        
        let listResult = try await folderReference.listAll()
        
        for item in listResult.items {
            try await item.delete()
        }
    }
    
}

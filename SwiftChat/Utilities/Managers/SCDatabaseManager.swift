//
//  SCDatabaseManager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 9.06.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class SCDatabaseManager {
    
    static let shared = SCDatabaseManager()
    private init () {}
    
    private let userCollection = Firestore.firestore().collection("Users")
    
    private func getDocumentReference (documentId : String) -> DocumentReference {
        
        return userCollection.document(documentId)
        
    }
    
    func createData <T : Encodable> (userId : String, data : T) async throws {
        
        try getDocumentReference(documentId: userId).setData(from: data, merge: false)
        
    }
    
    func readData <T: Decodable> (userId : String, data : T.Type) async throws -> T {
        
        return try await getDocumentReference(documentId: userId).getDocument(as: data.self)
        
    }
    
    func updateData (userId : String, field: String, newValue : Any) async throws{
        
        let updatedData : [String : Any] = [
            field : newValue
        ]
        
        try await getDocumentReference(documentId: userId).updateData(updatedData)

    }
    
    
    func deleteData(userId : String) async throws {
        
        try await getDocumentReference(documentId: userId).delete()
        
    }
    
}

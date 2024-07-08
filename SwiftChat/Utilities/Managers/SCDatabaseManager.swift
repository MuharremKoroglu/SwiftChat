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
    
    private let fireStore = Firestore.firestore()
    
    private func getCollectionReference (collection : DatabaseCollections) -> CollectionReference {
        
        return fireStore.collection(collection.rawValue)
        
    }
    
    private func getDocumentReference (collectionId : DatabaseCollections, documentId : String, secondDocumentId : String? = nil) -> DocumentReference {
        
        if collectionId == .messages {
           return getCollectionReference(collection: collectionId)
                .document(documentId)
                .collection(secondDocumentId ?? "")
                .document()
        }
        
        return getCollectionReference(collection: collectionId).document(documentId)
        
    }
    
    func createData <T : Encodable> (collectionId : DatabaseCollections, documentId : String, secondDocumentId : String? = nil ,data : T) async throws {
        
        try getDocumentReference(collectionId: collectionId, documentId: documentId,secondDocumentId: secondDocumentId).setData(from: data, merge: false)
        
    }
    
    func readSingleData <T: Decodable> (collectionId : DatabaseCollections, documentId : String, data : T.Type) async throws -> T {
        
        return try await getDocumentReference(collectionId: collectionId, documentId: documentId).getDocument(as: data.self)
        
    }
    
    func readMultipleData <T : Decodable> (collectionId : DatabaseCollections, data : T.Type) async throws -> [T]{
        
        let snapshot = try await getCollectionReference(collection: collectionId).getDocuments()
        
        var dataModels: [T] = []
        for document in snapshot.documents {
            if let dataModel = try? document.data(as: data.self) {
                dataModels.append(dataModel)
            }
        }
        
        return dataModels

    }
    
    func updateData (collectionId : DatabaseCollections, documentId : String, field: String, newValue : Any) async throws{
        
        let updatedData : [String : Any] = [
            field : newValue
        ]
        
        try await getDocumentReference(collectionId: collectionId, documentId: documentId).updateData(updatedData)

    }
    
    
    func deleteData(collectionId: DatabaseCollections, userId : String) async throws {
        
        try await getDocumentReference(collectionId: collectionId, documentId: userId).delete()
        
    }
    
    func addListener<T: Decodable>(collectionId: DatabaseCollections, documentId: String, secondCollectionId: String, data: T.Type, query: String? = nil,completion: @escaping (Result<[T], Error>) -> Void) {
        
        var collectionReference : Query = getCollectionReference(collection: collectionId).document(documentId).collection(secondCollectionId)
        
        if let query = query {
            collectionReference = collectionReference.order(by: query)
        }
        
        collectionReference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No snapshot data"])))
                return
            }
            
            do {
                let models: [T] = try snapshot.documentChanges.compactMap { change in
                    if change.type == .added {
                        return try change.document.data(as: data.self)
                    }
                    return nil
                }
                completion(.success(models))
            } catch {
                completion(.failure(error))
            }
        }
    }


    
}

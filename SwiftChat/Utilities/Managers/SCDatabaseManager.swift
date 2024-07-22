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
    
    private func getDocumentReference (collectionId : DatabaseCollections, documentId : String, secondCollectionId : String? = nil, secondDocumentId : String? = nil) -> DocumentReference {
        
        var documentReference = getCollectionReference(collection: collectionId).document(documentId)
        
        if let secondCollectionId = secondCollectionId {
            if let secondDocumentId = secondDocumentId {
                documentReference = documentReference.collection(secondCollectionId).document(secondDocumentId)
            } else {
                documentReference = documentReference.collection(secondCollectionId).document()
            }
        }
        
        return documentReference
        
    }
    
    func createData <T : Encodable> (collectionId : DatabaseCollections, documentId : String, secondCollectionId : String? = nil, secondDocumentId : String? = nil ,data : T) async throws {
        
        try getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId)
        .setData(from: data, merge: false)
        
    }
    
    func readSingleData <T: Decodable> (collectionId : DatabaseCollections, documentId : String, data : T.Type) async throws -> T {
        
        return try await getDocumentReference(collectionId: collectionId, documentId: documentId).getDocument(as: data.self)
        
    }
    
    func readMultipleData <T : Decodable> (collectionId : DatabaseCollections, query : [String] = [], data : T.Type) async throws -> [T]{
        
        let snapshot: QuerySnapshot
        
        if !query.isEmpty {
            snapshot = try await getCollectionReference(collection: collectionId).whereField(FieldPath.documentID(), in: query).getDocuments()
        } else {
            snapshot = try await getCollectionReference(collection: collectionId).getDocuments()
        }
        
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
    
    func addListener<T: Decodable>(collectionId: DatabaseCollections, documentId: String? = nil, secondCollectionId: String? = nil, data: T.Type, query: String? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        
        let collectionReference: CollectionReference = getCollectionReference(collection: collectionId)
        var queryReference: Query = collectionReference
        
        if let documentId = documentId, let secondCollectionId = secondCollectionId {
            queryReference = collectionReference.document(documentId).collection(secondCollectionId)
        } else if let documentId = documentId {
            queryReference = collectionReference.document(documentId).collection("")
        }
        
        if let query = query {
            queryReference = queryReference.order(by: query)
        }
        
        queryReference.addSnapshotListener { snapshot, error in
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

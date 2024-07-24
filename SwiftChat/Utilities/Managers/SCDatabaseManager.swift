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
    
    private func getCollectionReference (collection : DatabaseCollections, documentId : String? = nil, secondCollectionId : String? = nil) -> CollectionReference {
        
        var collectionReference = fireStore.collection(collection.rawValue)
        
        if let documentId = documentId, let secondCollectionId = secondCollectionId {
            collectionReference = collectionReference.document(documentId).collection(secondCollectionId)
        }
        
        return collectionReference
        
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
    
    func readSingleData <T: Decodable> (collectionId : DatabaseCollections, documentId : String,secondCollectionId : String? = nil, secondDocumentId : String? = nil, data : T.Type) async throws -> T {
        
        let documentReference = getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId
        )
        
        return try await documentReference.getDocument(as: data.self)
        
    }
    
    func readMultipleData <T : Decodable> (collectionId : DatabaseCollections, documentId : String? = nil, secondCollectionId : String? = nil,query : [String] = [], data : T.Type) async throws -> [T]{
        
        let collectionReference = getCollectionReference(
            collection: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId
        )
        
        let snapshot: QuerySnapshot
        
        if !query.isEmpty {
            snapshot = try await collectionReference.whereField(FieldPath.documentID(), in: query).getDocuments()
        } else {
            snapshot = try await collectionReference.getDocuments()
        }
        
        var dataModels: [T] = []
        for document in snapshot.documents {
            if let dataModel = try? document.data(as: data.self) {
                dataModels.append(dataModel)
            }
        }
        
        return dataModels

    }
    
    func updateData (collectionId : DatabaseCollections, documentId : String, secondCollectionId : String? = nil, secondDocumentId : String? = nil,field: String, newValue : Any) async throws{
        
        let documentReference = getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId
        )
        
        let updatedData : [String : Any] = [
            field : newValue
        ]
        
        try await documentReference.updateData(updatedData)

    }
    
    
    func deleteSingleData(collectionId: DatabaseCollections, documentId : String, secondCollectionId : String? = nil, secondDocumentId : String? = nil) async throws {
        
        let documentReference = getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId
        )
        
        try await documentReference.delete()
        
    }
    
    func deleteMultipleData(collectionId: DatabaseCollections, documentId : String? = nil, secondCollectionId : String? = nil) async throws{
        
        let collectionReference = getCollectionReference(collection: collectionId, documentId: documentId, secondCollectionId: secondCollectionId)
        
        let snapshot = try await collectionReference.getDocuments()
        
        let documents = snapshot.documents
        
        for document in documents {
            try await document.reference.delete()
        }
 
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

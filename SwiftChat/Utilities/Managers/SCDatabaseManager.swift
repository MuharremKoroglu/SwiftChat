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
    
    private func getCollectionReference (
        collection : DatabaseCollections,
        documentId : String? = nil,
        secondCollectionId : String? = nil
    ) -> CollectionReference {
        
        var collectionReference = fireStore.collection(collection.rawValue)
        
        if let documentId = documentId, let secondCollectionId = secondCollectionId {
            collectionReference = collectionReference.document(documentId).collection(secondCollectionId)
        }
        
        return collectionReference
        
    }
    
    private func getDocumentReference (
        collectionId : DatabaseCollections,
        documentId : String,
        secondCollectionId : String? = nil,
        secondDocumentId : String? = nil
    ) -> DocumentReference {
        
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
    
    func createData <T : Encodable> (
        collectionId : DatabaseCollections,
        documentId : String,
        secondCollectionId : String? = nil,
        secondDocumentId : String? = nil ,
        data : T
    ) async throws {
        
        try getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId)
        .setData(from: data, merge: false)
        
    }
    
    func readSingleData <T: Decodable> (
        collectionId : DatabaseCollections,
        documentId : String,
        secondCollectionId : String? = nil,
        secondDocumentId : String? = nil,
        data : T.Type
    ) async throws -> T {
        
        let documentReference = getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId
        )
        
        return try await documentReference.getDocument(as: data.self)
        
    }
    
    func readMultipleData <T : Decodable> (
        collectionId : DatabaseCollections,
        documentId : String? = nil,
        secondCollectionId : String? = nil,
        query : [String] = [],
        data : T.Type
    ) async throws -> [T]{
        
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
    
    func updateData (
        collectionId : DatabaseCollections,
        documentId : String,
        secondCollectionId : String? = nil,
        secondDocumentId : String? = nil,
        field: String,
        newValue : Any
    ) async throws{
        
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
    
    
    func deleteSingleData(
        collectionId: DatabaseCollections,
        documentId : String,
        secondCollectionId : String? = nil,
        secondDocumentId : String? = nil
    ) async throws {
        
        let documentReference = getDocumentReference(
            collectionId: collectionId,
            documentId: documentId,
            secondCollectionId: secondCollectionId,
            secondDocumentId: secondDocumentId
        )
        
        try await documentReference.delete()
        
    }
    
    func deleteMultipleData(
        collectionId: DatabaseCollections,
        documentId : String? = nil,
        secondCollectionId : String? = nil
    ) async throws{
        
        let collectionReference = getCollectionReference(collection: collectionId, documentId: documentId, secondCollectionId: secondCollectionId)
        
        let snapshot = try await collectionReference.getDocuments()
        
        let documents = snapshot.documents
        
        for document in documents {
            try await document.reference.delete()
        }
 
    }
    
    func addListener<T: Decodable>(
        collectionId: DatabaseCollections,
        documentId: String? = nil,
        secondCollectionId: String? = nil,
        data: T.Type,
        query: ((Query) -> Query)? = nil,
        documentChangeType: DocumentChangeType? = nil,
        completion: @escaping (Result<Any?, Error>) -> Void
    ) -> ListenerRegistration? {
        
        let reference: Any
        
        if let documentId = documentId {
            if let secondCollectionId = secondCollectionId {
                reference = getCollectionReference(collection: collectionId, documentId: documentId, secondCollectionId: secondCollectionId)
            } else {
                reference = getDocumentReference(collectionId: collectionId, documentId: documentId)
            }
        } else {
            reference = getCollectionReference(collection: collectionId)
        }
        
        let listenerRegistration: ListenerRegistration
        
        if let reference = reference as? DocumentReference {
            listenerRegistration = reference.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = documentSnapshot else {
                    completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document data"])))
                    return
                }
                
                do {
                    let model = try document.data(as: data.self)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
        } else if let reference = reference as? Query {
            var queryReference = reference
            if let query = query {
                queryReference = query(queryReference)
            }
            
            listenerRegistration = queryReference.addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No snapshot data"])))
                    return
                }
                
                do {
                    let models: [T] = try snapshot.documentChanges.compactMap { change in
                        if let documentChangeType = documentChangeType, change.type != documentChangeType {
                            return nil
                        }
                        return try change.document.data(as: data.self)
                    }
                    completion(.success(models))
                } catch {
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid reference type"])))
            return nil
        }
        
        return listenerRegistration
    }

    
}

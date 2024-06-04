//
//  SCAuthenticationManager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 3.06.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

final class SCAuthenticationManager {
    
    static let shared : SCAuthenticationManager = SCAuthenticationManager()
    
    private init () {}
    
    func getAuthenticatedUser () -> User? {
        let user = Auth.auth().currentUser
        return user
    }
    
    func createNewUser (email : String, password : String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signInWithEmailAndPassword (email : String, password : String) async throws -> User{
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authResult.user
        return user
    }
    
    @MainActor
    func signInWithGoogle () async throws {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController
        else{
            throw GoogleSignInError.didntFindTopViewController
        }
        let authResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: root)
        let user = authResult.user
        guard let idToken = user.idToken?.tokenString else {
            throw GoogleSignInError.idTokenGetFailed
        }
        let accessToken = user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        try await Auth.auth().signIn(with: credential)
    }
        
    func passwordReset (email : String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut () throws {
        try Auth.auth().signOut()
    }
    
}

enum GoogleSignInError : Error {
    case didntFindTopViewController
    case idTokenGetFailed
}

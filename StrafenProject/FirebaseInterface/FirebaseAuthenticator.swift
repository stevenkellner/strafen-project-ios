//
//  FirebaseAuthenticator.swift
//  StrafenProject
//
//  Created by Steven on 07.04.23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

@MainActor
struct FirebaseAuthenticator {
    enum Error: Swift.Error {
        case noRootViewController
        case invalidClientId
        case invalidIdToken
    }
    
    enum SignInMethod {
        case emailAndPassword(email: String, password: String)
        case apple(scopes: [ASAuthorization.Scope]?)
        case google
    }
    
    static let shared = FirebaseAuthenticator()
    
    private init() {}
    
    @discardableResult
    func signIn(with method: SignInMethod, createUser: Bool = false) async throws -> AuthDataResult {
        switch method {
        case .emailAndPassword(email: let email, password: let password):
            if createUser {
                return try await Auth.auth().createUser(withEmail: email, password: password)
            } else {
                return try await Auth.auth().signIn(withEmail: email, password: password)
            }
        case .apple(scopes: let requestedScopes):
            return try await self.signInWithApple(scopes: requestedScopes)
        case .google:
            return try await self.signInWithGoogle()
        }
    }
        
    private func signInWithApple(scopes requestedScopes: [ASAuthorization.Scope]?) async throws -> AuthDataResult {
        let controller = SignInWithAppleController()
        let credential = try await controller.requestCredential(scopes: requestedScopes)
        return try await Auth.auth().signIn(with: credential)
    }
    
    private func signInWithGoogle() async throws -> AuthDataResult {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            throw Error.invalidClientId
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        guard let rootViewController = UIApplication.shared.rootViewController else {
            throw Error.noRootViewController
        }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw Error.invalidIdToken
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        return try await Auth.auth().signIn(with: credential)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    var user: User? {
        return Auth.auth().currentUser
    }
    
    func forgotPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

class SignInWithAppleController: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var currentNonce: String?
    
    private var credentialHandler: ((_ credential: OAuthCredential?, _ error: Error?) -> Void)?
    
    func requestCredential(scopes requestedScopes: [ASAuthorization.Scope]?) async throws -> OAuthCredential {
        self.currentNonce = String.randomNonce()
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = requestedScopes
        request.nonce = self.currentNonce?.sha256
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        return try await withCheckedThrowingContinuation { continuation in
            self.credentialHandler = { credential, error in                
                if let error {
                    continuation.resume(throwing: error)
                } else if let credential {
                    continuation.resume(returning: credential)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = self.currentNonce,
              let appleIdToken = appleIdCredential.identityToken,
              let idToken = String(data: appleIdToken, encoding: .utf8) else {
            return
        }
        let credential = OAuthProvider.appleCredential(withIDToken: idToken, rawNonce: nonce, fullName: appleIdCredential.fullName)
        self.credentialHandler?(credential, nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.credentialHandler?(nil, error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

extension GIDSignIn {
    
    @MainActor
    func signIn(withPresenting presentingViewController: UIViewController) async throws -> GIDSignInResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.signIn(withPresenting: presentingViewController) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let result {
                    continuation.resume(returning: result)
                }
            }
        }
    }
}

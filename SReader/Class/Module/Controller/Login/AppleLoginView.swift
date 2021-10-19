/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct for accessing generic password keychain items.
*/

import Foundation
import AuthenticationServices

public class AppleLoginView:UIView {
    
    public var showResultBlock:((String,PersonNameComponents?,String?)->Void)!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(iOS 13.0, *)
    public init(frame: CGRect,cornerRadius:CGFloat,type: ASAuthorizationAppleIDButton.ButtonType = .default, style: ASAuthorizationAppleIDButton.Style = .white) {
        super.init(frame: frame)
        self.setupProviderLoginView(cornerRadius:cornerRadius)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AppleLoginView {
    /// - Tag: add_appleid_button
    func setupProviderLoginView(cornerRadius:CGFloat) {
        if #available(iOS 13.0, *) {
            let btn = UIButton.init(frame: self.bounds)
            btn.frame = self.bounds
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            // btn.setImage(UIImage.init(contentsOfFile: self.getImagePath(imageName: "apple_login_icon@3x.png")), for: .normal)
            btn.setImage("apple_login".image, for: .normal)
            btn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.addSubview(btn)
//            let authorizationButton = ASAuthorizationAppleIDButton.init(type: .signIn, style: .black)
//            authorizationButton.frame =  self.bounds
//            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//            authorizationButton.cornerRadius = cornerRadius
//            self.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
    }
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            // Create an authorization controller with the given requests.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getImagePath(imageName:String) -> String{
        let bundle = Bundle.init(for: self.classForCoder)
        return bundle.path(forResource: imageName, ofType: nil, inDirectory: ((bundle.infoDictionary?["CFBundleName"] as? String) ?? "") + ".bundle") ?? ""
    }
}
@available(iOS 13.0, *)
extension AppleLoginView: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showResultBlock(userIdentifier,fullName,email)
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            SRLogger.debug("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension AppleLoginView: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window ?? UIWindow()
    }
}

//
//  LoginViewModel.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 06/02/26.
//

import UIKit
import GoogleSignIn

extension Notification.Name {
    static let loginSuccess = Notification.Name("LoginSuccessNotification")
}

final class LoginViewModel {
    
    var onLoginSuccess: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccessNotification),
            name: .loginSuccess,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func checkSilentLogin() {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            return
        }
        
        LoginManager.sharedInstance().performSilentLogin()
    }
    
    func signIn(from viewController: UIViewController) {
        LoginManager.sharedInstance().handleLogin(with: viewController)
    }
    
    @objc private func handleLoginSuccessNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.onLoginSuccess?()
        }
    }
}

//
//  ViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

import UIKit
import GoogleSignIn

// MARK: - Protocols

protocol LoginManaging {
    func handleLogin(with presentingViewController: UIViewController)
    func performSilentLogin()
}

extension LoginManager: LoginManaging {}

// MARK: - Notifications

extension Notification.Name {
    static let loginSuccess = Notification.Name("LoginSuccessNotification")
}

// MARK: - ViewModel

final class LoginViewModel {
    
    // MARK: - Dependencies
    
    private let loginManager: LoginManaging
    
    // MARK: - Outputs
    
    var onLoginSuccess: (() -> Void)?
    
    // MARK: - Initialization
    
    init(loginManager: LoginManaging = LoginManager.sharedInstance()) {
        self.loginManager = loginManager
        
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
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        performSilentLogin()
    }
    
    // MARK: - Public API
    
    func signIn(from viewController: UIViewController) {
        loginManager.handleLogin(with: viewController)
    }
    
    // MARK: - Private Helpers
    
    private func performSilentLogin() {
        loginManager.performSilentLogin()
    }
    
    @objc
    private func handleLoginSuccessNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.onLoginSuccess?()
        }
    }
}

// MARK: - ViewController

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onLoginSuccess = { [weak self] in
            self?.navigateToHome()
        }
        
        setupGoogleSignInButton()
        viewModel.viewDidLoad()
    }
    
    private func setupGoogleSignInButton() {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.addTarget(self, action: #selector(handleGoogleSignInTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func handleGoogleSignInTapped() {
        viewModel.signIn(from: self)
    }
    
    @objc
    private func navigateToHome() {
        
    }
}

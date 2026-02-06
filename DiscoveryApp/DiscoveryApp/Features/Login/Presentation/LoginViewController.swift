//
//  ViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onLoginSuccess = { [weak self] in
            self?.navigateToHome()
        }
        
        viewModel.checkSilentLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignInButton()
    }
    
    // MARK: - UI Setup
    
    private func setupGoogleSignInButton() {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.clear
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
    
    @objc private func handleGoogleSignInTapped() {
        viewModel.signIn(from: self)
    }
    
    private func navigateToHome() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            
            let nav = UINavigationController(rootViewController: homeVC)
            
            window.rootViewController = nav
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

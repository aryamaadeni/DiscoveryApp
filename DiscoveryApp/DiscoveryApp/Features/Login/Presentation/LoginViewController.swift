//
//  ViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onLoginSuccess = { [weak self] in
                self?.navigateToHome()
            }
            
            setupGoogleSignInButton()
            
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
    
    @objc private func handleGoogleSignInTapped() {
        viewModel.signIn(from: self)
    }
    
    private func navigateToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}

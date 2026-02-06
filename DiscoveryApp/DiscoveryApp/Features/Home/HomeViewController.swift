//
//  HomeViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 06/02/26.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func logoutButtonClick(_ sender: UIButton) {
        LoginManager.sharedInstance().logout()
        resetToLogin()
    }
    
    private func resetToLogin() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateInitialViewController()
            
            window.rootViewController = loginVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

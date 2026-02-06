//
//  ViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

import UIKit

// MARK: - ViewModel

final class HomeViewModel {

    // MARK: - Inputs

    // Add public methods/properties here to drive the home view.

    // MARK: - Outputs

    // Expose data bindings or callbacks here as the screen grows.
}

// MARK: - ViewController

final class ViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind view model outputs to UI here when needed.
    }


}


//
//  DetailViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 06/02/26.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var deviceNameLabel: UILabel!
    @IBOutlet private weak var ipLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var orgLabel: UILabel!
    @IBOutlet private weak var timezoneLabel: UILabel!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    var selectedDeviceName: String?
    private let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceNameLabel.text = selectedDeviceName
        
        bindViewModel()
        viewModel.fetchData()
    }

    private func bindViewModel() {
        loader.startAnimating()
        
        viewModel.onDetailsLoaded = { [weak self] details in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
                self?.updateUI(with: details)
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
                self?.handleError(error)
            }
        }
    }

    private func updateUI(with details: IPGeoDetails) {
        ipLabel.text = details.ip ?? "N/A"
        locationLabel.text = "\(details.city ?? ""), \(details.region ?? ""), \(details.country ?? "")"
        orgLabel.text = details.org ?? "N/A"
        timezoneLabel.text = details.timezone ?? "N/A"
    }

    private func handleError(_ error: Error?) {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}

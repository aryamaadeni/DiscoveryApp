//
//  HomeViewController.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 06/02/26.
//

import UIKit
import CoreData

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let serviceBrowser = NetServiceBrowser()
    private var discoveredServices = Set<NetService>()
    private let loader = UIActivityIndicatorView(style: .large)
    
    private lazy var viewModel: HomeViewModel = {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        return HomeViewModel(context: context!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadPersistedDevices()
        tableView.reloadData()
        startDiscovery()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        loader.center = self.view.center
        loader.hidesWhenStopped = true
        view.addSubview(loader)
    }

    @IBAction func logoutButtonClick(_ sender: UIButton) {
        viewModel.clearDevices()
        tableView.reloadData()
        LoginManager.sharedInstance().logout()
        resetToLogin()
    }
    
    private func resetToLogin() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

// MARK: - mDNS Discovery Logic
extension HomeViewController: NetServiceBrowserDelegate, NetServiceDelegate {
    
    private func startDiscovery() {
        loader.startAnimating()
        serviceBrowser.delegate = self
        serviceBrowser.stop()
        serviceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.loader.stopAnimating()
        }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        discoveredServices.insert(service)
        service.delegate = self
        service.resolve(withTimeout: 10.0) 
    }

    func netServiceDidResolveAddress(_ sender: NetService) {
        let ip = extractIP(from: sender.addresses) ?? "0.0.0.0"
        
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.updateCoreDataDevice(name: sender.name, ip: ip, reachable: true)
        }
    }
    
    private func extractIP(from addresses: [Data]?) -> String? {
        guard let data = addresses?.first else { return nil }
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        data.withUnsafeBytes { ptr in
            let sockaddrPtr = ptr.baseAddress!.assumingMemoryBound(to: sockaddr.self)
            getnameinfo(sockaddrPtr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST)
        }
        return String(cString: hostname)
    }
}

// MARK: - Core Data Operations
extension HomeViewController {

    func updateCoreDataDevice(name: String, ip: String, reachable: Bool) {
        viewModel.updateDevice(name: name, ip: ip, reachable: reachable)
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDevices
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        let device = viewModel.device(at: indexPath.row)
        
        cell.textLabel?.text = device.name
        let status = device.isReachable ? "Reachable" : "Un-Reachable"
        cell.detailTextLabel?.text = "IP: \(device.ipAddress ?? "Unknown") | \nStatus: \(status)"
        cell.detailTextLabel?.textColor = device.isReachable ? .systemGreen : .systemRed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedDevice = viewModel.device(at: indexPath.row)
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.selectedDeviceName = selectedDevice.name
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

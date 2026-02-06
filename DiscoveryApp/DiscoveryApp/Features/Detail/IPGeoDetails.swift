//
//  IPGeoDetails.swift
//  DiscoveryApp
//
//  Created by Arya Maadeni on 06/02/26.
//

import Foundation

struct PublicIPResponse: Codable {
    let ip: String
}

struct IPGeoDetails: Codable {
    let ip: String?
    let city: String?
    let region: String?
    let country: String?
    let loc: String?
    let org: String?
    let postal: String?
    let timezone: String?
    let readme: String?
}

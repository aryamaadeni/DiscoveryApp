import Foundation

final class DetailViewModel {
    
    var onDetailsLoaded: ((IPGeoDetails) -> Void)?
    var onError: ((Error?) -> Void)?
    
    func fetchData() {
        guard let url = URL(string: "https://api.ipify.org?format=json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.onError?(error)
                return
            }
            
            do {
                let ipResponse = try JSONDecoder().decode(PublicIPResponse.self, from: data)
                self?.fetchGeoInfo(for: ipResponse.ip)
            } catch {
                self?.onError?(error)
            }
        }.resume()
    }
    
    private func fetchGeoInfo(for ip: String) {
        let urlString = "https://ipinfo.io/\(ip)/geo"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.onError?(error)
                return
            }
            
            do {
                let details = try JSONDecoder().decode(IPGeoDetails.self, from: data)
                self?.onDetailsLoaded?(details)
            } catch {
                self?.onError?(error)
            }
        }.resume()
    }
}


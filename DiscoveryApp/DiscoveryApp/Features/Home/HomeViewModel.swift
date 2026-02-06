import Foundation
import CoreData

final class HomeViewModel {
    
    private let context: NSManagedObjectContext
    private(set) var devices: [DeviceEntity] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadPersistedDevices() {
        let fetchRequest: NSFetchRequest<DeviceEntity> = DeviceEntity.fetchRequest()
        do {
            devices = try context.fetch(fetchRequest)
            devices.forEach { $0.isReachable = false }
        } catch {
            print("Fetch Error: \(error)")
        }
    }
    
    func clearDevices() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DeviceEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            context.reset()
            devices.removeAll()
        } catch {
            print("Error clearing local database: \(error)")
        }
    }
    
    func updateDevice(name: String, ip: String, reachable: Bool) {
        let fetchRequest: NSFetchRequest<DeviceEntity> = DeviceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            let device = results.first ?? DeviceEntity(context: context)
            
            device.name = name
            device.ipAddress = ip
            device.isReachable = reachable
            
            try context.save()
            
            let reloadRequest: NSFetchRequest<DeviceEntity> = DeviceEntity.fetchRequest()
            devices = try context.fetch(reloadRequest)
        } catch {
            print("Save Error: \(error)")
        }
    }
    
    var numberOfDevices: Int {
        devices.count
    }
    
    func device(at index: Int) -> DeviceEntity {
        devices[index]
    }
}


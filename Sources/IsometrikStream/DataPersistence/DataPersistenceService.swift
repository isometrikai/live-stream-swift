import Foundation
import SwiftData

public enum DataPersistenceServiceError: Error {
    case invalid
    case unknown
    case contextNotFound
    case none
}

final public class DataPersistenceService {
    
    private static var sharedInstance: DataPersistenceService!
    
    private var container: ModelContainer?
    public var context: ModelContext?
    
    public static func getInstance() -> DataPersistenceService {
        if sharedInstance == nil {
            sharedInstance = DataPersistenceService()
        }
        return sharedInstance
    }
    
    public func createContainer(persistentModel: any PersistentModel.Type){
        do {
            let container = try ModelContainer(for: persistentModel)
            self.container = container
            self.context = ModelContext(container)
        } catch {
            print(error)
        }
    }
    
    public func saveData<T: PersistentModel>(dataModel: T?){
        guard let context,
              let dataModel
        else { return }
        context.insert(dataModel)
    }
    
    public func fetchData<T>(descriptor: FetchDescriptor<T>) async throws -> Result<[T]?, DataPersistenceServiceError> {
        
        guard let context
        else { return .failure(DataPersistenceServiceError.contextNotFound) }
        
        do{
            let data = try context.fetch(descriptor)
            return .success(data)
        } catch{
            return .failure(DataPersistenceServiceError.invalid)
        }
        
    }
    
    func updateData(){
        
    }
    
    public func deleteData(dataModel: any PersistentModel){
        guard let context
        else { return }
        context.delete(dataModel)
    }
    
}

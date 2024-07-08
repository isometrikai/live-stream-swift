
import UIKit

final public class Debouncer {
    
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    public init(queue: DispatchQueue = .main, delay: TimeInterval) {
        self.queue = queue
        self.delay = delay
    }
    
    public func debounce(action: @escaping()->Void){
        
        // Cancel the previous task if it's still pending
        workItem?.cancel()
        
        // Create a new work item with the given action
        workItem = DispatchWorkItem(block: action)
        
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
        
    }
    
}

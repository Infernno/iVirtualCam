import Foundation
import Combine

public extension NotificationCenter {
    func forEvents(_ events: NSNotification.Name...) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        let pubs = events.map { event in
            publisher(for: event)
        }
        
        return Publishers.MergeMany(pubs).eraseToAnyPublisher()
    }
}

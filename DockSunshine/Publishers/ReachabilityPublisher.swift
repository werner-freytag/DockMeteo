import Combine
import Foundation
import Reachability

public class ReachabilityPublisher {
    static let shared = ReachabilityPublisher()

    private var reachability: Reachability?
    private let subject = PassthroughSubject<Reachability, Never>()
    private var cancellable = Set<AnyCancellable>()

    func startNotifier() throws -> AnyPublisher<Reachability, Never> {
        if reachability == nil {
            reachability = try Reachability()
        }
        try reachability?.startNotifier()

        NotificationCenter.default.publisher(for: .reachabilityChanged)
            .compactMap { $0.object as? Reachability }
            .sink { self.subject.send($0) }
            .store(in: &cancellable)

        return subject.eraseToAnyPublisher()
    }
}

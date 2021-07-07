//
//  NetworkMonitor.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import Network

/// Network monitor.
class NetworkMonitor {
    
    /// NWPath monitor.
    private let monitor = NWPathMonitor()
    
    /// NWPath.Status.
    private var status: NWPath.Status = .requiresConnection
    
    /// Shared instance.
    static let shared = NetworkMonitor()
    
    /// Bool for reachable status.
    var isReachable: Bool {
        status == .satisfied
    }
    
    /// Initializer
    private init() {
        startMonitoring()
    }
    
    /// Start monitoring.
    func startMonitoring() {
        
        // Path update handler.
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        
        // Create queue.
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        // Start monitoring.
        monitor.start(queue: queue)
    }
    
    /// Stop monitoring.
    func stopMonitoring() {
        monitor.cancel()
    }
}

//
//  NetworkMonitor.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import Network

/// Protocol for network status checking.
protocol NetworkStatusProvider {
    var isConnected: Bool { get }
}

/// Monitors real-time network connectivity status using `NWPathMonitor`.
class NetworkMonitor: NetworkStatusProvider {
    
    /// Singleton instance to access network monitoring across the app.
    static let shared = NetworkMonitor()
    
    /// NWPathMonitor to detect network changes.
    private let monitor = NWPathMonitor()
    
    /// Dispatch queue where monitoring runs.
    private let queue = DispatchQueue.global(qos: .background)
    
    /// Tracks whether the device is connected to the internet.
    public private(set) var isConnected: Bool = false
    
    /// Private initializer to enforce singleton usage.
    private init() {}
    
    /// Starts listening for network status updates.
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("Network status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
        }
        monitor.start(queue: queue)
    }
    
    /// Stops listening for network changes.
    func stopMonitoring() {
        monitor.cancel()
    }
}

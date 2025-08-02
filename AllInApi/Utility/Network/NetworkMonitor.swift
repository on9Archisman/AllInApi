//
//  NetworkMonitor.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import Network
 
protocol NetworkStatusProvider {
    var isConnected: Bool { get }
}

class NetworkMonitor: NetworkStatusProvider {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    public private(set) var isConnected: Bool = false
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("Network status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

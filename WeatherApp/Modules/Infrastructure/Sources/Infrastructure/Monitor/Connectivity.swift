//
//  NetworkConnectionMonitor.swift
//  Infrastructure
//
//  Created by Deiner Calbang on 3/21/25.
//

import Foundation
import Network

public class NetworkConnectionMonitor: @unchecked Sendable {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    private var isConnectedStatus: Bool = false
    private var isReachable: Bool = false
    private let hostname = "https://www.google.com"

    public var onStatusChange: ((Bool) -> Void)?

    public var isConnected: Bool {
        return isConnectedStatus
    }

    public init() {
        self.monitor = NWPathMonitor()
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let isReachable = (path.status == .satisfied)

            Task {
                let checkReachability = await self.checkReachability()
                let newStatus = isReachable && checkReachability
                
                if self.isConnectedStatus != newStatus {
                    self.isConnectedStatus = newStatus
                    DispatchQueue.main.async {
                        self.onStatusChange?(newStatus)
                    }
                }
            }
            
        }
        self.monitor.start(queue: queue)
    }
    
    private func checkReachability() async -> Bool {
        guard let url = URL(string: hostname) else { return false }

        var request = URLRequest(url: url)
        request.timeoutInterval = 3

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}

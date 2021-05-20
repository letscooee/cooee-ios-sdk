//
//  Reachability.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 15/05/21.
//

import Foundation
import Network


final class NetworkMonitor{
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
   
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue )
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkConnected"), object: nil, userInfo: nil)
            self?.getConnectionType(path)
            print("network connected \(self?.isConnected)")
           
    }
    }
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectioonType(){
        
    }
    
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        }else if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }else{
            connectionType = .unknown
        }
    }
}


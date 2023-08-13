//
//  DiagnosticsModel.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-03.
//

import Foundation
import CoreBluetooth

class DiagnosticsModel: NSObject {
    var deviceName: String = ""
    var macAddress: String = ""
    var timeStamp: TimeInterval?
    var peripheral: CBPeripheral?
    
    override init () {
        super.init()
    }
    
    init(deviceName: String, macAddress: String, timeStamp: TimeInterval, peripheral: CBPeripheral?) {
        self.deviceName = deviceName
        self.macAddress = macAddress
        self.timeStamp = timeStamp
        self.peripheral = peripheral
    }
}

//
//  DeviceDetails.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-04.
//

import Foundation

class DeviceDetails: NSObject {
    var services = [Service]()
}

class Service: NSObject {
    var id: String = ""
    var isPrimary: Bool = false
    var characteristics = [Characteristic]()
    
    init(id: String, isPrimary: Bool) {
        self.id = id
        self.isPrimary = isPrimary
    }
}

class Characteristic: NSObject {
    var id: String = ""
    var properties: UInt = 0
    var descriptors = [Descriptor]()
    
    init(id: String, properties: UInt) {
        self.id = id
        self.properties = properties
    }
}

class Descriptor: NSObject {
    var id: String = ""
    var descriptorValue: String = ""
    
    init(id: String, descriptorValue: String) {
        self.id = id
        self.descriptorValue = descriptorValue
    }
}

//
//  DeviceDetailsVC.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-04.
//

import UIKit
import CoreBluetooth

class DeviceDetailsVC: UIViewController {
    var peripheral: CBPeripheral?
    var deviceDetails = DeviceDetails()
    
    let servicesTableView = UITableView()
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicesTableView.dataSource = self
        servicesTableView.delegate = self
        servicesTableView.separatorStyle = .none
        servicesTableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: ServiceTableViewCell.reuseIdentifier)
        servicesTableView.rowHeight = UITableView.automaticDimension
        
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        navigationItem.title = "Device Details"
        
        view.addSubview(servicesTableView)
        servicesTableView.pinToView(view: view, padding: 0)
    }
    
    private func configureData() {
        if let peripheral = peripheral {
            configureServicesData(peripheral: peripheral)
        }
    }
    
    private func configureServicesData(peripheral: CBPeripheral) {
        if let services = peripheral.services {
            for service in services {
                let serviceObj = Service(id: service.uuid.uuidString, isPrimary: service.isPrimary)
                deviceDetails.services.append(serviceObj)
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            servicesTableView.reloadData()
        }
    }
}

extension DeviceDetailsVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        if let details = deviceDetails.services.first(where: {
            $0.id == service.uuid.uuidString
        }) {
            for characteristic in characteristics {
                let characteristicObj = Characteristic(id: characteristic.uuid.uuidString, properties: characteristic.properties.rawValue)
                details.characteristics.append(characteristicObj)
                
                peripheral.discoverDescriptors(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else {
            return
        }
        
        if let characteristicObj = deviceDetails.services.flatMap({ $0.characteristics }).first(where: { $0.id == characteristic.uuid.uuidString }) {
            for descriptor in descriptors {
                let descriptorObj = Descriptor(id: descriptor.uuid.uuidString, descriptorValue: "\(descriptor.value ?? "")")
                characteristicObj.descriptors.append(descriptorObj)
            }
        }
    }
}

extension DeviceDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceDetails.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.reuseIdentifier, for: indexPath) as? ServiceTableViewCell {
            let propertyStr = "Primary: \(deviceDetails.services[indexPath.row].isPrimary)"
            cell.configureData(id: deviceDetails.services[indexPath.row].id, properties: propertyStr, showArrow: true)
            cell.selectionStyle = .none 

            return cell
        }
        
        return UITableViewCell()
    }
}

extension DeviceDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characteristicDetailsVC = CharacteristicDetailsVC()
        characteristicDetailsVC.charactersitics = deviceDetails.services[indexPath.row].characteristics
        self.navigationController?.pushViewController(characteristicDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

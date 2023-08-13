//
//  ViewController.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-02.
//

import UIKit
import CoreBluetooth

private enum Constants {
    static let scanButtonHeight: CGFloat = 50
    static let navBarHeight: CGFloat = 44
    static let scanButtonSpacing: CGFloat = 8
    static let scanButtonWrapperSpacing: CGFloat = 30
}

class ViewController: UIViewController {
    var centralManager: CBCentralManager?
    var diagnosticsData = [DiagnosticsModel]()
    var sortAlertController = UIAlertController()
    
    private let tableView = UITableView()
    private let scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan Devices", for: .normal)
        button.layer.cornerRadius = Constants.scanButtonHeight / 2
        button.heightAnchor.constraint(equalToConstant: Constants.scanButtonHeight).isActive = true
        button.backgroundColor = UIColor.appGray()
        button.setTitleColor(UIColor.buttonTitleBlue(), for: .normal)
        return button
    }()
    private let stopScanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop Scan", for: .normal)
        button.layer.cornerRadius = Constants.scanButtonHeight / 2
        button.heightAnchor.constraint(equalToConstant: Constants.scanButtonHeight).isActive = true
        button.backgroundColor = UIColor.appGray()
        button.setTitleColor(UIColor.buttonTitleBlue(), for: .normal)
        return button
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DiagnosticsTableViewCell.self, forCellReuseIdentifier: DiagnosticsTableViewCell.reuseIdentifier)
        setupUI()
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        navigationItem.title = "Bluetooth Diagnostics"
        
        let image = UIImage.init(systemName: "list.dash")
        let sortButton = UIButton()
        sortButton.setImage(image, for: .normal)
        sortButton.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = barButtonItem

    }
    
    private func setupUI() {
        setupNavBar()
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        view.addSubview(verticalStackView)
        verticalStackView.pinToView(view: view, padding: 0)
        verticalStackView.addArrangedSubview(tableView)
        
        let scanButtonStackView = UIStackView()
        scanButtonStackView.axis = .horizontal
        scanButtonStackView.spacing = Constants.scanButtonSpacing
        scanButtonStackView.distribution = .fillEqually
        view.addSubview(scanButtonStackView)
        scanButtonStackView.addArrangedSubview(scanButton)
        scanButtonStackView.addArrangedSubview(stopScanButton)
        
        scanButton.addTarget(self, action: #selector(scanDevices), for: .touchUpInside)
        stopScanButton.addTarget(self, action: #selector(stopScan), for: .touchUpInside)
        
        let buttonWrapperView = UIView()
        buttonWrapperView.addSubview(scanButtonStackView)
        scanButtonStackView.pinToView(view: buttonWrapperView, padding: Constants.scanButtonWrapperSpacing)
        verticalStackView.addArrangedSubview(buttonWrapperView)
        
        addActivityIndicator()
        setupSortOptions()
    }
    
    @objc private func scanDevices() {
        if let centralManager = centralManager, centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            tableView.reloadData()
            tableView.isHidden = false
            
            scanButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
            scanButton.isEnabled = false
        } else {
            showError(error: "Bluetooth is not available")
        }
    }
    
    @objc private func stopScan() {
        scanButton.setTitle("Scan Devices", for: .normal)
        activityIndicator.stopAnimating()
        scanButton.isEnabled = true
        if let centralManager = centralManager {
            centralManager.stopScan()
        }
    }
    
    private func setupSortOptions() {
        sortAlertController = UIAlertController(title: "Sort Options", message: "Select an option to sort devices", preferredStyle: .actionSheet)

        let sortByMacAddressAction = UIAlertAction(title: "MAC Address", style: .default) { (action) in
            self.diagnosticsData.sort {
                $0.macAddress < $1.macAddress
            }
            self.tableView.reloadData()
        }
        
        let sortByLastScanned = UIAlertAction(title: "Time", style: .default) { (action) in
            self.diagnosticsData.sort {
                if let t1 = $0.timeStamp, let t2 = $1.timeStamp {
                    return t1 > t2
                }
                return false
            }
            self.tableView.reloadData()
        }

        let sortByNameAction = UIAlertAction(title: "Name", style: .default) { (action) in
            self.sortByName()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        sortAlertController.addAction(sortByMacAddressAction)
        sortAlertController.addAction(sortByLastScanned)
        sortAlertController.addAction(sortByNameAction)
        sortAlertController.addAction(cancelAction)
    }
    
    private func sortByName() {
        diagnosticsData.sort {
            $0.deviceName < $1.deviceName
        }
        tableView.reloadData()
    }
    
    @objc private func showSortOptions() {
        present(sortAlertController, animated: true, completion: nil)
    }
    
    private func addActivityIndicator() {
        activityIndicator.color = UIColor.activityIndicatorGray()
        scanButton.addSubview(activityIndicator)
        activityIndicator.centerInView(view: scanButton)
    }
    
    private func showError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagnosticsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DiagnosticsTableViewCell.reuseIdentifier, for: indexPath) as? DiagnosticsTableViewCell {
            cell.selectionStyle = .none 
            cell.configureData(
                name: diagnosticsData[indexPath.row].deviceName,
                address: diagnosticsData[indexPath.row].macAddress,
                peripheral: diagnosticsData[indexPath.row].peripheral
            )
            cell.connectButtonHandler = {
                if let centralManager = self.centralManager,
                    let peripheral = self.diagnosticsData[indexPath.row].peripheral {
                    if peripheral.state == .disconnected {
                        centralManager.connect(peripheral, options: nil)
                        cell.setButtonState(peripheralState: .connecting)
                    } else if peripheral.state == .connected {
                        centralManager.cancelPeripheralConnection(peripheral)
                        cell.setButtonState(peripheralState: .disconnecting)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let peripheral = diagnosticsData[indexPath.row].peripheral, peripheral.state == .connected {
            let deivceDetailsVC = DeviceDetailsVC()
            deivceDetailsVC.peripheral = peripheral
            self.navigationController?.pushViewController(deivceDetailsVC, animated: true)
        }
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is on")
        case .poweredOff:
            showError(error: "Please turn on bluetooth")
        case .unauthorized:
            showError(error: "Please authorize bluetooth persimissions")
        default:
            showError(error: "Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !diagnosticsData.contains(where: {
            $0.macAddress == peripheral.identifier.uuidString
        }) {
            let newDiagnosticsData = DiagnosticsModel()
            newDiagnosticsData.deviceName = peripheral.name ?? "Unknown"
            newDiagnosticsData.macAddress = peripheral.identifier.uuidString
            newDiagnosticsData.timeStamp = Date().timeIntervalSince1970
            newDiagnosticsData.peripheral = peripheral
            
            diagnosticsData.append(newDiagnosticsData)
            
            sortByName()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let data = diagnosticsData.first (where: {
            $0.macAddress == peripheral.identifier.uuidString
        }) {
            data.peripheral = peripheral
            tableView.reloadData()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let data = diagnosticsData.first (where:{
            $0.macAddress == peripheral.identifier.uuidString
        }) {
            data.peripheral = peripheral
            tableView.reloadData()
        }
    }
}

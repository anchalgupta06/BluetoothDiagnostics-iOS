//
//  DiagnosticsTableViewCell.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-03.
//

import UIKit
import CoreBluetooth

private enum Constants {
    static let cellPadding: CGFloat = 8
    static let stackSpacing: CGFloat = 8
    static let wrapperCornerRadius: CGFloat = 4
    static let connectButtonHeight: CGFloat = 20
}

class DiagnosticsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DiagnosticsTableViewCell"
    
    var connectButtonHandler: (() -> Void)?
    
    private let wrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.wrapperCornerRadius
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let connectionButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: Constants.connectButtonHeight).isActive = true
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupUI() {
        contentView.addSubview(wrapperView)
        wrapperView.pinToView(view: contentView, padding: Constants.cellPadding)
        wrapperView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        let buttonWrapperView = UIView()
        buttonWrapperView.addSubview(connectionButton)
        connectionButton.pinToLeft(view: buttonWrapperView, padding: 0)
        
        stackView.addArrangedSubview(buttonWrapperView)
        stackView.pinToView(view: wrapperView, padding: Constants.cellPadding)
    }
    
    func configureData(name: String, address: String, peripheral: CBPeripheral?) {
        nameLabel.text = name
        addressLabel.text = address
        if let peripheral = peripheral {
            setButtonState(peripheralState: peripheral.state)
        }
    }
    
    func setButtonState(peripheralState: CBPeripheralState) {
        switch peripheralState {
        case .connected:
            connectionButton.setTitle("Connected", for: .normal)
            connectionButton.setTitleColor(UIColor.connectedGreen(), for: .normal)
        case .connecting:
            connectionButton.setTitle("Connecting...", for: .normal)
            connectionButton.setTitleColor(UIColor.connectingGray(), for: .normal)
        case .disconnecting:
            connectionButton.setTitle("Disconnecting...", for: .normal)
            connectionButton.setTitleColor(UIColor.connectingGray(), for: .normal)
        default:
            connectionButton.setTitle("Not connected", for: .normal)
            connectionButton.setTitleColor(UIColor.notConnectedBlue(), for: .normal)
        }
    }
    
    @objc private func connectTapped() {
        connectButtonHandler?()
    }

}

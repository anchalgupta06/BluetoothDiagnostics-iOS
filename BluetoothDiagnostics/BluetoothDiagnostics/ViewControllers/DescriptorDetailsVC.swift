//
//  DescriptorDetailsVC.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-07.
//

import UIKit

class DescriptorDetailsVC: UIViewController {
    let descriptorsTableView = UITableView()
    
    var descriptors = [Descriptor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptorsTableView.dataSource = self
        descriptorsTableView.delegate = self
        descriptorsTableView.separatorStyle = .none
        descriptorsTableView.rowHeight = UITableView.automaticDimension
        descriptorsTableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: ServiceTableViewCell.reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Characteristic Details"
        
        view.addSubview(descriptorsTableView)
        descriptorsTableView.pinToView(view: view, padding: 0)
    }
}

extension DescriptorDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.reuseIdentifier, for: indexPath) as? ServiceTableViewCell {
            cell.selectionStyle = .none 
            let propertyStr = "Descriptor value: \(descriptors[indexPath.row].descriptorValue)"
            cell.configureData(id: descriptors[indexPath.row].id, properties: propertyStr, showArrow: true)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension DescriptorDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

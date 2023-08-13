//
//  CharacteristicDetailsVC.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-06.
//

import UIKit

class CharacteristicDetailsVC: UIViewController {
    let charactersiticsTableView = UITableView()
    
    var charactersitics = [Characteristic]()

    override func viewDidLoad() {
        super.viewDidLoad()
        charactersiticsTableView.dataSource = self
        charactersiticsTableView.delegate = self
        charactersiticsTableView.separatorStyle = .none
        charactersiticsTableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: ServiceTableViewCell.reuseIdentifier)
        charactersiticsTableView.rowHeight = UITableView.automaticDimension
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Characteristic Details"
        
        view.addSubview(charactersiticsTableView)
        charactersiticsTableView.pinToView(view: view, padding: 0)
    }
}

extension CharacteristicDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersitics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ServiceTableViewCell.reuseIdentifier, for: indexPath) as? ServiceTableViewCell {
            cell.selectionStyle = .none 
            let propertyStr = "Properties raw value: \(charactersitics[indexPath.row].properties)"
            cell.configureData(id: charactersitics[indexPath.row].id, properties: propertyStr, showArrow: true)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension CharacteristicDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptorDetailsVC = DescriptorDetailsVC()
        descriptorDetailsVC.descriptors = charactersitics[indexPath.row].descriptors
        self.navigationController?.pushViewController(descriptorDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//
//  ServiceTableViewCell.swift
//  BluetoothDiagnostics
//
//  Created by Anchal Gupta on 2023-03-06.
//

import UIKit

private enum Constants {
    static let cellPadding: CGFloat = 8
    static let stackSpacing: CGFloat = 8
    static let wrapperCornerRadius: CGFloat = 4
    static let arrowImageSize: CGFloat = 16
}

class ServiceTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ServiceTableViewCell"
    
    private let wrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.wrapperCornerRadius
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let propertiesLabel: UILabel = {
        let label = UILabel(type: .subText)
        return label
    }()
    
    private let imageWrapperView = UIView()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: Constants.arrowImageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.arrowImageSize).isActive = true
        
        return imageView
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
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Constants.stackSpacing
        verticalStackView.addArrangedSubview(idLabel)
        verticalStackView.addArrangedSubview(propertiesLabel)
        
        arrowImageView.image = UIImage.init(systemName: "chevron.right")
        imageWrapperView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageWrapperView.addSubview(arrowImageView)
        arrowImageView.centerInView(view: imageWrapperView)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(imageWrapperView)
        
        wrapperView.addSubview(horizontalStackView)
        horizontalStackView.pinToView(view: wrapperView, padding: Constants.cellPadding)
    }
    
    func configureData(id: String, properties: String, showArrow: Bool) {
        idLabel.text = id
        propertiesLabel.text = properties
        imageWrapperView.isHidden = !showArrow
        
    }
}

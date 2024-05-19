//
//  ContactsView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsView: UIView {
    
    let viewModel : ContactsViewModel
    
    var contacts : [ContactInfo] = []
    
    private let bag = DisposeBag()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let contactsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(frame: CGRect, viewModel : ContactsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        setUpTableView()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView() {
        contactsTableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    private func setUpBindings() {
        
        viewModel
            .isFetching
            .bind(to: self.spinner.rx.isAnimating,self.contactsTableView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel
            .contacts
            .bind(to: self.contactsTableView.rx.items(
                cellIdentifier: ContactsTableViewCell.cellIdentifier,
                cellType: ContactsTableViewCell.self)
            ) {row,item,cell in
                cell.configureCell(contact: item)
            }.disposed(by: bag)
        
        self.contactsTableView.rx.modelSelected(ContactInfo.self)
            .bind { contact in
                print("SEÇİLEN KİŞİ İSİM : \(contact.name) SEÇİLEN KİŞİ TELEFON :\(contact.phone)")
            }.disposed(by: bag)
        
        viewModel.fetchContacts()
        
    }
    
    private func setUpConstraints() {
        
        addSubViews(spinner,contactsTableView)
        
        NSLayoutConstraint.activate([
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            contactsTableView.topAnchor.constraint(equalTo: topAnchor),
            contactsTableView.leftAnchor.constraint(equalTo: leftAnchor),
            contactsTableView.rightAnchor.constraint(equalTo: rightAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
}

extension ContactsView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


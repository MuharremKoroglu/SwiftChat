//
//  ChatView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.07.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ChatView: UIView {
    
    let viewModel : ChatsViewModel
    
    let selectedChat = PublishSubject<RecentMessageModel>()
    
    let deletedChat = PublishSubject<RecentMessageModel>()
    
    var recentMessages : [RecentMessageModel] = []
    
    private let bag = DisposeBag()
    
    private let chatsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: ChatsTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        return tableView
    }()
    
    init(viewModel : ChatsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        setUpTableView()
        setUpBindings()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ChatView {
    
    
    func setUpViews() {
        
        addSubViews(
            chatsTableView
        )
    }
    
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            chatsTableView.topAnchor.constraint(equalTo: topAnchor),
            chatsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chatsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }
    
    func setUpTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
    }
    
    func setUpBindings () {
        
        viewModel
            .recentMessages
            .subscribe(onNext: { [weak self] recentMessages in
                self?.recentMessages = recentMessages
                self?.chatsTableView.reloadData()
            }).disposed(by: bag)

    }
}

extension ChatView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatsTableViewCell.cellIdentifier,
            for: indexPath
        ) as? ChatsTableViewCell else {
            fatalError("This cell not supported!")
        }
        cell.configure(with: recentMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tappedRecentMessage = recentMessages[indexPath.row]
        selectedChat.onNext(tappedRecentMessage)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recentMessage = recentMessages[indexPath.row]
            deletedChat.onNext(recentMessage)
        }
    }
    
}

//
//  MessageView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit
import RxSwift
import RxCocoa

class MessageView: UIView {
    
    let user : ContactModel
    
    let viewModel : MessageViewModel
    
    private let bag = DisposeBag()
    
    private var messages : [MessageModel] = []
    
    private let messagesTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: MessagesTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let addMediaButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonImage: UIImage(systemName: "plus.circle.fill")
        )
        return button
    }()
    
    private let messageTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .systemGray.withAlphaComponent(0.3)
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    private let sendMessageButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Send",
            buttonColor: .systemOrange
        )
        return button
    }()
    
    private let messageStackView : CustomUIStackView = {
        let stackView = CustomUIStackView(
            stackAxis: .horizontal,
            componentAlignment: .center,
            componentSpacing: 10
        )
        return stackView
    }()
    
    
    init(user : ContactModel, viewModel : MessageViewModel) {
        self.user = user
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpTableView()
        setUpViews()
        setUpConstraints()
        setUpBindings()
        scrollToBottom()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MessageView {
    
    func setUpTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
    func setUpViews() {
        
        addSubViews(
            messagesTableView,
            messageStackView
        )
        
        messageStackView.addArrangedSubview(addMediaButton)
        messageStackView.addArrangedSubview(messageTextView)
        messageStackView.addArrangedSubview(sendMessageButton)
        
        addMediaButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addMediaButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        messageTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            messagesTableView.topAnchor.constraint(equalTo: topAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: messageStackView.topAnchor),
            
            
            messageStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            messageStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            messageStackView.heightAnchor.constraint(equalToConstant: 40),
            
            addMediaButton.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
        
            messageTextView.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
            
            sendMessageButton.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
            sendMessageButton.widthAnchor.constraint(equalTo: messageStackView.widthAnchor, multiplier: 0.18),
            
            
            
        ])
        
        
    }
    
    func setUpBindings() {
        
        viewModel
            .messages
            .subscribe(onNext: { [weak self] messages in
                self?.messages = messages
                self?.messagesTableView.reloadData()
                self?.scrollToBottom()
            })
            .disposed(by: bag)
        
        
        sendMessageButton
            .rx
            .tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.sendMessage(
                    message: self.messageTextView.text
                )
                self.messageTextView.text = ""
            }
            .disposed(by: bag)
        
        
    }
    
    func scrollToBottom() {
        guard !messages.isEmpty else { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

}

extension MessageView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessagesTableViewCell.cellIdentifier,
            for: indexPath
        ) as? MessagesTableViewCell else {
            fatalError("This cell not supported!")
        }
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
}

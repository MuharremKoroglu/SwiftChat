//
//  MessageViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit
import RxSwift
import RxCocoa

class MessageViewController: UIViewController {
    
    private let user : ContactModel
    
    private let messageView : MessageView
    
    private let viewModel : MessageViewModel
    
    private let bag = DisposeBag()
    
    private let userProfileImage : CustomUIImageView = {
        let image = CustomUIImageView(
            isCircular: true
        )
        return image
    }()
    
    init(user: ContactModel) {
        self.user = user
        self.viewModel = MessageViewModel(user: user)
        self.messageView = MessageView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        setUpContraints()
        setUpUserProfile()
        setUpNavigationBar()
        setUpBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.removeListener()
    }

}

private extension MessageViewController {
    
    func setUpView() {
        
        view.addSubViews(
            messageView
        )

    }
    
    func setUpContraints() {
        
        NSLayoutConstraint.activate([
            
            messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            messageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            userProfileImage.widthAnchor.constraint(equalToConstant: 32),
            userProfileImage.heightAnchor.constraint(equalToConstant: 32)
            
        ])
        
    }
    
    func setUpNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = user.name
                        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userProfileImage)
        
    }
    
    func setUpUserProfile() {
        
        Task {
            
            let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: user.profileImageURL)
            
            switch result {
            case .success(let imageData):
                guard let profileImage = UIImage(data: imageData) else {return}
                userProfileImage.image = profileImage
            case .failure(_):
                let profileImage = UIImage(resource: .anonUser)
                userProfileImage.image = profileImage
            }

        }

    }
    
    func setUpBindings() {
        
        messageView.addMediaButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                SCAlertManager.presentAlert(viewController: strongSelf, alertType: .sendMedia(
                    cameraHandler: {
                        SCImagePickerManager.pickImage(
                            from: .camera,
                            in: strongSelf
                        )
                    },
                    photoLibraryHandler: {
                        SCImagePickerManager.pickImage(
                            from: .photoLibrary,
                            in: strongSelf
                        )
                    })
                )
            })
            .disposed(by: bag)
    }
    
}

extension MessageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage,
        let compressedImage = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        viewModel.sendMessage(mediaMessage: compressedImage)
        
    }
    
}

//
//  SettingsViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 13.05.2024.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import SafariServices

class SettingsViewController: UIViewController {
    
    private let chatMessages : BehaviorSubject<[RecentMessageModel]>
    
    private var chatMessagesReceiverIds : [String] = []
    
    private let settingsView : UIHostingController<SettingsSwiftUIView>
    
    private let viewModel : SettingsViewModel
    
    private let bag = DisposeBag()
    
    private let spinner : CustomUIActivityIndicator = {
        let indicator = CustomUIActivityIndicator()
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSwiftUIView()
        setUpConstraints()
        setUpBindings()
    }
    
    init(viewModel : SettingsViewModel,chatMessages : BehaviorSubject<[RecentMessageModel]>) {
        self.viewModel = viewModel
        self.chatMessages = chatMessages
        self.settingsView = UIHostingController(rootView: SettingsSwiftUIView(viewModel: viewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchUserData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.removeListener()
    }
    
}

private extension SettingsViewController {
    
    func setUpSwiftUIView() {
        
        addChild(settingsView)
        settingsView.didMove(toParent: self)
        
        view.addSubViews(
            settingsView.view,
            spinner
        )
        
    }
    
    func setUpConstraints() {
        
        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            settingsView.view.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingsView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
    }
    
    func setUpBindings() {
        
        viewModel
            .isProcessing
            .bind(to: self.spinner.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel
            .isCompleted
            .subscribe (onNext: { [weak self] isCompleted in
                if isCompleted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let signInViewController = SignInViewController()
                        signInViewController.modalPresentationStyle = .fullScreen
                        self?.present(signInViewController, animated: true)
                    }
                }
            }).disposed(by: bag)
        
        settingsView
            .rootView
            .editButtonTapped
            .subscribe(onNext: { [weak self] tapped in
                guard let strongSelf = self else {return}
                if tapped {
                    SCAlertManager.presentAlert(
                        viewController: strongSelf,
                        alertType: .changeProfilePicture(
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
                            }
                        )
                    )
                }
            }).disposed(by: bag)
        
        settingsView
            .rootView
            .selectedSetting
            .subscribe (onNext: { [weak self] setting in
                guard let strongSelf = self else {return}
                switch setting.settingType {
                case .deleteMyAccount:
                    SCAlertManager.presentAlert(viewController: strongSelf, alertType: .deleteAccount(deleteAccountHandler: {
                        strongSelf.viewModel.deleteAccount(with: strongSelf.chatMessagesReceiverIds)
                        
                    }))
                case .signOut:
                    SCAlertManager.presentAlert(viewController: strongSelf, alertType: .signOut(signOutHandler: {
                        strongSelf.viewModel.signOut()
                    }))
                default:
                    guard let url = setting.settingUrl else {return}
                    let safariViewController = SFSafariViewController(url: url)
                    strongSelf.present(safariViewController, animated: true)
                }
            }).disposed(by: bag)
        
        chatMessages
            .subscribe (onNext: { recentMessages in
                self.chatMessagesReceiverIds = recentMessages.compactMap({$0.receiverProfile.id})
            }).disposed(by: bag)
        
    }
    
}

extension SettingsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage,
        let compressedImage = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        viewModel.updateUserProfilePicture(with: compressedImage)
        
    }
    
}



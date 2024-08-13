//
//  SettingsSwiftUIView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 3.08.2024.
//

import SwiftUI
import RxSwift
import RxCocoa

struct SettingsSwiftUIView: View {
    
    @State private var user: ContactModel?
    
    let selectedSetting = PublishSubject<SettingModel>()
    
    let editButtonTapped = PublishSubject<Bool>()
    
    let viewModel : SettingsViewModel
    
    private let bag = DisposeBag()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                HStack(alignment: .center,spacing: 15) {
                    if let user = user {
                        VStack {
                            AsyncImage(url: user.profileImageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60,height: 60)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Button("Edit") {
                                editButtonTapped.onNext(true)
                            }.foregroundStyle(.orange)
                            
                        }
                        
                        VStack(alignment: .leading,spacing: 10) {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.phone)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text(user.email)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                    
                }
                
            }
            
            ForEach(SettingsSectionTypes.allCases, id: \.self) { section in
                Section {
                    ForEach(section.buttons, id: \.id) { button in
                        Button(role: section == .account ? .destructive : nil){
                            selectedSetting.onNext(button)
                        } label: {
                            HStack {
                                if let icon = button.settingIcon {
                                    Image(uiImage: icon)
                                        .renderingMode(.template)
                                }
                                Text(button.settingTitle)
                            }
                        }.tint(.primary)
                        
                    }
                    
                }
                
            }
        }.onAppear {
            setUpBindings()
        }
        
        
    }
    
    
}

private extension SettingsSwiftUIView {
    
    func setUpBindings() {
       
        viewModel
            .user
            .asObservable()
            .bind { user in
                self.user = user
            }
            .disposed(by: bag)
    }
    
}

#Preview {
    SettingsSwiftUIView(viewModel: SettingsViewModel())
}

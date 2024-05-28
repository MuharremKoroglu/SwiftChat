//
//  LottieAnimation.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import Foundation
import Lottie

class CustomLottieAnimation : LottieAnimationView {
    
    let animationName : String
    
    init(animationName : String) {
        self.animationName = animationName
        super.init(frame: .zero)
        setUpLottiAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLottiAnimation() {
        
        translatesAutoresizingMaskIntoConstraints = false
        animation = .named(self.animationName)
        contentMode = .scaleAspectFit
        loopMode = .loop
        play()
        
        
    }
 
}

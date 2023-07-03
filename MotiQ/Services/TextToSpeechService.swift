//
//  TextToSpeechService.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 04.07.2023.
//

import Foundation
import Combine
import AVFoundation
import Speech


class TextToSpeech: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.pitchMultiplier = 1.3
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

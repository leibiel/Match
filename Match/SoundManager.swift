//
//  SoundManager.swift
//  Match
//
//  Created by Gabriel Campos on 04/06/2018.
//  Copyright © 2018 Gabriel Campos. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect)  {
        
        var soundFilename = ""
        
        // Determinar qual som tocar
        // Setar o nome apropriado 
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        // Obter o caminho para o arquivo de som dentro do pacote
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Arquivo de audio \(soundFilename) não encontrado no pacote")
            return
        }
        
        // Criar um objeto URL do caminho em string
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Criar o objeto audio player
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Tocar o som
            audioPlayer?.play()
            
        }
        catch {
            // Não pôde criar o objeto de audio, então logue o erro
            print("O arquivo de audio não pôde ser criado com o arquivo \(soundFilename)")
        }
    }
}

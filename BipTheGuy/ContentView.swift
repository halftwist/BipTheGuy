//
//  ContentView.swift
//  BipTheGuy
//
//  Created by John Kearon on 3/30/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!  // inplictily unwrapped
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("clown")
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    playSound(soundName: "punchSound")
                }
            
            Spacer()
            
            Button {
                //TODO: Button action here
            } label: {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()

        }
        .padding()
    }
    
    func playSound(soundName: String) {
        
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }

        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not find sound file \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }

    }

    
}

#Preview {
    ContentView()
}

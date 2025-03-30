//
//  ContentView.swift
//  BipTheGuy
//
//  Created by John Kearon on 3/30/25.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!  // inplictily unwrapped
    //    @State private var scale = 1.0  // 100% scale, or orginal size
    @State private var isFullSize = true
    @State private var selectedPhoto: PhotosPickerItem? // optional
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            //            Image("clown")
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    //                    scale = scale + 0.1  // Increase scale by 10%
                    isFullSize = false // will immediately shrink using .scaleEffect to 90% of size
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        isFullSize = true // will go from 90% to 100% size but using the .spring animation
                    }
                }
            //                .animation(.spring(response: 0.3, dampingFraction: 0.3), value: scale)
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    guard let selectedImage = try? await
                            selectedPhoto?.loadTransferable(type: Image.self) else {
                        print("😡 ERROR: Could not get Image from loadTransferrable")
                        return
                    }
                    bipImage = selectedImage
                }
            }
            
//        }
        //            Button {
        //                //TODO: Button action here
        //            } label: {
        //                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
        //            }
        //            .buttonStyle(.borderedProminent)
        
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

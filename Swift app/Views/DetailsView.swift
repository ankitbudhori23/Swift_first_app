import SwiftUI
import AVKit
import AVFoundation

struct DetailsView: View {
    let item: HomeItem
    @State private var player: AVPlayer?
    @State private var isMuted = false
    @State private var isPlaying = true
    @StateObject private var narrationController = NarrationController()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroMedia
                Text(item.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                Text(item.primaryCategory)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())
                Text(item.displayDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                HStack(spacing: 24) {
                    Label(item.viewsLabel, systemImage: "play.fill")
                    Label(item.ratingLabel, systemImage: "star.fill")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Button(action: toggleNarration) {
                    Label(narrationController.isSpeaking ? "Stop Voice" : "Listen", systemImage: narrationController.isSpeaking ? "stop.fill" : "waveform")
                        .font(.callout.weight(.semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear(perform: preparePlayerIfNeeded)
        .onDisappear {
            player?.pause()
            narrationController.stop()
        }
    }

    @ViewBuilder
    private var heroMedia: some View {
        if let player {
            VideoPlayer(player: player)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
                .overlay(alignment: .bottom) {
                    videoControlBar
                }
        } else {
            AsyncImage(url: item.heroImageURL) { phase in
                switch phase {
                case .empty:
                    Rectangle().fill(Color.gray.opacity(0.1))
                        .overlay(ProgressView().tint(.gray))
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Rectangle().fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.gray))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    @ViewBuilder
    private var videoControlBar: some View {
        if item.streamURL != nil {
            HStack(spacing: 14) {
                Button(action: togglePlayback) {
                    Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .labelStyle(.iconOnly)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                }
                Button(action: toggleMute) {
                    Label(isMuted ? "Unmute" : "Mute", systemImage: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .labelStyle(.iconOnly)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                }
                Spacer()
                if let url = item.streamURL {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding(14)
        }
    }

    private func preparePlayerIfNeeded() {
        guard player == nil, let url = item.streamURL else { return }
        let newPlayer = AVPlayer(url: url)
        newPlayer.play()
        newPlayer.isMuted = isMuted
        player = newPlayer
        isPlaying = true
    }

    private func togglePlayback() {
        guard let player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    private func toggleMute() {
        guard let player else { return }
        isMuted.toggle()
        player.isMuted = isMuted
    }

    private func toggleNarration() {
        if narrationController.isSpeaking {
            narrationController.stop()
        } else {
            narrationController.speak(item.displayDescription)
        }
    }
}

private final class NarrationController: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first ?? "en-US")
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

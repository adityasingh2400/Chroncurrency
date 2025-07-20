import Foundation
import Speech
import AVFoundation

@MainActor
final class DictationHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let recognizer = SFSpeechRecognizer(locale: .current)
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let engine = AVAudioEngine()

    @Published var transcript = ""

    func start() throws {
        recognizer?.delegate = self
        request = SFSpeechAudioBufferRecognitionRequest()
        task = recognizer?.recognitionTask(with: request!) { [weak self] result, _ in
            guard let self, let result else { return }
            self.transcript = result.bestTranscription.formattedString
        }
        let node = engine.inputNode
        let fmt  = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buf, _ in
            self?.request?.append(buf)
        }
        try engine.start()
    }

    func stop() {
        engine.stop()
        request?.endAudio()
        task?.cancel()
        transcript = ""
    }
}


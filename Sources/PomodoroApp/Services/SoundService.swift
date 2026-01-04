import AppKit

class SoundService {
    func playCompletionSound() {
        // Use system sound for reliability
        NSSound.beep()
        
        // Alternative: Play a more pleasant system sound
        if let sound = NSSound(named: "Glass") {
            sound.play()
        }
    }
}

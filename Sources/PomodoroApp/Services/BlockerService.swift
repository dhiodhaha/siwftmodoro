import Foundation

class BlockerService {
    private let blockedDomains = [
        "instagram.com", "www.instagram.com",
        "x.com", "www.x.com",
        "twitter.com", "www.twitter.com",
        "tiktok.com", "www.tiktok.com"
    ]
    
    private let startMarker = "### START POMODORO BLOCK ###"
    private let endMarker = "### END POMODORO BLOCK ###"
    
    func blockSocialMedia() {
        guard !isBlocked() else { return }
        
        let entries = blockedDomains.map { "127.0.0.1 \($0)" }.joined(separator: "\n")
        let blockBlock = "\n\(startMarker)\n\(entries)\n\(endMarker)\n"
        
        // Use osascript to append to /etc/hosts with admin privileges
        // We use 'do shell script' with 'with administrator privileges'
        let script = """
        do shell script "echo '\(blockBlock)' >> /etc/hosts" with administrator privileges
        """
        
        runAppleScript(script)
    }
    
    func unblockSocialMedia() {
        // Use sed to delete the block between markers
        // sed -i '' '/START/,/END/d' /etc/hosts
        
        let script = """
        do shell script "sed -i '' '/\(startMarker)/,/\(endMarker)/d' /etc/hosts" with administrator privileges
        """
        
        runAppleScript(script)
    }
    
    private func isBlocked() -> Bool {
        guard let hosts = try? String(contentsOfFile: "/etc/hosts") else { return false }
        return hosts.contains(startMarker)
    }
    
    private func runAppleScript(_ source: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: source) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript error: \(error)")
            }
        }
    }
    
    // Safety cleanup: Call this on app launch to ensure we don't leave residual blocks
    func cleanup() {
        if isBlocked() {
            unblockSocialMedia()
        }
    }
}

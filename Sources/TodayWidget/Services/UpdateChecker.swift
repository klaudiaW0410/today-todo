import Foundation
import AppKit

// MARK: - Update Information Model
struct UpdateInfo: Equatable {
    let version: String
    let releaseURL: URL
}

// MARK: - In-App GitHub Update Checker
class UpdateChecker: ObservableObject {
    @Published var updateAvailable: UpdateInfo? = nil
    @Published var isChecking: Bool = false
    
    let currentVersion: String = "1.0.0"
    private let repoOwner: String = "klaudiaW0410"
    private let repoName: String = "today-todo"
    
    func checkForUpdates() {
        guard let url = URL(string: "https://api.github.com/repos/\(repoOwner)/\(repoName)/releases/latest") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("TodayWidget-App", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 8
        
        isChecking = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isChecking = false
                guard let self = self,
                      let data = data,
                      error == nil,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let rawTag = json["tag_name"] as? String,
                      let htmlUrlStr = json["html_url"] as? String,
                      let releaseUrl = URL(string: htmlUrlStr) else {
                    return
                }
                
                let latestVersion = rawTag.replacingOccurrences(of: "v", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                if self.isVersion(latestVersion, newerThan: self.currentVersion) {
                    self.updateAvailable = UpdateInfo(version: latestVersion, releaseURL: releaseUrl)
                }
            }
        }.resume()
    }
    
    func isVersion(_ v1: String, newerThan v2: String) -> Bool {
        let v1Parts = v1.split(separator: ".").compactMap { Int($0) }
        let v2Parts = v2.split(separator: ".").compactMap { Int($0) }
        
        let count = max(v1Parts.count, v2Parts.count)
        for i in 0..<count {
            let part1 = i < v1Parts.count ? v1Parts[i] : 0
            let part2 = i < v2Parts.count ? v2Parts[i] : 0
            if part1 > part2 { return true }
            if part1 < part2 { return false }
        }
        return false
    }
    
    func openDownloadPage() {
        if let url = updateAvailable?.releaseURL {
            NSWorkspace.shared.open(url)
        }
    }
}

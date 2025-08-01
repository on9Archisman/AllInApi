//
//  JailBreakDetector.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import UIKit

/// Protocol defining jailbreaking detection
protocol JailBreakDetectorProtocol {
    static func isJailbroken() -> Bool
}

struct JailBreakDetector: JailBreakDetectorProtocol {
    
    /// Returns true if the device appears to be jailbroken.
    static func isJailbroken() -> Bool {
#if targetEnvironment(simulator)
        return false // Skip jailbreak check on simulator
#else
        if hasJailbreakFiles() { return true }         // Check for suspicious files
        if canAccessRestrictedAreas() { return true }  // Try accessing protected system directories
        if canOpenCydiaURL() { return true }           // Check if Cydia URL scheme can be opened
        return false
#endif
    }
    
    /// Checks for the existence of common jailbreak-related files
    private static func hasJailbreakFiles() -> Bool {
        let jailbreakPaths = [
            "/Applications/Cydia.app",                                // Cydia app
            "/Library/MobileSubstrate/MobileSubstrate.dylib",         // Substrate
            "/bin/bash",                                              // Shell access
            "/usr/sbin/sshd",                                         // SSH daemon
            "/etc/apt",                                               // APT config
            "/private/var/lib/apt/",                                  // APT libraries
            "/usr/bin/ssh"                                            // SSH binary
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    /// Attempts to write outside the sandbox to detect elevated access
    private static func canAccessRestrictedAreas() -> Bool {
        let testPath = "/private/jailbreak_test.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            // Clean up test file if write succeeds
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }
    
    /// Checks if the device can handle a known jailbreak app URL scheme
    private static func canOpenCydiaURL() -> Bool {
        guard let url = URL(string: "cydia://package/com.example.package") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}

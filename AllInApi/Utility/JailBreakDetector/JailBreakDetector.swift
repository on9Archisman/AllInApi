//
//  JailBreakDetector.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import UIKit

protocol JailBreakDetectorProtocol {
    static func isJailbroken() -> Bool
}

struct JailBreakDetector: JailBreakDetectorProtocol {
    
    /// Returns true if the device appears to be jailbroken.
    static func isJailbroken() -> Bool {
#if targetEnvironment(simulator)
        return false // Don't required to check in simulator
#else
        if hasJailbreakFiles() { return true }
        if canAccessRestrictedAreas() { return true }
        if canOpenCydiaURL() { return true }
        return false
#endif
    }
    
    /// Check for presence of known jailbreak files
    private static func hasJailbreakFiles() -> Bool {
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/usr/bin/ssh"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    /// Try to access restricted areas (e.g., outside sandbox)
    private static func canAccessRestrictedAreas() -> Bool {
        let testPath = "/private/jailbreak_test.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            // Clean up
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }
    
    /// Try to open Cydia's URL scheme
    private static func canOpenCydiaURL() -> Bool {
        guard let url = URL(string: "cydia://package/com.example.package") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}

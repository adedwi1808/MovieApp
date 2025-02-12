//
//  Data+Extension.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension Data {
    private static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain"
        ]
    
    var mimeType: String {
//        var c: UInt8 = 0
//        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[0xFF] ?? "application/octet-stream"
    }
    
    var fileExtension: String {
        switch mimeType {
        case "image/jpeg":
            return "jpeg"
        case "image/png":
            return "png"
        case "image/gif":
            return "gif"
        case "image/tiff":
            return "tiff"
        case "application/pdf":
            return "pdf"
        case "application/vnd":
            return "vnd"
        case "text/plain":
            return "txt"
        default:
            return "uknown"
        }
    }
}

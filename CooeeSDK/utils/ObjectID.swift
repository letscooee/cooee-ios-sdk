//
//  ObjectID.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 23/02/22.
//

import Foundation



struct ObjectID {
    let _timestamp: UInt32
    let _random: UInt64
    
    public init() {
        self._timestamp = UInt32(Date().timeIntervalSince1970)
        self._random = .random(in: .min ... .max)
    }
    
    var hexString: String {
        var data = Data()
        data.reserveCapacity(24)
        
        withUnsafeBytes(of: _timestamp.bigEndian) { buffer in
            let buffer = buffer.bindMemory(to: UInt8.self)
            
            data.appendHexCharacters(of: buffer[0])
            data.appendHexCharacters(of: buffer[1])
            data.appendHexCharacters(of: buffer[2])
            data.appendHexCharacters(of: buffer[3])
        }
        
        withUnsafeBytes(of: _random.bigEndian) { buffer in
            let buffer = buffer.bindMemory(to: UInt8.self)
            
            data.appendHexCharacters(of: buffer[0])
            data.appendHexCharacters(of: buffer[1])
            data.appendHexCharacters(of: buffer[2])
            data.appendHexCharacters(of: buffer[3])
            data.appendHexCharacters(of: buffer[4])
            data.appendHexCharacters(of: buffer[5])
            data.appendHexCharacters(of: buffer[6])
            data.appendHexCharacters(of: buffer[7])
        }
        
        return String(data: data, encoding: .utf8)!
    }
}

fileprivate extension Int8 {
    func hexDecoded() -> Int8? {
        let byte: Int8
        
        if self >= 0x61 {
            byte = self - 0x20
        } else {
            byte = self
        }
        
        switch byte {
        case 0x30: return 0b00000000
        case 0x31: return 0b00000001
        case 0x32: return 0b00000010
        case 0x33: return 0b00000011
        case 0x34: return 0b00000100
        case 0x35: return 0b00000101
        case 0x36: return 0b00000110
        case 0x37: return 0b00000111
        case 0x38: return 0b00001000
        case 0x39: return 0b00001001
        case 0x41: return 0b00001010
        case 0x42: return 0b00001011
        case 0x43: return 0b00001100
        case 0x44: return 0b00001101
        case 0x45: return 0b00001110
        case 0x46: return 0b00001111
        default: return nil
        }
    }
}

fileprivate extension Data {
    mutating func appendHexCharacters(of byte: UInt8) {
        append((byte >> 4).singleHexCharacter)
        append((byte & 0b00001111).singleHexCharacter)
    }
}

fileprivate extension UInt8 {
    var singleHexCharacter: UInt8 {
        switch self {
        case 0b00000000: return 0x30
        case 0b00000001: return 0x31
        case 0b00000010: return 0x32
        case 0b00000011: return 0x33
        case 0b00000100: return 0x34
        case 0b00000101: return 0x35
        case 0b00000110: return 0x36
        case 0b00000111: return 0x37
        case 0b00001000: return 0x38
        case 0b00001001: return 0x39
        case 0b00001010: return 0x61
        case 0b00001011: return 0x62
        case 0b00001100: return 0x63
        case 0b00001101: return 0x64
        case 0b00001110: return 0x65
        case 0b00001111: return 0x66
        default:
            fatalError("Invalid 4 bits provided")
        }
    }
}

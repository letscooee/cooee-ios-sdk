//
//  Gradient.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 18/10/21.
//

import Foundation
import HandyJSON
import SwiftUI

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
struct Gradient: HandyJSON {
    // MARK: Public

    public enum `Type`: String, HandyJSONEnum {
        case LINEAR
        case RADIAL
        case SWEEP
    }

    public func getGradiant() -> any Grad {
        // TODO: 15/11/22 Use this method for getting gradiant when simplifying Abstract renderer
        switch type {
            case .RADIAL:
                let angle = getAngleAsEnumString(angle: ang ?? 45)
                return RadialGradient(gradient: SwiftUI.Gradient(colors: getColourArray()), center: .center, startRadius: CGFloat((angle / 2)), endRadius: CGFloat(angle * 2))
            case .SWEEP:
                return AngularGradient(gradient: SwiftUI.Gradient(colors: getColourArray()), center: .center)
            default:
                let angles = getStartEnd()
                return LinearGradient(colors: getColourArray(), startPoint: angles.start, endPoint: angles.end)
        }
    }

    // MARK: Internal

    var type: Type?
    var c1: String?
    var c2: String?
    var c3: String?
    var c4: String?
    var c5: String?
    var ang: Int?
    static let AVAILABLE_ANGLES: [Int] = [0, 45, 90, 135, 180, 225, 270, 315, 360];

    public func getStartEnd() -> (start: UnitPoint, end: UnitPoint) {
        switch getAngleAsEnumString(angle: ang ?? 0) {
            case 45: return (.topLeading, .bottomTrailing)
            case 90: return (.leading, .trailing)
            case 135: return (.bottomLeading, .topTrailing)
            case 180: return (.bottom, .top)
            case 225: return (.bottomTrailing, .topLeading)
            case 270: return (.trailing, .leading)
            case 315: return (.topTrailing, .bottomLeading)
            default: return (.top, .bottom)
        }
    }

    private func getAngleAsEnumString(angle: Int) -> Int {
        var distance = abs(Gradient.AVAILABLE_ANGLES[0] - angle);
        var index = 0;

        for tempIndex in 1..<Gradient.AVAILABLE_ANGLES.count {
            var tempDistance = abs(Gradient.AVAILABLE_ANGLES[tempIndex] - angle);
            if (tempDistance < distance) {
                index = tempIndex;
                distance = tempDistance;
            }

        }

        return (Gradient.AVAILABLE_ANGLES[index]);
    }

    public func getColourArray() -> [Color] {
        var array: [Color] = []
        if let c = c1, !c.isEmpty {
            array.append(Color(hex: c))
        } else {
            array.append(Color(hex: "#000"))
        }

        if let c = c2, !c.isEmpty {
            array.append(Color(hex: c))
        } else {
            array.append(Color(hex: "#000"))
        }

        if let c = c3, !c.isEmpty {
            array.append(Color(hex: c))
        }

        if let c = c4, !c.isEmpty {
            array.append(Color(hex: c))
        }

        if let c = c5, !c.isEmpty {
            array.append(Color(hex: c))
        }

        return array
    }

}

protocol Grad {
    associatedtype T where T: View
    func getData() -> T
}

extension LinearGradient: Grad {
    typealias T = LinearGradient

    func getData() -> LinearGradient {
        self
    }
}

extension AngularGradient: Grad {
    typealias T = AngularGradient

    func getData() -> AngularGradient {
        self
    }
}

extension RadialGradient: Grad {
    typealias T = RadialGradient

    func getData() -> RadialGradient {
        self
    }
}

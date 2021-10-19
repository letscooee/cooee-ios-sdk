//
//  FlexProperty.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 19/10/21.
//

import FlexLayout
import Foundation

/**
 Define all flex property at one place

 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
public enum FlexProperty: Codable {
    public enum Direction: Codable {
        case ROW, COLUMN, ROW_REVERSE, COLUMN_REVERSE

        // MARK: Internal

        var description: Flex.Direction {
            switch self {
            case .ROW:
                return Flex.Direction.row
            case .COLUMN:
                return Flex.Direction.column
            case .ROW_REVERSE:
                return Flex.Direction.rowReverse
            case .COLUMN_REVERSE:
                return Flex.Direction.columnReverse
            }
        }
    }

    public enum Wrap: Codable {
        case WRAP, NOWRAP, WRAP_REVERSE

        // MARK: Internal

        var description: Flex.Wrap {
            switch self {
            case .WRAP:
                return Flex.Wrap.wrap
            case .NOWRAP:
                return Flex.Wrap.noWrap
            case .WRAP_REVERSE:
                return Flex.Wrap.wrapReverse
            }
        }
    }

    public enum JustifyContent: Codable {
        case FLEX_START, FLEX_END, CENTER, SPACE_BETWEEN, SPACE_AROUND, SPACE_EVENLY

        // MARK: Internal

        var description: Flex.JustifyContent {
            switch self {
            case .FLEX_START:
                return Flex.JustifyContent.start
            case .FLEX_END:
                return Flex.JustifyContent.end
            case .CENTER:
                return Flex.JustifyContent.center
            case .SPACE_BETWEEN:
                return Flex.JustifyContent.spaceBetween
            case .SPACE_AROUND:
                return Flex.JustifyContent.spaceAround
            case .SPACE_EVENLY:
                return Flex.JustifyContent.spaceEvenly
            }
        }
    }

    public enum AlignItems: Codable {
        case FLEX_START, FLEX_END, CENTER, BASELINE, STRETCH

        // MARK: Internal

        var description: Flex.AlignItems {
            switch self {
            case .FLEX_START:
                return Flex.AlignItems.start
            case .FLEX_END:
                return Flex.AlignItems.end
            case .CENTER:
                return Flex.AlignItems.center
            case .BASELINE:
                return Flex.AlignItems.baseline
            case .STRETCH:
                return Flex.AlignItems.stretch
            }
        }
    }

    public enum AlignContent: Codable {
        case FLEX_START, FLEX_END, CENTER, SPACE_BETWEEN, SPACE_AROUND, STRETCH

        // MARK: Internal

        var description: Flex.AlignContent {
            switch self {
            case .FLEX_START:
                return Flex.AlignContent.start
            case .FLEX_END:
                return Flex.AlignContent.end
            case .CENTER:
                return Flex.AlignContent.center
            case .SPACE_BETWEEN:
                return Flex.AlignContent.spaceBetween
            case .SPACE_AROUND:
                return Flex.AlignContent.spaceAround
            case .STRETCH:
                return Flex.AlignContent.stretch
            }
        }
    }
}

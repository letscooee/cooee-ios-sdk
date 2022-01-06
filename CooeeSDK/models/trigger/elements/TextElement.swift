//
// Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import SwiftUI

/**
 Button element extent is used to provide all base properties to ButtonRenderer. But it uses TextElement as its parent

 - Author: Ashish Gaikwad
 - Since: 1.3.0
 */
class TextElement: BaseTextElement, Identifiable {
    // MARK: Lifecycle

    required init() {}

    // MARK: Public

    public func getProcessedPartList() -> [[PartElement]] {
        print("load parts")
        var varticalPartList = [[PartElement]]()
        var i = 0

        print("part count: \(prs!.count)")
        while i < prs!.count {
            var horizontalPartList = [PartElement]()

            for part in stride(from: i, to: prs!.count, by: 1) {
                print("i: \(i)")
                var partText = prs![part].getPartText()
                let trimmedText = partText.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedText.count <= 0 {
                    i += 1
                    break
                } else if partText.starts(with: "\n") {
                    let newPart: PartElement = prs![part]
                    partText = Character(extendedGraphemeClusterLiteral: Array(partText)[0]).isNewline ?
                        String(partText.dropFirst()) : partText

                    if i == prs!.count - 1 {
                        partText = Character(extendedGraphemeClusterLiteral: Array(partText)[partText.count - 1]).isNewline ?
                            String(partText.dropLast()) : partText

                    }
                    newPart.setPartText(partText)

                    horizontalPartList.append(newPart)
                    i += 1
                    break
                } else {
                    let newPart: PartElement = prs![part]
                    if i == prs!.count - 1 {
                        partText = Character(extendedGraphemeClusterLiteral: Array(partText)[partText.count - 1]).isNewline ?
                            String(partText.dropLast()) : partText

                        newPart.setPartText(partText)
                    }
                    horizontalPartList.append(newPart)
                    i += 1
                }
            }
            varticalPartList.append(horizontalPartList)
        }

        return varticalPartList
    }

    // MARK: Internal

    var prs: [PartElement]?
}

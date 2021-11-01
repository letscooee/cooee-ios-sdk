//
// Created by Ashish Gaikwad on 19/10/21.
//

import Foundation
import HandyJSON

/**
 - Author: Ashish Gaikwad
 - Since: 0.1.0
 */
class GroupElement: BaseElement {
    // MARK: Lifecycle

    required init() {}

    // MARK: Internal

    var children: [[String:Any]]?

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            children <-- TransformOf<[[String:Any]], String>(fromJSON: { rawString -> [[String:Any]]? in
                do {
                    if let json = try JSONSerialization.jsonObject(with: Data(rawString!.utf8), options: []) as? [[String: Any]] {
                        var array = [[String:Any]]()
                        for item in json {
                            print(item)
                            switch"\(String(describing: item["type"]))" {
                            case ElementType.BUTTON.rawValue:
                                if let element = ButtonElement.deserialize(from: item) {
                                    array.append(element.toJSON()!)
                                }
                            case ElementType.TEXT.rawValue:
                                if let element = TextElement.deserialize(from: item) {
                                    array.append(element.toJSON()!)
                                }
                            case ElementType.IMAGE.rawValue:
                                if let element = ImageElement.deserialize(from: item) {
                                    array.append(element.toJSON()!)
                                }
                            case ElementType.VIDEO.rawValue:
                                if let element = VideoElement.deserialize(from: item) {
                                    array.append(element.toJSON()!)
                                }
                            default:
                                if let element = GroupElement.deserialize(from: item) {
                                    array.append(element.toJSON()!)
                                }
                            }
                        }
                        return array
                    }
                } catch {
                    return nil
                }
                return nil
            }, toJSON: { data -> String? in
                
                return (data as? BaseElement)?.toJSONString()
            })
        
        
    }
}

import Foundation
import XMLMapper

public class NameValuePair: NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        name <- map["name"]
        value <- map["value"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
     public var name : String = ""
     public var value : String = ""
}

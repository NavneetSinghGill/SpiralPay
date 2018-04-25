import Foundation
import XMLMapper

public class Name: NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        givenName <- map["givenName"]
        honorific <- map["honorific"]
        middleNames <- map["middleNames"]
        surname <- map["surname"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
    public var givenName : String = ""
    public var honorific : String = ""
    public var middleNames : String = ""
    public var surname : String = ""
    
    public var combinedString: String {
        get {
            if middleNames.count == 0 {
                return "\(givenName) \(surname)"
            } else {
                return "\(givenName) \(middleNames) \(surname)"
            }
        }
    }
}

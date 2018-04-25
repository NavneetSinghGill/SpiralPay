import Foundation
import XMLMapper

public class LastCheckResultV3: NSObject, XMLMappable {
    public required init(map: XMLMap) {
        
    }
    
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        state <- map["state"]
        stillWorking <- map["stillWorking"]
    }
    
     public var state : String = ""
     public var stillWorking : Bool = false 
}

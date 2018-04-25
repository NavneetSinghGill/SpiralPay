import Foundation
import XMLMapper

public class DateOfBirth: NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        day <- map["day"]
        month <- map["month"]
        year <- map["year"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
    public var day : Int = 0
    public var month : Int = 0
    public var year : Int = 0
    
    public var combinedString: String {
        get {
            return "\(day)\(month)\(year)"
        }
    }
}

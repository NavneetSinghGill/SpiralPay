import Foundation
import XMLMapper

public class GetVerificationResultResponse: NSObject, XMLMappable {
    public var return_ : CurrentStatusV3?
    
    public required init(map: XMLMap) {
        
    }
    
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        return_ <- map["env:Body.ns2:getVerificationResultResponse.return"]
    }
    
}

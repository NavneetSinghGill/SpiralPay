import Foundation
import XMLMapper

public class VerificationResultV3: NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        dateVerified <- map["dateVerified"]
        mode <- map["mode"]
        overallVerificationStatus <- map["overallVerificationStatus"]
        ruleId <- map["ruleId"]
        verificationId <- map["verificationId"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
     public var dateVerified : String = ""
//     public var individualResult : [checkResultV3] = []
     public var mode : String = ""
     public var overallVerificationStatus : String = ""
     public var ruleId : String = ""
     public var verificationId : String = ""
}

import Foundation
import XMLMapper

public class CurrentStatusV3: NSObject, XMLMappable {
    public required init(map: XMLMap) {
        
    }
    
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        checkResult <- map["checkResult"]
        registrationDetails <- map["registrationDetails"]
        verificationResult <- map["verificationResult"]
        verificationToken <- map["verificationToken"]
    }
    
    public var checkResult : LastCheckResultV3?
    public var registrationDetails : RegistrationDetailsV3?
//    public var sourceFields : sourceFieldsV3 = sourceFieldsV3()
//    public var sourceList : sourceListV3 = sourceListV3()
    public var verificationResult : VerificationResultV3?
    public var verificationToken : String = ""
}

import Foundation
import XMLMapper

public class RegistrationDetailsV3: NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        currentResidentialAddress <- map["currentResidentialAddress"]
        dateCreated <- map["dateCreated"]
        dob <- map["dob"]
        email <- map["email"]
        extraData <- map["extraData"]
        homePhone <- map["homePhone"]
        mobilePhone <- map["mobilePhone"]
        name <- map["name"]
        previousResidentialAddress <- map["previousResidentialAddress"]
        workPhone <- map["workPhone"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
    public var currentResidentialAddress : Address?
    public var dateCreated : String = ""
    public var dob : DateOfBirth?
    public var email : String = ""
    public var extraData : [NameValuePair] = []
    public var homePhone : String = ""
    public var mobilePhone : String = ""
    public var name : Name? 
    public var previousResidentialAddress : Address?
    public var workPhone : String = ""
}

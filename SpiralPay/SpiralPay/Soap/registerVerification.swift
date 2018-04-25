import Foundation
public class registerVerification{
     public var accountId : String = ""
     public var password : String = ""
     public var verificationId : String = ""
     public var ruleId : String = ""
     public var name : Name?
     public var email : String = ""
     public var currentResidentialAddress : Address?
     public var previousResidentialAddress : Address?
     public var dob : DateOfBirth?
     public var homePhone : String = ""
     public var workPhone : String = ""
     public var mobilePhone : String = ""
     public var deviceIDData : String = ""
     public var generateVerificationToken : Bool = false 
     public var extraData : [NameValuePair] = []
}

import Foundation
public class checkResultV3{
     public var dateCreated : String = ""
     public var dateVerified : String = ""
     public var documentRegion : String = ""
     public var documentSubRegion : String = ""
     public var documentType : String = ""
     public var extraData : [NameValuePair] = [] 
     public var faceMatchScore : String = ""
     public var fieldResult : [fieldResultV3] = [] 
     public var individualResult : [checkResultV3] = [] 
     public var method : String = ""
     public var mode : String = ""
     public var name : String = ""
     public var postOfficeData : postOfficeDataV3 = postOfficeDataV3()
     public var state : String = ""
}

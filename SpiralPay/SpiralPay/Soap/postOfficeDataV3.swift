import Foundation
public class postOfficeDataV3{
     public var customerId : String = ""
     public var documents : String = ""
     public var header : detailRecordHeader = detailRecordHeader()
     public var poFileName : String = ""
     public var records : [documentRecord] = [] 
}

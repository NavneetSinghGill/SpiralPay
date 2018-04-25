import Foundation
import XMLMapper

public class Address:NSObject, XMLMappable {
    public var nodeName: String!
    
    public func mapping(map: XMLMap) {
        alley <- map["alley"]
        amalgamatedMunicipality <- map["amalgamatedMunicipality"]
        area <- map["area"]
        avenue <- map["avenue"]
        block <- map["block"]
        canton <- map["canton"]
        chome <- map["chome"]
        city <- map["city"]
        country <- map["country"]
        county <- map["county"]
        deliveryNumber <- map["deliveryNumber"]
        department <- map["department"]
        direction <- map["direction"]
        dispatchingInformation <- map["dispatchingInformation"]
        district <- map["district"]
        divisionFive <- map["divisionFive"]
        divisionFour <- map["divisionFour"]
        divisionOne <- map["divisionOne"]
        divisionThree <- map["divisionThree"]
        divisionTwo <- map["divisionTwo"]
        flatNumber <- map["flatNumber"]
        locality <- map["locality"]
        location <- map["location"]
        mailCentre <- map["mailCentre"]
        neighbourhood <- map["neighbourhood"]
        organisation <- map["organisation"]
        parish <- map["parish"]
        personName <- map["personName"]
        poBox <- map["poBox"]
        postcode <- map["postcode"]
        prefecture <- map["prefecture"]
        propertyName <- map["propertyName"]
        province <- map["province"]
        quarter <- map["quarter"]
        region <- map["region"]
        ruralArea <- map["ruralArea"]
        ruralLocality <- map["ruralLocality"]
        sector <- map["sector"]
        sectorNumber <- map["sectorNumber"]
        state <- map["state"]
        streetName <- map["streetName"]
        streetNumber <- map["streetNumber"]
        streetType <- map["streetType"]
        subdistrict <- map["subdistrict"]
        subregion <- map["subregion"]
        suburb <- map["suburb"]
        town <- map["town"]
        townCity <- map["townCity"]
        township <- map["township"]
        urbanLocality <- map["urbanLocality"]
        village <- map["village"]
    }
    
    public required init(map: XMLMap) {
        
    }
    
     public var alley : String = ""
     public var amalgamatedMunicipality : String = ""
     public var area : String = ""
     public var avenue : String = ""
     public var block : String = ""
     public var canton : String = ""
     public var chome : String = ""
     public var city : String = ""
     public var country : String = ""
     public var county : String = ""
     public var deliveryNumber : String = ""
     public var department : String = ""
     public var direction : String = ""
     public var dispatchingInformation : String = ""
     public var district : String = ""
     public var divisionFive : String = ""
     public var divisionFour : String = ""
     public var divisionOne : String = ""
     public var divisionThree : String = ""
     public var divisionTwo : String = ""
     public var flatNumber : String = ""
     public var level : String = ""
     public var locality : String = ""
     public var location : String = ""
     public var mailCentre : String = ""
     public var municipality : String = ""
     public var neighbourhood : String = ""
     public var organisation : String = ""
     public var parish : String = ""
     public var personName : String = ""
     public var poBox : String = ""
     public var postcode : String = ""
     public var prefecture : String = ""
     public var propertyName : String = ""
     public var province : String = ""
     public var quarter : String = ""
     public var region : String = ""
     public var ruralArea : String = ""
     public var ruralLocality : String = ""
     public var sector : String = ""
     public var sectorNumber : String = ""
     public var state : String = ""
     public var streetName : String = ""
     public var streetNumber : String = ""
     public var streetType : String = ""
     public var subdistrict : String = ""
     public var subregion : String = ""
     public var suburb : String = ""
     public var town : String = ""
     public var townCity : String = ""
     public var township : String = ""
     public var urbanLocality : String = ""
     public var village : String = ""
}

import FirebaseFirestore

extension appBuilding {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appBuilding] {
        var buildings = [appBuilding]()
        for document in documents {
            buildings.append(appBuilding(checkInOutHistory: document["checkInOutHistory"] as? Array<String>,currentCapacity: document["currentCapacity"] as? Int ?? 0,totalCapacity: document["totalCapacity"] as? Int ?? 0, name: document.documentID))
        }
        return buildings
    }
}
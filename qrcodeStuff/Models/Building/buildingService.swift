import FirebaseFirestore

class BuildingService {
    let database = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([appBuilding]) -> Void) {
        database.collection("buildings")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appBuilding.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

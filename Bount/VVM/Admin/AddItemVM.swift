//
//  AddItemVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import FirebaseFirestore

class AddItemVM : ObservableObject {
    
    @Published var itemName = ""
    @Published var itemPrice: Int? = 0
    @Published var itemType: ItemType = .UNKNOWN
    @Published var itemVendor: Vendor?
    
    init() {}
    
    func addItemToFirestore(name: String, price: Int?, type: ItemType, vendor: Vendor?, completion: @escaping (Bool) -> Void) {
        var data: [String: Any] = [
            "name": name,
            "type": type.rawValue
        ]

        if let price = price {
            data["price"] = price
        }

        let itemCollection = Firestore.firestore().collection("items")
        
        var itemRef: DocumentReference?
        
        itemRef = itemCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding item: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Item added successfully")
                completion(true)
            }
        }
        
        // itemRef now contains a reference to the added item document
        if let itemID = itemRef?.documentID, let vendorID = vendor?.id {
            // Update the vendor's inventory with the item ID
            let vendorRef = Firestore.firestore().collection("vendors").document(vendorID)

            vendorRef.updateData(["inventory": FieldValue.arrayUnion([itemID])]) { vendorError in
                if let vendorError = vendorError {
                    print("Error adding item to vendor's inventory: \(vendorError.localizedDescription)")
                    completion(false)
                } else {
                    print("Item added to vendor's inventory successfully")
                    completion(true)
                }
            }
        } else {
            print("Item or vendor is nil.")
            completion(false)
        }
    }
    
    func reset() {
        self.itemName = ""
        self.itemPrice = 0
    }

}

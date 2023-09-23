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
    
    @Published var showingErrorAlert = false
    @Published var errorMessage = ""
    
    init() {}
    
    func addItemToFirestore(name: String, price: Int?, type: ItemType, vendor: Vendor?, completion: @escaping (Bool, String) -> Void) {
        // Check if the item name field is empty
        if name.isEmpty {
            completion(false, "Item name cannot be empty")
            return
        }
        
        // Check if an item with the same name already exists
        Firestore.firestore().collection("items").whereField("name", isEqualTo: name).getDocuments { (snapshot, error) in
            if error != nil {
                completion(false, "Error checking item name")
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                // Item with the same name already exists
                completion(false, "Item with the same already exists")
                return
            }
            
            // Item name is unique, proceed with adding the item
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
                if error != nil {
                    completion(false, "Error adding item")
                } else {
                    completion(true, "")
                }
            }
            
            // itemRef now contains a reference to the added item document
            if let itemID = itemRef?.documentID, let vendorID = vendor?.id {
                // Update the vendor's inventory with the item ID
                let vendorRef = Firestore.firestore().collection("vendors").document(vendorID)
                
                vendorRef.updateData(["inventory": FieldValue.arrayUnion([itemID])]) { vendorError in
                    if vendorError != nil {
                        completion(false, "Error adding item to vendor's inventory")
                    } else {
                        completion(true, "")
                    }
                }
            }
        }
    }
    
    func reset() {
        self.itemName = ""
        self.itemPrice = 0
        self.itemType = .UNKNOWN
    }

}

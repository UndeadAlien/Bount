//
//  ProfileViewVM.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/4/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileVM : ObservableObject {
    
    @Published var user: User? = nil
    
    init() {
        
    }
    
    func fetch() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(id: data["id"] as? String ?? "",
                                  firstName: data["firstName"] as? String ?? "",
                                  lastName: data["lastName"] as? String ?? "",
                                  email: data["email"] as? String ?? "",
                                  joined: data["joined"] as? Date 
                            )
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logging out")
        }
    }
    
}

////
////  GuardianView.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/9/24.
////
//
// 추후 세팅용으로 남겨두는 Legacy
//
//import SwiftUI
//
//struct GuardianView: View {
//    @State private var name: String = "John Doe"
//    @State private var age: Date = Date()
//    @State private var gender: String = "Male"
//    @State private var isEditing: Bool = false
//    @State private var physician: String = "Dr. Smith"
//    @State private var note: String = "Regular check-up"
//    
//    var screenWidth = UIScreen.main.bounds.width
//    var screenHeight = UIScreen.main.bounds.height
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text(name)
//                    .font(.system(size: 128))
//                    .bold()
//                    .padding(.leading, 40)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                HStack {
//                    Text("Birth:")
//                        .font(.system(size: 40))
//                        .bold()
//                    Text(age, style: .date)
//                        .font(.system(size: 40))
//                        .bold()
//                }
//                .frame(width: screenWidth-80, alignment: .leading)
//                
//                HStack {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Spacer().frame(width: 40)
//                            Text("Attending physician :")
//                                .font(.system(size: 40))
//                                .bold()
//                            Text(physician)
//                                .font(.system(size: 40))
//                        }
//                        HStack {
//                            Spacer().frame(width: 40)
//                            Text("Note :")
//                                .font(.system(size: 40))
//                                .bold()
//                            Text(note)
//                                .font(.system(size: 40))
//                        }
//                    }
//                    Spacer()
//                }
//                
//                Spacer()
//            }
//            .frame(height: screenHeight * 0.85)
//            .navigationBarItems(trailing: Button("Edit") {
//                isEditing = true
//            })
//            .sheet(isPresented: $isEditing) {
//                EditGuardianView(name: $name, age: $age, gender: $gender, physician: $physician, note: $note)
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
//    }
//}
//
//struct EditGuardianView: View {
//    @Binding var name: String
//    @Binding var age: Date
//    @Binding var gender: String
//    @Binding var physician: String
//    @Binding var note: String
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("User Info")) {
//                    TextField("Name", text: $name)
//                    DatePicker("Birthday", selection: $age, displayedComponents: .date)
//                    TextField("Gender", text: $gender)
//                    TextField("Attending Physician", text: $physician)
//                    TextField("Note", text: $note)
//                }
//            }
//            .navigationBarTitle("Edit Info", displayMode: .inline)
//            .navigationBarItems(leading: Button("") {
//                presentationMode.wrappedValue.dismiss()
//            }, trailing: Button("Save") {
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//#Preview {
//    GuardianView()
//}

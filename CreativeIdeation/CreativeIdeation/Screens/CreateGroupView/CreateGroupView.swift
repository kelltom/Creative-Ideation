//
//  CreateGroupView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct CreateGroupView: View {
    @State var groupName: String = ""
    @State var groupDescription: String = ""
    @State var groupMembers: String = ""
    @State var text: String = "" //search text
    
    private var listOfStudents = [
        Student(name:"vanessa"),
        Student(name: "Kell"),
        Student(name: "Jayce"),
        Student(name: "Jeremy"),
        Student(name: "Kevin"),
        Student(name: "Ben"),
        Student(name: "Samina"),
        Student(name: "Laura"),
        Student(name: "Kell"),
    ]
    
    
    var body: some View {
        VStack{
            Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()
            HStack{
                
                VStack{
                    
                    MenuTextField(title: "team name", input: $groupName)
                    
                    MenuTextField(title: "team description (optiona)", input: $groupDescription)
                    
                    MenuTextField(title: "enter team members", input: $groupMembers)
                    
                    Button{
                        // do something here
                    } label:{
                        BigButton(title: "Create").padding()
                    }
                    
                    Text("or").font(.system(size:18))
                    
                    Button{
                        // do something here
                    } label:{
                        BigButton(title: "Start Session").padding()
                    }
                }
                
                VStack{
                    VStack{
                        Text("Add Members")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                            .background(Rectangle().fill(Color("brandPrimary")))
                        
                        
                        SearchBarView(text: $text).padding()
                        
                        
                        //List of Members we need to populate "id.\id" - is to help identify each element in the array uniquely
                        List{
                            ForEach(listOfStudents, id: \.id){ student in
                                HStack{
                                    Image(systemName: "person.crop.circle.fill").padding()
                                    Text(student.name)
                                }
                            }
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 80, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 50, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .border(Color("brandPrimary"), width: 2)
                            .cornerRadius(5.0)
 
                        }
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 380, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,  maxHeight: 470, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .border(Color("brandPrimary"), width: 2.0) // formatting for add members
                    .cornerRadius(6)
                }
            }.padding() // padding padding for title
        }
    }
}






struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}


struct Student: Identifiable {
    var name: String
    var id = UUID()
}



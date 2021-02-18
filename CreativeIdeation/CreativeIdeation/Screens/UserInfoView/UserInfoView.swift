//
//  UserInfoView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-17.
//

import SwiftUI

struct UserInfoView: View {
    var body: some View {
        VStack{
            LogoBannerView()
            
            Spacer()
                .frame(minHeight: 60, maxHeight: 100)
            
            HStack {
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("Welcome to Ponder!")
                            .font(.system(size: 48))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("Help us get to know you better:")
                            .font(.system(size: 32))
                    }
                    .padding()
                    
                    Spacer()
                        .frame(height: 35)
                    
                    Text("What is your role?")
                        .font(.system(size: 32))
                        .padding()
                    HStack{
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Student")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .background(Color("darkCyan"))
                                .foregroundColor(.white)
                                .cornerRadius(90)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Teacher")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Employee")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                    }
                    HStack{
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Individual")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Other")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                    }
                    Text("What industry do you work in?")
                        .font(.system(size: 32))
                        .padding()
                    HStack{
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Marketing")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Technology")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .background(Color("darkCyan"))
                                .foregroundColor(.white)
                                .cornerRadius(90)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Business")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                    }
                    HStack{
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Education")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Entertainment")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                        Button(action:{
                            // do something - navigate to different screen
                        }, label:{
                            Text("Other")
                                .fontWeight(.bold)
                                .font(.system(size: 21))
                                .frame(width:200, height:60, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 90.0).stroke(Color.black, lineWidth: 2.0))
                                .background(Color.white)
                                .foregroundColor(.black)
                                .padding()
                        })
                    }
                }
            }
            
            Button(action:{
                // do something - navigate to different screen
            }, label:{
                Text("Next")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .frame(width: 690, height: 60, alignment: .center)
                    .background(Color("darkCyan"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                
            })
            
            Spacer()
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}

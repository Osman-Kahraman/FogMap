//
//  LoginView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false
    @State private var currentNonce: String?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var animateFog = false
    @State private var isOut = false
    @State private var isIn = false

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.black.ignoresSafeArea()
                
                GeometryReader { geo in
                    
                    let size = geo.size.width * 0.5
                    
                    ZStack {
                        
                        // Top Left
                        Image("fog")
                            .resizable()
                            .frame(width: size * 1.4, height: size * 1.4)
                            .clipped()
                            .scaleEffect(1.1)
                            .rotationEffect(.degrees(270))
                            .offset(x: animateFog ? 12 : -12, y: animateFog ? 11 : -11)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                        // Top Right
                        Image("fog")
                            .resizable()
                            .frame(width: size * 1.4, height: size * 1.4)
                            .clipped()
                            .scaleEffect(1.1)
                            .offset(x: animateFog ? 7 : -7, y: animateFog ? 6 : -6)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                        // Bottom Left
                        Image("fog")
                            .resizable()
                            .frame(width: size * 1.4, height: size * 1.4)
                            .clipped()
                            .scaleEffect(1.1)
                            .rotationEffect(.degrees(180))
                            .offset(x: animateFog ? 8 : -8, y: animateFog ? 3 : -3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                        // Bottom Right
                        Image("fog")
                            .resizable()
                            .frame(width: size * 1.4, height: size * 1.4)
                            .clipped()
                            .scaleEffect(1.1)
                            .rotationEffect(.degrees(90))
                            .offset(x: animateFog ? 10 : -10, y: animateFog ? 9 : -9)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 12)
                        .repeatForever(autoreverses: true)
                    ) {
                        animateFog = true
                    }
                }
                
                VStack(spacing: 30) {
                    
                    
                    // Logo
                    VStack(spacing: 10) {
                        
                        Image("icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 34))
                            .overlay(
                                RoundedRectangle(cornerRadius: 34)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: Color.white.opacity(0.15), radius: 20, x: 0, y: 10)
                            .shadow(color: Color.blue.opacity(0.3), radius: 30, x: 0, y: 0)
                        
                        
                        Text("FogMap")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Explore the world")
                            .foregroundColor(.secondary)
                    }
                    
                    // Inputs
                    VStack(spacing: 16) {
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        
                        Task {
                            do {
                                isOut = true

                                // Show loading FIRST
                                try await Task.sleep(nanoseconds: 2_200_000_000)

                                // Then perform login (this triggers root view change AFTER loading)
                                try await authManager.login(email: email, password: password)

                            } catch {
                                isOut = false
                                errorMessage = "Invalid email or password. Please try again."
                                showError = true
                            }
                        }
                        
                    } label: {
                        Text("Login")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(Color(.systemBackground))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("OR")
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.horizontal)
                    
                    // Social login
                    HStack(spacing: 20) {
                        
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                
                                let nonce = authManager.randomNonceString()
                                currentNonce = nonce
                                
                                request.requestedScopes = [.fullName, .email]
                                request.nonce = authManager.sha256(nonce)
                            },
                            onCompletion: { result in
                                
                                switch result {
                                    
                                case .success(let authResults):
                                    
                                    guard let appleIDCredential =
                                            authResults.credential as? ASAuthorizationAppleIDCredential else { return }
                                    
                                    guard let nonce = currentNonce else { return }
                                    
                                    Task {
                                        try? await authManager.signInWithApple(
                                            credential: appleIDCredential,
                                            nonce: nonce
                                        )
                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        )
                        .frame(height: 50)
                        .signInWithAppleButtonStyle(.white)
                        
                        Button {
                            Task {
                                do {
                                    try await authManager.signInWithGoogle()
                                    print("Google login success")
                                } catch {
                                    print("Google login error:", error)
                                }
                            }
                        } label: {
                            
                            HStack(spacing: 8) {
                                Image("google_favicon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                
                                Text("Google")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(Color(.systemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Sign up
                    HStack {
                        Text("Don't have an account?")
                        Button("Sign Up") {
                            showSignup = true
                        }
                        .fontWeight(.bold)
                    }
                    .sheet(isPresented: $showSignup) {
                        NavigationStack {
                            SignupView()
                        }
                    }
                    
                    Spacer()
                }
                .alert("Login Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }

                if isOut {
                    OutAnimationView()
                        .transition(.opacity)
                        .zIndex(10)
                }
                if isIn {
                    InAnimationView()
                        .transition(.opacity)
                        .zIndex(10)
                }
            }
            .onAppear {
                isIn = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeOut(duration: 0)) {
                        isIn = false
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}

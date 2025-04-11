package com.jspjava.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.jspjava.config.GoogleAuthConfig;
import com.jspjava.dto.UserDTO;
import java.util.Collections;

public class GoogleAuthService {
    public UserDTO verifyGoogleToken(String credential) throws Exception {
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), 
                new GsonFactory())
            .setAudience(Collections.singletonList(GoogleAuthConfig.CLIENT_ID))
            .build();

        GoogleIdToken idToken = verifier.verify(credential);
        if (idToken == null) {
            throw new SecurityException("Invalid ID token");
        }

        GoogleIdToken.Payload payload = idToken.getPayload();
        return new UserDTO(
            payload.getSubject(),
            payload.getEmail(),
            (String) payload.get("name"),
            (String) payload.get("picture")
        );
    }
}
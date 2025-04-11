<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>IQ Test Game| Login With Google</title>
    
    
    <style>
        :root {
            --primary-color: #4285F4;
            --secondary-color: #34A853;
            --accent-color: #EA4335;
            --text-color: #2d3748;
            --light-bg: #f8fafc;
            --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: var(--text-color);
            line-height: 1.6;
        }
        
        .login-container {
            background: white;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 480px;
            text-align: center;
            box-shadow: var(--card-shadow);
            transform: translateY(0);
            transition: var(--transition);
        }
        
        .login-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        
        h1 {
            color: var(--primary-color);
            margin-bottom: 16px;
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(to right, #4285F4, #34A853, #FBBC05, #EA4335);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        p {
            margin-bottom: 32px;
            color: #64748b;
            font-size: 1.1rem;
        }
        
        .g_id_signin {
            margin: 0 auto;
            display: flex;
            justify-content: center;
        }
        
        /* Animation for the container */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .login-container {
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        /* Responsive adjustments */
        @media (max-width: 600px) {
            .login-container {
                padding: 30px 20px;
            }
            
            h1 {
                font-size: 1.8rem;
            }
            
            p {
                font-size: 1rem;
            }
        }
        
        /* Google button customizations */
        .g_id_signin > div {
            border-radius: 8px !important;
            height: 50px !important;
        }
    </style>    
    
    
    
    
    <script src="https://accounts.google.com/gsi/client" async defer></script>
</head>
<body>
    <div class="login-container">
        <h1>Welcome to IQ Test Game</h1>
        <p>Please sign in with your Google account to continue</p>
        
        <div id="g_id_onload"
             data-client_id="<%=com.jspjava.config.GoogleAuthConfig.CLIENT_ID%>"
             data-context="signin"
             data-ux_mode="popup"
             data-callback="handleCredentialResponse"
             data-auto_prompt="false">
        </div>
        
        <div class="g_id_signin"
             data-type="standard"
             data-shape="rectangular"
             data-theme="outline"
             data-text="signin_with"
             data-size="large"
             data-logo_alignment="left">
        </div>
        
        <script>
            function handleCredentialResponse(response) {
                fetch('${pageContext.request.contextPath}/auth/google', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'credential=' + encodeURIComponent(response.credential)
                })
                .then(res => res.json())
                .then(data => {
                    if (data.status === 'success') {
                        window.location.href = '${pageContext.request.contextPath}/' + data.redirect;
                    } else {
                        console.error('Authentication failed:', data.message);
                    }
                })
                .catch(err => console.error('Error:', err));
            }
        </script>
    </div>
</body>
</html>
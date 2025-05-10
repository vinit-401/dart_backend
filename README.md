# 🛡️ Dart Auth Backend with JWT, OTP, and Bearer Auth

A simple authentication backend built with Dart using Shelf. It supports:

 without dart_frog packages

- ✅ User registration and email OTP verification
- 🔐 Secure JWT-based login
- 🔁 Password reset with OTP
- 🚪 Logout via token invalidation
- 🔒 Protected routes with Bearer token

---

## 📁 Project Structure


dart_backend/  
├── bin/  
│ └── main.dart # App entry point  
├── lib/  
│ ├── auth/  
│ │ ├── auth_middleware.dart # Middleware to check JWT  
│ │ ├── jwt_service.dart # JWT generation & blacklist  
│ │ ├── otp_service.dart # OTP generation  
│ ├── handlers/  
│ │ ├── auth_handler.dart # Signup, Signin, OTP, Reset, Logout  
│ │ └── protected_handler.dart # Authenticated route example  
│ ├── models/  
│ │ └── user_model.dart # User model class  
│ ├── services/  
│ │ └── user_service.dart # User business logic  
│ ├── utils/  
│ │ ├── email_sender.dart # Mock email sender (prints OTP)  
│ │ └── response_helpers.dart # JSON response helpers  
├── pubspec.yaml  


---

## 🛠️ Setup

### 1. Install Dart

Make sure you have Dart SDK installed:  
👉 https://dart.dev/get-dart

### 2. Clone this repo

```bash
git clone https://github.com/your-username/dart-auth-backend.git
cd dart-auth-backend


dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.4
  dart_jsonwebtoken: ^2.7.1
  crypto: ^3.0.3
  uuid: ^3.0.7
```

3. 🔑 Sign In
```
http
Copy
Edit
POST /auth/signin
Content-Type: application/json
```
```
{
  "email": "test@example.com",
  "password": "123456"
}  
```  
📦 Returns:

json
Copy
Edit
{ "token": "jwt-token-here" }
4. 🔐 Access Protected Route
http
Copy
Edit
GET /api/dashboard
Authorization: Bearer <jwt-token>
Returns:

json
Copy
Edit
{
  "message": "Welcome to your dashboard!",
  "userId": "<user-id>"
}
5. 🔁 Forgot Password (Send OTP)
http
Copy
Edit
POST /auth/forgot-password
Content-Type: application/json

{
  "email": "test@example.com"
}
6. 🔃 Reset Password
http
Copy
Edit
POST /auth/reset-password
Content-Type: application/json

{
  "email": "test@example.com",
  "otp": "123456",
  "newPassword": "newpass123"
}
7. 🚪 Logout
h
Copy
Edit
POST /auth/logout
Authorization: Bearer <jwt-token>
🧼 Invalidates token (blacklist in memory).

🧪 Testing with curl
bash
Copy
Edit
```
# Signup
curl -X POST http://localhost:8080/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com", "password":"123456"}'

# Verify OTP
curl -X POST http://localhost:8080/auth/verify \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com", "otp":"123456"}'

# Signin
curl -X POST http://localhost:8080/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com", "password":"123456"}'

# Protected route
curl http://localhost:8080/api/dashboard \
  -H "Authorization: Bearer <token>"
``` 
# Logout
curl -X POST http://localhost:8080/auth/logout \
  -H "Authorization: Bearer <token>"
🚀 Future Improvements
Store users and tokens in a database (PostgreSQL, MongoDB)

Use Redis for token blacklisting
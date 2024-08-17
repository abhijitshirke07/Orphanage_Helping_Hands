# Orphanage Donation App


## Table of Contents

- [About the Project](#about-the-project)
- [Key Features](#key-features)
- [Installation](#installation)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)

## About the Project

The Orphanage Donation App is a mobile application designed to streamline the donation process to orphanages. It provides a platform for users to easily donate to various orphanages, view their details, and track their donation history. The app also enables orphanages to manage posts and communicate with donors effectively.

## Key Features

- **User Registration and Login**: Secure user authentication.
- **Orphanage Details**: View detailed information about various orphanages including profile image, name, bio, location, and contact information.
- **Donation Management**: Users can donate to orphanages and track their donation history.
- **Post Management**: Orphanages can create and manage posts to keep donors updated.
- **Profile Management**: Users can update their profile picture, name, and view their donation history.
- **Stripe Payment Integration**: Secure online payment processing via Stripe.
- **Firestore Database**: Data storage and retrieval for orphanages, posts, and donation history.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/orphanage-donation-app.git

2. Navigate to the project directory:
   ```bash
   cd orphanage-donation-app

3. Install the required dependencies:
   ```bash
   flutter pub get

4. Configure Firebase:
- Add your **`google-services.json`** and **`GoogleService-Info.plist`** files to the appropriate directories.
- Set up Firebase Authentication, Firestore, and Firebase Storage.

## Usage

1. Run the application:
   ```bash
   flutter run

2. Register a new account or log in with an existing account.
3. Explore orphanages, make donations, and track your history.

## Screenshots

1. Donar UI <br><br>
![Screenshot 2024-08-11 130518](https://github.com/user-attachments/assets/19d9b380-41c6-4a08-a07b-39f13db67ddb) <br>
![Screenshot 2024-08-09 122653](https://github.com/user-attachments/assets/b6dbea89-82cf-459f-a5ed-864f45263505) &nbsp;&nbsp;&nbsp;
![Screenshot 2024-08-09 122639](https://github.com/user-attachments/assets/769335a9-b11b-45e7-93df-43542c927474) <br>
![Screenshot 2024-08-09 122359](https://github.com/user-attachments/assets/39572e47-40fa-4bab-a3dc-977636a1f5ec) &nbsp;&nbsp;&nbsp;
![Screenshot 2024-08-11 130229](https://github.com/user-attachments/assets/acfd1f37-b2d9-4162-9ba3-3ae6bb777099) <br>
![Screenshot 2024-08-11 130412](https://github.com/user-attachments/assets/111d07fc-f583-48a4-825b-15999b73b246) &nbsp;&nbsp;&nbsp;
![Screenshot 2024-08-11 130317](https://github.com/user-attachments/assets/db2a6509-26eb-47d4-afac-f2828607bb6c) <br><br><br>

2. Orphanage UI <br><br>
![Screenshot 2024-08-17 192534](https://github.com/user-attachments/assets/56f3838b-578a-4557-b1b6-9221de385855)&nbsp;&nbsp;&nbsp;
![Screenshot 2024-08-17 193414](https://github.com/user-attachments/assets/0409fc1a-f6d0-4882-b1a5-886cdecaac30)<br><br>
![Screenshot 2024-08-17 193442](https://github.com/user-attachments/assets/990517ab-fbf4-465b-bd5b-d6ee8b17b7f8)&nbsp;&nbsp;&nbsp;
![Screenshot 2024-08-17 201429](https://github.com/user-attachments/assets/76c14bd7-e818-4f48-b2f6-c40b4ebcf62e) <br><br><br>


## Project Structure

lib/<br>
│<br>
├── main.dart<br>
├── models/                        # Data models for Firestore collections<br>
│   └── orphanage_model.dart<br>
│<br>
├── orphanage_screens/                       # Screens for the app<br>
│   ├── orphanage_welcome_screen.dart<br> 
│   ├── orphanage_signin_screen.dart<br>
│   ├── orphanage_home_screen.dart<br>
│   ├── orphanage_postform_screen.dart<br>
│   └── orphanage_profile_screen.dart<br>
│<br>
├── screens/                       # Screens for the app<br>
│   ├── welcome_screen.dart<br>
│   ├── signin_screen.dart<br>
│   ├── signup_screen.dart<br>
│   ├── home_screen.dart<br>
│   ├── search_screen.dart<br>
│   ├── orphanage_screen.dart<br>
│   ├── paymentform_screen.dart<br>
│   ├── paymentgateway_screen.dart<br>
│   └── profile_screen.dart<br>
│<br>
├── services/                      # Services for interacting with Firestore, Firebase Auth, etc. <br>
│   └── stripe_service.dart<br>
│<br>
├── theme/                         # colors <br> 
│   └── theme.dart<br>
│<br>
└── widgets/                       # Reusable UI components<br>
│   ├── custom_scaffold.dart  
│   ├── welcome_button.dart<br>
│   ├── rectangualar_card.dart<br>
│   └── rectangular_card1.dart<br>
│<br>
└── main.dart <br>
│<br>
└──selectUsser_screen.dart <br>


## Tech Stack

- **Flutter:** Frontend framework 
- **Firebase:** Backend services (Firestore, Firebase Auth, Firebase Storage) 
- **Stripe:** Payment gateway integration 

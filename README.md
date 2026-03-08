# 🧺 Kasir Laundry Pro Services

Kasir Laundry Pro Services is a robust backend application tailored for laundry management, designed to streamline operations and enhance efficiency. This service acts as the core API that powers laundry merchant applications, allowing for seamless service delivery in the laundry industry.

---

## ✨ Features

- **Authentication & Authorization**: Secure login, session management, and OAuth integration via Google.
- **Order Management**: Create, update, and fetch order/transaction data easily.
- **Customer Management**: Maintain comprehensive profiles and histories for all laundry customers.
- **Settings & Configurations**:
  - Profile Settings
  - Service Management (Pricing, Items, Durations)
- **Financial Tracking**: Support for payment tracking and granular expanse reports.
- **Receipt Generation**: Generate receipts and handle printer integrations.
- **Email Support**: Trigger notifications and communications directly via Mailjet.

---

## 🏗 Project Structure

The codebase follows a modular structure to maintain scalability.

```
src/
├── api.ts              # Express application configuration and middleware setup
├── server.ts           # Server entry point
├── database/           # Database connections (Supabase, PostgreSQL)
├── middlewares/        # Custom Express middlewares (e.g., Auth protection)
├── routes/             # Centralized routing directory
│   └── index.ts        # Aggregation of all V1 API routes
└── modules/            # Feature-based modular logic
    ├── auth            # Authentication controllers and routes
    ├── customer        # Customer data management
    ├── transaction     # Order and transaction processing
    ├── services        # Laundry services and definitions
    ├── duration        # Turnaround times and durations
    ├── printer         # Bluetooth/Thermal printer operations
    ├── payments        # Billing and checkout systems
    ├── report          # Business and summary reports
    ├── expanse         # Expanse logging
    ├── notes           # Order/customer notes
    ├── email-support   # Mailjet API configurations
    └── user            # Internal dashboard user operations
```

---

## 🚀 Getting Started

### Prerequisites

You need the following installed:
- [Node.js](https://nodejs.org/en/) (v16 or higher)
- [npm](https://npmjs.com/) or [yarn](https://yarnpkg.com/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd merchant-app-be
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Environment Setup:**
   Create a `.env` file in the root of your project. Provide the following essential variables:
   ```env
   NODE_ENV=development
   PORT=8080
   SESSION_SECRET=your_super_secret_key
   API_URL=http://localhost:8080
   # Add your database and other service credentials here
   ```

### Running the Project

- **Development Mode** (with auto-reload):
  ```bash
  npm run dev
  ```
- **Production Built**:
  ```bash
  npm run build
  npm start
  ```

---

## 🛠 Tech Stack

- **Framework**: [Express.js](https://expressjs.com/)
- **Language**: [TypeScript](https://www.typescriptlang.org/)
- **Database**: PostgreSQL (via `pg`) and [Supabase](https://supabase.com/)
- **Authentication**: Passport.js, JWT, bcrypt
- **File Uploads**: Multer
- **Email Service**: Mailjet

---

## 📝 Authors

- [@Saiful](https://www.github.com/ipuldev)
- [@Rama](https://github.com/arif-ramadhan)

---

## 📄 License

This project is proprietary and intended for internal operations. All rights reserved.
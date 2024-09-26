-- Create table for membership_applications
CREATE TABLE "applications" (
    "application_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "full_name" TEXT NOT NULL,
    "date_birth" NUMERIC NOT NULL,
    "cnic_number" TEXT UNIQUE NOT NULL, -- 13 digit unique national identification card number
    "guardian_name" TEXT NOT NULL,
    "current_address" TEXT NOT NULL,
    "permanent_address" TEXT NOT NULL,
    "gender" TEXT CHECK("gender" IN ('Male', 'Female', 'Other')) NOT NULL, -- Enforces specific gender values
    "membership_type_id" INTEGER NOT NULL,
    "email" TEXT UNIQUE, -- Nullable by default
    "phone_number" TEXT UNIQUE NOT NULL,
    "profile_picture_path" TEXT, -- Nullable by default
    "referral_member_card_number" TEXT, -- Nullable by default
    "date_created" NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "application_status" TEXT DEFAULT 'pending' NOT NULL CHECK("application_status" IN ('pending', 'approved', 'rejected')),
    "application_type" TEXT DEFAULT 'online' CHECK("application_type" IN ('manual', 'online')) NOT NULL,

    FOREIGN KEY ("membership_type_id") REFERENCES "membership_types" ("id")
);

-- Create table for members whose application is approved
CREATE TABLE "members" (
    "member_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "application_id" INTEGER,
    "current_address" TEXT NOT NULL,
    "permanent_address" TEXT NOT NULL,
    "email" TEXT UNIQUE,
    "phone_number" TEXT UNIQUE NOT NULL,
    "profile_picture_path" TEXT,
    "card_number" TEXT UNIQUE NOT NULL,
    "date_joined" NUMERIC NOT NULL,
    "active_requests" INTEGER DEFAULT 0,

    FOREIGN KEY ("application_id") REFERENCES "applications" ("application_id")
);

-- Create table to represent different types of memberships available
CREATE TABLE "membership_types" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" TEXT NOT NULL,
    "renewal_fee" REAL NOT NULL
);

-- Create table to represent library staff details
CREATE TABLE "employees" (
    "employee_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "full_name" TEXT NOT NULL,
    "date_birth" NUMERIC NOT NULL,
    "cnic_number" TEXT UNIQUE NOT NULL,
    "father_name" TEXT,
    "current_address" TEXT NOT NULL,
    "permanent_address" TEXT NOT NULL,
    "gender" TEXT CHECK("gender" IN ('Male', 'Female', 'Other')) NOT NULL,
    "hire_date" NUMERIC,
    "termination_date" NUMERIC,
    "email" TEXT UNIQUE NOT NULL,
    "phone_number" TEXT UNIQUE NOT NULL,
    "profile_picture_path" TEXT NOT NULL,
    "salary" REAL NOT NULL,
    "job_title" TEXT NOT NULL,
    "job_shift" TEXT NOT NULL,
    "qualification" TEXT,
    "department_id" INTEGER,

    FOREIGN KEY ("department_id") REFERENCES "departments" ("department_id")
);

-- Create table to represent the different working departments of library
CREATE TABLE "departments" (
    "department_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- Create table to represent books
CREATE TABLE "books" (
    "book_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "publisher_id" INTEGER,
    "publication_date" NUMERIC,
    "category_id" INTEGER,
    "isbn" TEXT UNIQUE,
    "format" TEXT,
    "edition" TEXT,
    "language" TEXT,
    "shelf_location" TEXT,
    "copies_available" INTEGER NOT NULL,
    "acquisition_date" NUMERIC,
    "availability_status" TEXT CHECK ("availability_status" IN ('lent-out', 'reserved', 'available')),
    "total_pages" INTEGER,
    "volume_number" INTEGER,
    "series_name" TEXT,
    "condition" TEXT,
    "cover_image" TEXT,

    FOREIGN KEY ("publisher_id") REFERENCES "publishers" ("publisher_id"),
    FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id")
);

-- Create table to represent book publishers
CREATE TABLE "publishers" (
    "publisher_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "email" TEXT,
    "phone_number" TEXT
);

-- Create table to represent book categories
CREATE TABLE "categories" (
    "category_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- Create table to represent book authors
CREATE TABLE "authors" (
    "author_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- Create table to represent which author wrote which book.
CREATE TABLE "book_authors" (
    "book_id" INTEGER NOT NULL,
    "author_id" INTEGER NOT NULL,

    PRIMARY KEY ("book_id", "author_id"),
    FOREIGN KEY ("book_id") REFERENCES "books" ("book_id"),
    FOREIGN KEY ("author_id") REFERENCES "authors" ("author_id")
);

-- Create table to represent book reservations
CREATE TABLE "reservations" (
    "reservation_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "book_id" INTEGER NOT NULL,
    "member_id" INTEGER NOT NULL,
    "reservation_time" NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "status" TEXT NOT NULL,

    FOREIGN KEY ("book_id") REFERENCES "books" ("book_id"),
    FOREIGN KEY ("member_id") REFERENCES "members" ("member_id")
);

-- Create table to represent book loans
CREATE TABLE "loans" (
    "loan_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "book_id" INTEGER NOT NULL,
    "member_id" INTEGER NOT NULL,
    "loan_date" NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "due_date" NUMERIC NOT NULL,
    "return_date" NUMERIC,
    "loan_status" TEXT DEFAULT "lent_out",

    FOREIGN KEY ("book_id") REFERENCES "books" ("book_id"),
    FOREIGN KEY ("member_id") REFERENCES "members" ("member_id")
);

-- Create table to represent fines associated with loans.
CREATE TABLE "fines" (
    "fine_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "loan_id" INTEGER NOT NULL,
    "fine_amount" REAL NOT NULL,
    "payment_status" TEXT NOT NULL,
    "payment_date" NUMERIC,

    FOREIGN KEY ("loan_id") REFERENCES "loans" ("loan_id")
);

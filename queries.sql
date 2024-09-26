-- Create new membership types
INSERT INTO "membership_types" ("type", "renewal_fee")
VALUES ('General', 550);

-- Allow admins of the library to create new departments
INSERT INTO "departments" ("name")
VALUES ('Administration');

-- Allow librarians to add new categories for books.
INSERT INTO "categories" ("name")
VALUES ('Poetry');

-- Allow librarians to add new publishers for books.
INSERT INTO "publishers" ("name", "address", "email", "phone_number")
VALUES ('Dar-e-Arqam Publications', 'Street 2, Anarkali Bazaar', 'darearqam@email.com', '+923078978989');

-- Allow librarians to add authors of books.
INSERT INTO "authors" ("name")
VALUES ('Allama Iqbal');

/*
    This insert statement will let 'NEW' users who previously did not have any
    record (inlcuding paper record) in library to apply for library memberships.
    As the application is submitted the application_status is set to pending by default,
    and all pending applications need to be approved by a librarian.
*/

INSERT INTO "applications" (
    "full_name", "date_birth", "cnic_number", "guardian_name", "current_address",
    "permanent_address", "gender", "membership_type_id", "email",
    "phone_number", "profile_picture_path", "referral_member_card_number"
)

VALUES (
    'Ibrahim Bashir', '2000-01-01', '3120212345678', 'Javed Hanif', '123 Main Boulevard',
    '123 Main Boulevard', 'Male', 1, 'ibrahim@email.com',
    '+923067512121', 'images/profile-pics/ibrahim_bashir_pic.png', '876876876'
);

/*
    This transaction will help a librarian to approve a 'pending' application.
    Once an application is approved, it's application_status is updated to
    'approved', and the user becomes a member of the library.
    Their record is then inserted into the members table. Initially, all the fields except for
    'card_number' and 'date_joined' are copied from the applications table.
    This will allow the member to later update these records in case of a change.
*/

BEGIN TRANSACTION;
UPDATE "applications"
SET "application_status" = 'approved'
WHERE "application_id" = 1;

INSERT INTO "members" (
    "application_id", "current_address",
    "permanent_address", "email", "phone_number",
    "profile_picture_path", "card_number",
    "date_joined"
)

VALUES (
    1, '123 Main Boulevard', '123 Main Boulevard',
    'ibrahim@email.com', '+923067512121',
    'images/profile-pics/ibrahim_bashir_pic.png', '456456456',
    '2024-09-02'
);

COMMIT;

/*
    This transaction will help library staff to digitize the records of
    'EXISTING' library members. An employee will specify the member
    details except for their 'email', and 'profile_picture' since this info
    is not yet available. Once all the data is entered then the librarian will
    submit the form. Once the form is submitted the application_status is instantly
    set to 'approved' and application_type is set to 'manual' to emphasize that this
    application was created by staff.
*/

BEGIN TRANSACTION;
INSERT INTO "applications" (
    "full_name", "date_birth", "cnic_number", "guardian_name", "current_address",
    "permanent_address", "gender", "membership_type_id",
    "phone_number", "referral_member_card_number",
    "application_type", "application_status"
)

VALUES (
    'John Doe', '1990-01-01', '31202787877887', 'John Sr', '123 Main Highway',
    '123 Main Highway', 'Male', 1,
    '+923086756412', '000000000', 'manual', 'approved'
);

INSERT INTO "members" (
    "application_id", "current_address",
    "permanent_address", "phone_number",
    "card_number", "date_joined"
)

VALUES (
    2, '123 Main Highway', '123 Main Highway',
    '+923086756412', '876876876', '2020-01-01'
);

COMMIT;

-- Allow admins to create profile for an employee
INSERT INTO "employees" (
    "full_name", "date_birth", "cnic_number", "father_name",
    "current_address", "permanent_address", "gender",
    "hire_date", "email",
    "phone_number", "profile_picture_path", "salary", "job_title",
    "job_shift", "qualification", "department_id"
)

VALUES (
    'Javaid Iqbal', '1980-02-29', '3120298088888', 'Rana Iqbal',
    '12th Street, Model Town', '12th Street, Model Town', 'Male',
    '2021-05-28', 'javaid@email.com', '+923007875253',
    'images/employees/javaid_iqbal.png', 50000,
    'Chief Librarian', 'Morning', 'PHD Library Sciences',
    (SELECT "department_id" FROM "departments" WHERE "name" = 'Administration')
);

/*
    This insert statement is going to allow librarians to add new books into the
    database. The publisher_id and category_id values are inserted by selecting them
    from their respective tables using a subquery.
*/

INSERT INTO "books" (
    "title", "publisher_id", "publication_date", "category_id", "format",
    "edition", "language", "shelf_location", "copies_available", "acquisition_date",
    "availability_status", "condition", "cover_image"
)

VALUES (
    'Bang e Dara',
    (SELECT "publisher_id" FROM "publishers" WHERE "name" = 'Dar-e-Arqam Publications'),
    '1913-01-01',
    (SELECT "category_id" FROM "categories" WHERE "name" = 'Poetry'),
    'Hard', 'First', 'Persian', 'Room 2 shelf 3', 6, '2001-08-09',
    'available', 'excellent', 'images/books/bang_e_dara.png'
);

-- This functionality will allow librarians to specify the authors for a book.
INSERT INTO "book_authors" ("book_id", "author_id")
VALUES (
    (SELECT "book_id" FROM "books" WHERE "title" = 'Bang e Dara'),
    (SELECT "author_id" FROM "authors" WHERE "name" = 'Allama Iqbal')
);

/*
    The following transaction will help make sure that as a member makes
    reservation for a book then the book and member's records are updated
    correctly. Once a book is reserved it is not available anymore to other members
    and the active_requests of the member who reserved the book is incremented.
*/

BEGIN TRANSACTION;

-- Allow members to make reservations for books
INSERT INTO "reservations" ("book_id", "member_id", "status")
VALUES (
    (SELECT "book_id" FROM "books" WHERE "title" = 'Bang e Dara'),
    (SELECT "member_id" FROM "members" WHERE "card_number" = '456456456'),
    'pending'
);

UPDATE "books" SET "availability_status" = 'reserved'
WHERE "title" = 'Bang e Dara';

UPDATE "members" SET "active_requests" = ("active_requests" + 1)
WHERE "card_number" = '456456456';

COMMIT;

/*
    This transaction will help library staff to fulfill the book reservations. Once a reservation is
    fulfilled i.e: the book is lent out, the reservation status is updated to fulfilled and a
    loan record is inserted in loans table.
*/

BEGIN TRANSACTION;

UPDATE "reservations" SET "status" = 'fulfilled'
WHERE "reservation_id" = 1;

INSERT INTO "loans" ("book_id", "member_id", "due_date")
VALUES (
    (SELECT "book_id" FROM "reservations" WHERE "reservation_id" = 1),
    (SELECT "member_id" FROM "reservations" WHERE "reservation_id" = 1),
    datetime('now', '+14 days')
);

COMMIT;

/*
    This transaction will allow library staff to issue book loans. Here it is assumed that no prior
    reservation was made and the member requested a loan on the spot. A loan record is created in loans
    table, book status is updated to lent out and active requests of the member is incremented by 1.
*/

BEGIN TRANSACTION;

INSERT INTO "loans" ("book_id", "member_id", "due_date")
VALUES (
    (SELECT "book_id" FROM "books" WHERE "title" = 'Bang e Dara'),
    (SELECT "member_id" FROM "members" WHERE "card_number" = '456456456'),
    datetime('now', '+14 days')
);

UPDATE "books" SET "availability_status" = 'lent-out'
WHERE "title" = 'Bang e Dara';

UPDATE "members" SET "active_requests" = "active_requests" + 1
WHERE "card_number" = '456456456';

COMMIT;

/*
    This transaction will allow library staff to process book returs. The loan record is updated and
    loan status is set to returned against the matching book_id and member_id.
    Book status is updated to available and active requests of the member is decremented by 1.
*/


BEGIN TRANSACTION;

UPDATE "loans" SET "loan_status" = 'returned'
WHERE "book_id" = (
    SELECT "book_id" FROM "books" WHERE "title" = 'Bang e Dara'
) AND "member_id" = (
    SELECT "member_id" FROM "members" WHERE "member_id" = '456456465'
);

UPDATE "books" SET "availability_status" = 'available'
WHERE "title" = 'Bang e Dara';

UPDATE "members" SET "active_requests" = "active_requests" - 1
WHERE "card_number" = '456456456';

COMMIT;

-- This select will allow library staff to view all the applications
SELECT * FROM "membership_requests";

-- This select will allow library staff to search for a particular application using cnic_number
SELECT * FROM "membership_requests" WHERE "cnic_number" = '3120212345678';

-- This statement will allow library staff and the library member to search and look up their details
-- It uses both cnic_number and card_number for verification before showing results.
SELECT
    "full_name", "date_birth", "cnic_number", "guardian_name",
    "gender", "current_address", "phone_number", "profile_picture_path",
    "card_number", "date_joined", "active_requests", "membership_type"
FROM "member_details"
WHERE "cnic_number" = '3120212345678' AND "card_number" = '456456456';

-- This statement will help create a profile page where employee details are shown
SELECT * FROM "employee_details"
WHERE "cnic_number" = '3120298088888';

SELECT
    "title", "publication_date", "isbn", "format", "edition", "language",
    "shelf_location", "copies_available", "acquisition_date", "availability_status",
    "total_pages", "volume_number", "series_name", "condition", "cover_image",
    "category", "publisher", "condition", "author"
FROM "book_details";

-- This select statement will allow library staff to view all reservations made
SELECT
    "reservation_time", "status", "title", "edition", "language", "shelf_location",
    "availability_status", "volume_number", "series_name", "cover_image", "category",
    "full_name", "date_birth", "cnic_number", "gender", "email", "phone_number",
    "profile_picture_path", "card_number", "active_requests", "membership_type"
FROM "reservation_requests";

-- This select statement will allow library staff to view a particular reservation using member's card_number
SELECT
    "reservation_time", "status", "title", "edition", "language", "shelf_location",
    "availability_status", "volume_number", "series_name", "cover_image", "category",
    "full_name", "date_birth", "cnic_number", "gender", "email", "phone_number",
    "profile_picture_path", "card_number", "active_requests", "membership_type"
FROM "reservation_requests"
WHERE "card_number" = '456456456';

SELECT
    "loan_date", "due_date", "return_date", "fine_amount", "payment_status",
    "payment_date", "title", "language", "shelf_location", "volume_number",
    "series_name", "cover_image", "category", "publisher", "condition", "edition",
    "full_name", "date_birth", "cnic_number", "email", "phone_number", "profile_picture_path",
    "card_number"
 FROM "loan_details";

SELECT
    "loan_date", "due_date", "return_date", "fine_amount", "payment_status",
    "payment_date", "title", "language", "shelf_location", "volume_number",
    "series_name", "cover_image", "category", "publisher", "condition", "edition",
    "full_name", "date_birth", "cnic_number", "email", "phone_number", "profile_picture_path",
    "card_number"
 FROM "loan_details" WHERE "card_number" = '456456456';

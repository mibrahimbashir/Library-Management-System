# Library Management System

By Muhammad Ibrahim Bashir

## Scope

### Purpose

The Database for Bahawalpur Central Library located in Bahawalpur, Pakistan is designed to digitize and streamline the management of library records. Its primary goal is to facilitate easy searching and retrieval of books for general public and especially the library members, allowing them to quickly find available books and lend them out. For librarians, the database provides a comprehensive tool to track book loans, manage inventory, and oversee all related activities such as fines and reservations efficiently. The database encompasses the following:

### Overview

* Books: Detailed records including title, author(s), category, shelf location, and availability status.

* Members: Information about library members, including personal details, membership type, and borrowing history.

* Employees: Records of librarians and staff responsible for managing book loans and other administrative tasks.

* Transactions: Logs of book loans, returns, reservations, and any related activities.

### Out of Scope

* External Bookstores: Information about books and transactions from external vendors or bookstores.

* Library Events: Records of library events, programs, or community outreach activities.

* Personal Data Beyond Library Use: Any personal data about members or staff unrelated to library transactions and records.

## Functional Requirements

### Features Supported

This database is designed to support:

* CRUD (Create, Read, Update, Delete) operations for library-related data, including books, authors, and employees.

* Creation of new online applications by users to apply for library membership.

* Library staff, to digitize the existing paper records of library members and also to approve new online applications. To digitze records, library staff will create applications which will be instantly approved.

* Searching for and retrieving information about employees and library members efficiently.

* Searching for and retrieving information about books and their location in library.

* Library staff to issue book loans and fulfill book reservations and keep track of fines related to books not being returned.

### Out of Scope Features

This database does not support

* Library members to post reviews about books or leave rating stars.

* Library staff to create / maintain record of books lent out in the past.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Applications

The `applications` table includes

* `application_id`,  which specifies the unique ID for the Application as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied and is set to `AUTOINCREMENT`.

* `application_status`, which is a `TEXT` field and specifies the status of appliaction. This column has a `CHECK` constraint and can only take values of either 'pending', 'rejected', or 'approved'. The `DEFAULT` value is 'pending'.

* `application_type`, which  records the method of application submission, taking either 'online' or 'manual' as values. The `DEFAULT` is 'online' for new users applying through the library's online system. 'Manual' is used when library staff digitize existing records by creating applications for users with prior records.

* `cnic_number`, which is the 13 digit national identification card of user and has `UNIQUE` constraint applied. `TEXT` data type is used.

* `current_address`, which specifies the 'current_address' of the user as `TEXT`, given `TEXT` is appropriate for address fields.

* `permanent_address`, which specifies the 'permanent_address' of the user as `TEXT`

* `date_birth`, is the birth date of user.

* `date_created`, which species the time at which the application was submitted. The `DEFAULT` value for this column is `CURRENT_TIMESTAMP`.

* `email`, a `TEXT` attribute which specifies the email of the user. This column does not have a `NOT NULL` constraint. Since existing library members would not have provided email when applying for membership, making the email field nullable will allow library staff to create applications for such members to digitize the records. When an email is specified then a `UNIQUE` constraint will make sure that no two library members have same email.

* `full_name`, which specifies the full name of the user as `TEXT`.

* `gender`, which specifies the sex of user taking values of either 'Male', 'Female' or 'Other'.

* `guardian_name`, which specifies the father / guardian name of the user.

* `membership_type_id`, which is an `INTEGER` specifying the type of membership that the user is applying for.  This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `membership_types` table to ensure data integrity.

* `phone_number`, which is a `TEXT` field specifying the contact number of the user.

* `profile_picture_path`, which is the path, relative to the database, at which the profile pictures for users are stored. This attribute stores a filepath, not the picture files themselves, it is of type affinity `TEXT`. This attribute is allowed to take `NULL` values for the same reason as email attribute.

* `referral_member_card_number`, Since library enforces a system in which each new applicant should be referred by an existing member therefore this attribute specifies the 'library card number' of the member who referred the application as `TEXT`.

All columns except for 'email', 'profile_picture_path', and 'referral_member_card_number' are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

#### Books

The `books` table includes:

* `book_id`, An `INTEGER` column that uniquely identifies each book. It has the `AUTOINCREMENT` feature and serves as the `PRIMARY KEY` for the table.

* `title`. A `TEXT` column that specifies the title of the book. This attribute is required and hence has the `NOT NULL` constraint applied.

* `publisher_id`: An `INTEGER` column that specifies the publisher id of the book. This column has a `FOREIGN KEY` constraint, referencing the `publisher_id` column in the `publishers` table to ensure that only valid publishers are associated with the books.

* `publication_date`: A `NUMERIC` column that records the publication date of the book. The data type is suitable for storing dates. This column can take NULL values in case the publication date is not known.

* `category_id`: An `INTEGER` column that specifies the category id of the book. This column has a `FOREIGN KEY` constraint, referencing the `category_id` column in the `categories` table to ensure that each book is categorized appropriately.

* `isbn`: A `TEXT` column that stores the International Standard Book Number (ISBN) for the book. This attribute has a `UNIQUE` constraint to ensure that no two books share the same ISBN.

* `format`: A `TEXT` column that indicates the format of the book, such as 'hardcover', 'paperback', or 'e-book'.

* `edition`: A `TEXT` column that specifies the edition of the book.

* `language`: A `TEXT` column that records the language in which the book is written.

* `shelf_location`: A `TEXT` column that specifies the physical location of the book within the library. This attribute is allowed to take NULL values in case the library staff needs to figure out to which section the book belongs.

* `copies_available`: An `INTEGER` column that indicates the total number of copies of the book available in the library. This attribute is required and thus has the `NOT NULL` constraint.

* `acquisition_date`: A `NUMERIC` column that records the date the book was acquired by the library.

* `availability_status`: A `TEXT` column that specifies the availability of the book. This attribute has a `CHECK` constraint to ensure that only valid statuses are entered, with possible values being 'lent-out', 'reserved', or 'available'.

* `total_pages`: An `INTEGER` column that records the total number of pages in the book.

* `volume_number`: An `INTEGER` column that specifies the volume number if the book is part of a series.

* `series_name`: A `TEXT` column that stores the name of the series if the book is part of one.

* `condition`: A `TEXT` column that describes the physical condition of the book.

* `cover_image`: A `TEXT` column that stores the file path to the book's cover image.

#### Employees

The `employees` table includes

* `employee_id`, which specifies the unique ID for the employee as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.

* `full_name`, which specifies the full name of the employee as `TEXT`.

* `date_birth`, which records the date of birth of the employee. This attribute is of `NUMERIC` data type.

* `cnic_number`, which is the 13-digit unique national identification card number of the employee. It is of `TEXT` data type and has a `UNIQUE` constraint applied.

* `father_name`, which specifies the father name of the employee as `TEXT`.

* `current_address`, which specifies the current residential address of the employee. This attribute uses the `TEXT` data type.

* `permanent_address`, which specifies the permanent residential address of the employee as `TEXT`.

* `gender`, which records the gender of the employee as `TEXT`. The `CHECK` constraint ensures that it can only take values of 'Male', 'Female', or 'Other'.

* `hire_date`, which specifies the date when the employee was hired. It is of `NUMERIC` data type.

* `termination_date`, which specifies the date when the employee was terminated (if applicable). It is also of `NUMERIC` data type.

* `email`, which specifies the email address of the employee as `TEXT`. This column has a `UNIQUE` constraint applied to ensure no two employees share the same email.

* `phone_number`, which records the contact number of the employee as `TEXT` and has a `UNIQUE` constraint.

* `profile_picture_path`, which is the file path where the employee's profile picture is stored. This attribute is of `TEXT` data type.

* `salary`, which specifies the salary of the employee. It is of `REAL` data type.

* `job_title`, which specifies the job title of the employee as `TEXT`.

* `job_shift`, which records the working shift of the employee. It is also of `TEXT` data type.

* `qualification`, which specifies the qualification details of the employee as `TEXT`.

* `department_id`, which is an `INTEGER` specifying the department to which the employee belongs. This column has a `FOREIGN KEY` constraint applied, referencing the `department_id` column in the `departments` table to ensure data integrity.

#### Members

The `members` table includes:

* `member_id`, which specifies the unique ID for the member as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied and uses `AUTOINCREMENT` feature.

* `application_id`, which is an `INTEGER` and identifies the application id of the member when they applied for membership. This column has the `FOREIGN KEY` constraint applied referencing the `application_id` column in the `applications` table. It has the `NOT NULL` constraint applied.

* `current_address`, which specifies the current address of the member as `TEXT`. Given that address fields are typically stored as text, this is an appropriate data type. It has the `NOT NULL` constraint applied.

* `permanent_address`, which specifies the permanent address of the member as `TEXT`. It has the `NOT NULL` constraint applied.

* `email`, a `TEXT` field that specifies the email address of the member. This column has a `UNIQUE` constraint applied to ensure no two members share the same email address.

* `phone_number`, which specifies the contact number of the member as `TEXT`. This has the `UNIQUE` constraint mentioned, so duplicate phone numbers are not allowed. It has the `NOT NULL` constraint applied.

* `profile_picture_path`, which is the path where the member's profile picture is stored, as a `TEXT` field.

* `card_number`, which is a `TEXT` field specifying the unique library membership card number assigned to the member. This column has a `NOT NULL` and `UNIQUE` constraint applied to it.

* `date_joined`, which records the date the member joined the libraru as a member. It is of type affinity `NUMERIC` and has a `NOT NULL` constraint applied to it.

* `active_requests`, which is an `INTEGER` field that tracks the number of active requests the member has made including any book loans or reservations made. This field has a `DEFAULT` value of `0`, assuming new members do not have active requests upon joining.

Note: The attributes `current_address`, `permanent_address`, `email`, `phone_number`, and `profile_picture_path` have been included so that a member can update them in case of a change. Initially the values for these attributes will be copied from the applications table.

#### Membership Types

The `membership_types` table includes:

* `id`, which specifies the unique identifier for the membership type as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.

* `type`, which is a `TEXT` field indicating the type of membership. This field is required and thus has the `NOT NULL` constraint applied.

* `renewal_fee`, which specifies the fee required for library members to pay when they apply for / renew their membership. It is of type `REAL`. This field is also required and has the `NOT NULL` constraint applied.

#### Departments

The `departments` table includes:

* `department_id`, which specifies the unique identifier for the department as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.

* `name`, which is a `TEXT` field indicating the name of the department. This field is required and thus has the `NOT NULL` constraint applied.

#### Publishers

The `publishers` table includes

* `publisher_id`, which specifies the unique ID for the publisher as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied and has the `AUTOINCREMENT` feature.

* `name`, which specifies the name of the publisher as a `TEXT`. This column has the `NOT NULL` constraint applied.

* `address`, which provides the address of the publisher as a `TEXT`. This column does not have any constraints and can be left empty if address is not known.

* `email`, which is the email address of the publisher specified as a `TEXT`. This column does not have any constraints and can be left empty.

* `phone_number`, which specifies the contact number of the publisher as a `TEXT`.

Note: All columns except for `name` are optional and can contain `NULL` values.

#### Categories

The `categories` table includes

* `category_id`, which specifies the unique ID for the category as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied and has the `AUTOINCREMENT` feature.

* `name`, which specifies the name of the category as a `TEXT`. This column has the `NOT NULL` constraint applied.

#### Authors

The `authors` table includes

* `author_id`, which specifies the unique ID for the author as an `INTEGER`. This column has the `PRIMARY KEY` constraint and is set to `AUTOINCREMENT`.

* `name`, which specifies the name of the author as a `TEXT`. This column has the `NOT NULL` constraint applied.

#### Book Authors

The `book_authors` table includes

* `book_id`, which specifies the unique ID for the book as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `book_id` column in the `books` table.

* `author_id`, which specifies the unique ID for the author as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `author_id` column in the `authors` table.

The combination of `book_id` and `author_id` forms the composite `PRIMARY KEY` for the table, ensuring that each book-author pair is unique.

#### Reservations

The `reservations` table includes

* `reservation_id`, which specifies the unique ID for the reservation as an `INTEGER`. This column has the `PRIMARY KEY` constraint and is set to `AUTOINCREMENT`.

* `book_id`, which specifies the unique ID for the book being reserved as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `book_id` column in the `books` table.

* `member_id`, which specifies the unique ID for the member making the reservation as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `member_id` column in the `members` table.

* `reservation_time`, which specifies the time when the reservation was made as `NUMERIC` data type. This column has a `NOT NULL` constraint and a `DEFAULT` value of `CURRENT_TIMESTAMP`.

* `status`, which specifies the status of the reservation as a `TEXT`. This column has the `NOT NULL` constraint applied.

#### Loans

The `loans` table includes

* `loan_id`, which specifies the unique ID for the loan as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied to it and is set to `AUTOINCREMENT`.

* `book_id`, which specifies the unique ID for the book being loaned as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `book_id` column in the `books` table. This column has the `NOT NULL` constraint applied.

* `member_id`, which specifies the unique ID for the member borrowing the book as an `INTEGER`. This column has a `FOREIGN KEY` constraint referencing the `member_id` column in the `members` table. This column has the `NOT NULL` constraint applied.

* `loan_date`, which specifies the date when the loan was made as `NUMERIC`. This column has a `NOT NULL` constraint and a `DEFAULT` value of `CURRENT_TIMESTAMP`.

* `due_date`, which specifies the date by which the book should be returned as `NUMERIC`. This column has the `NOT NULL` constraint applied.

* `return_date`, which specifies the date when the book was actually returned as `NUMERIC`. This column does not have any constraints and can be left empty if the book has not been returned yet.

* `loan_status`, which specifies the current status of the loan as a `TEXT`. This column has a `DEFAULT` value of `lent_out`.

#### Fines

The `fines` table includes

* `fine_id`, which specifies the unique ID for the fine as an `INTEGER`. This column has the `PRIMARY KEY` constraint and is set to `AUTOINCREMENT`.

* `loan_id`, which identifies the ID of the loan associated with the fine as an `INTEGER`. This column has a `FOREIGN KEY` constraint applied and references the `loan_id` column in the `loans` table.

* `fine_amount`, which specifies the amount of the fine as a `REAL`. This column has the `NOT NULL` constraint applied, meaning every fine must have an amount.

* `payment_status`, which specifies the status of the fine payment as a `TEXT`. This column has the `NOT NULL` constraint applied.

* `payment_date`, which specifies the date when the fine was paid as `NUMERIC`. This column does not have any constraints and can be left empty if the fine has not been paid yet.


### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](./ER%20Diagram.svg)

As detailed by the diagram:

* A member can submit one and only one application. An application is submitted by one and only one member. It is assumed that each application is associated with only one member.

* An application is associated with one and only one membership_type. A membership_type can have 1 to many applications.

* A member can refer to 0 to many applications. Each application is referred by one and only one member.

* An employee works in one and only one department. A department can have 1 to many employees working in it.

* A junction table "book_authors" is used to represent the relationship between books and authors. An author referenced in the book_authors table refers a single author in authors table. book_authors table can have 1 or more authors.

* Each book_id in the juction table book_authors references only a single book in the books table.

* A book can be written by 1 or many authors. An author can write 1 or many books.

* A book is published by one and only one publisher. A publisher can publish 1 to many books.

* A book can be categorized under one and only one category. Each category can have 1 to many books categorized under it.

* A member can make 0 to many book reservations. Each reservation is made by one and only one member.

* A book can be reserved 0 to many times through reservations. Each reservation is associated with one and only one book.

* A member can take out 0 to many book loans. Each loan is taken out by one and only one member.

* A loan can incur 0 to 1 fine. Each fine is incurred by one and only one loan.

## Optimizations

### Indexes

Following indexes were created in the database:

* Since `cnic_number` column is unique and every user remembers their card number an index was created on the `cnic_number` column in the `applications` table. This index will allow both the library staff and the users to search for their application and look up the details efficiently.

* For the `applications` table index was also created on the `membership_type_id` column. This index will facilitate `JOIN` operations with the `membership_types` table.

* Each library member has a unique `card_number`, so an index was added to the `card_number` column in the `members` table. This index helps library staff quickly manage book loans, personal information, and fines. Although `cnic_number` could also be indexed, it's not necessary because there’s already an index on `cnic_number` in the `applications` table, which is joined with the `members` table.

* To facilitate `JOIN` operations when creating views, indexes were added to the `publisher_id` and `category_id` columns in the `members` table.

* Since users most commonly search for a book using its title an index was created on the `title` column of the `books` table to speed up searches for books.

* To enhance performance for queries involving book categories, an index was added on the `category_id` column in the `books` table. This index supports faster lookups and joins with the `categories` table. An index was also created on the `publisher_id` column in the `books` table for the same reasons.

* An index was added to the `cnic_number` column in the `employees` table to enable fast lookups of employee records based on their cnic_number. This index improves search efficiency and simplifies data retrieval for HR tasks.

* An index was created on the `name` column in the `authors` table to allow users to search for books written by a particular author. This index facilitates quick lookups and efficient querying based on author names.

* An index was added to the `name` column in the `publishers` table to improve search performance for publishers by their name.

* An index was added on the `name` column in the `categories` table to enhance the improve searching for categories by name. This index will allow users to search for books under a particular category.

* Indexes were created on the `loan_id` columns in the `fines` and `loan_id` tables. These indexes will speed up the `JOIN` operation between these two tables and allow staff to view complete information related to a loan.

* Indexes were created on the `book_id` and `member_id` columns of the `loan_id` table. These indexes will speed up the `JOIN` operation between `members` and `books` table.

### Views

Following views were created in the database:

* `membership_requests`, which will allow library staff to view all *"pending"* applications. This view will facilitate the staff to review the details of an application and either approve or reject it. To provide a complete picture, this view is created by joining the `applications` table with `membership_types` table on `membership_type_id` column.

* `member_details`, This view provides all the details related to a library member. This view was created by joining the `applications` table with `members` table on `application_id` column and joining the resultant table with `membership_types` table on `membership_type_id` column. Attributes which are not allowed to edited such as 'full_name', 'date_birth', 'cnic_number' etc are taken from the `applications` table while information which can be updated such as 'address', 'phone', 'email' etc are taken from the `members` table. This will help members see their personal details on their profile page and also allow staff to verify details when issuing loan.

* `employee_details`, This view will allow HR staff to view details related to a particular employee. This view is created by joining the `employees` table with `departments` table on `department_id` column.

* `book_details`, This view provides comprehensive details about a book. It is created by joining the `books` table with the following tables `categories`, `publishers`, `book_authors`, `authors`. This view will help display all the information about a book on a book display page in a user friendly manner. It combines different attributes to provide users with a complete picture about their favorite book.

* `reservation_requests`, Contains all the book reservations made by library members. It will facilitate the staff to view details about the member and to see against which book the reservation was made. Staff will then be able to fulfill these requests and issue loans.

* `loan_details`, It will allow library staff to look up the details of a particular loan when processing book returns. Staff will make sure that there are no pending fines associated with the loan and also allow them to look up member details in case a loan is not returned after a long period of time.

## Limitations

* The database currently does not support a user to create more than one application in case it is rejected. To allow rejected applicants to apply once again significant improvement would be required in the `applications` table. If a member applies once again this would mean that much of the informtion would be the same as before and therefore table constraints such as the `UNIQUE` constraint on `cnic_number` would fail.


* In this version of the database there is no support for members to post reviews about books that they lent. To allow reviews a separate table would need to be created which handles this information.

* Currently the database does not associate different administrative tasks to a particular employee.  This means that whenever a loan is issued or a new book record is created then the employee who performed these activities is not tagged.

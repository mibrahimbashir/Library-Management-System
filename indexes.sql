-- Create indexes to speed common searches and join operations

CREATE INDEX "idx_applications_cnic" ON "applications" ("cnic_number");
CREATE INDEX "idx_applications_membership_type_id" ON "applications" ("membership_type_id");

CREATE INDEX "idx_members_card_number" ON "members" ("card_number");
CREATE INDEX "idx_members_application_id" ON "members" ("application_id");

CREATE INDEX "idx_employees_cnic_number" ON "employees" ("cnic_number");

CREATE INDEX "idx_books_title" ON "books" ("title");
CREATE INDEX "idx_books_category_id" ON "books" ("category_id");
CREATE INDEX "idx_books_publisher_id" ON "books" ("publisher_id");


CREATE INDEX "idx_authors_name" ON "authors" ("name");
CREATE INDEX "idx_publishers_name" ON "publishers" ("name");
CREATE INDEX "idx_category_name" ON "categories" ("name");

CREATE INDEX "idx_loans_loan_id" ON "loans" ("loan_id");
CREATE INDEX "idx_loans_book_id" ON "loans" ("book_id");
CREATE INDEX "idx_loans_member_id" ON "loans" ("member_id");
CREATE INDEX "idx_fines_loan_id" ON "fines" ("loan_id");

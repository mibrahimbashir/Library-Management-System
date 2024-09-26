-- Create views to facilitate user friendly display of information
CREATE VIEW "membership_requests" AS
SELECT
    a."full_name", a."date_birth", a."cnic_number", a."guardian_name",
    a."current_address", a."permanent_address", a."gender",
    mt."type" AS "membership_type", a."email", a."phone_number",
    a."profile_picture_path", a."referral_member_card_number"
FROM "applications" a
INNER JOIN "membership_types" mt ON mt."id" = a."membership_type_id"
WHERE a."application_status" = 'pending';

CREATE VIEW "member_details" AS
SELECT
    a."full_name", a."date_birth", a."cnic_number",
    a."guardian_name", a."gender", m."current_address",
    m."member_id", m."email", m."phone_number", m."profile_picture_path",
    m."card_number", m."date_joined", m."active_requests",
    mt."type" AS "membership_type"
FROM "members" m
INNER JOIN "applications" a ON a."application_id" = m."application_id"
LEFT JOIN "membership_types" mt ON a."membership_type_id" = mt."id";

CREATE VIEW "employee_details" AS
SELECT
    e."full_name", e."date_birth", e."cnic_number",
    e."father_name", e."current_address", e."permanent_address",
    e."gender", e."hire_date", e."termination_date",
    e."email", e."phone_number", e."profile_picture_path",
    e."salary", e."job_title", e."job_shift", e."qualification",
    d."name" AS "department_name"
FROM "employees" e
INNER JOIN "departments" d ON e."department_id" = d."department_id";

CREATE VIEW "book_details" AS
SELECT
    b."book_id", b."title", b."publication_date", b."isbn", b."format", b."edition",
    b."language", b."shelf_location", b."copies_available",
    b."acquisition_date", b."availability_status",  b."total_pages",
    b."volume_number", b."series_name", b."condition", b."cover_image",
    c."name" AS "category", p."name" AS "publisher", b."condition",
    a.name AS "author"
FROM "books" b
LEFT JOIN "publishers" p ON b."publisher_id" = p."publisher_id"
LEFT JOIN "categories" c ON b."category_id" = c."category_id"
LEFT JOIN "book_authors" ba ON b."book_id" = ba."book_id"
LEFT JOIN "authors" a ON ba."author_id" = a."author_id";

CREATE VIEW "reservation_requests" AS
SELECT
    r."reservation_id", r."reservation_time", r."status",
    b."book_id", b."title", b."edition", b."language", b."shelf_location",
    b."availability_status", b."volume_number",
    b."series_name", b."cover_image", b."category",
    m."member_id", m."full_name", m."date_birth", m."cnic_number",
    m."gender", m."email", m."phone_number",
    m."profile_picture_path", m."card_number",
    m."active_requests", m."membership_type"
FROM "reservations" r
INNER JOIN "book_details" b ON r."book_id" = b."book_id"
INNER JOIN "member_details" m ON r."member_id" = m."member_id"
WHERE r."status" = 'pending';

CREATE VIEW "loan_details" AS
SELECT
    l."loan_id", l."loan_date", l."due_date", l."return_date",
    f."fine_amount", f."payment_status", f."payment_date",
    b."title", b."language", b."shelf_location",
    b."volume_number", b."series_name", b."cover_image",
    b."category", b."publisher", b."condition", b."edition",
    m."full_name", m."date_birth", m."cnic_number", m."email",
    m."phone_number", m."profile_picture_path",m."card_number"
FROM "loans" l
LEFT JOIN "fines" f ON l."loan_id" = f."loan_id"
INNER JOIN "book_details" b ON b."book_id" = l."book_id"
INNER JOIN "member_details" m ON m."member_id" = l."member_id";

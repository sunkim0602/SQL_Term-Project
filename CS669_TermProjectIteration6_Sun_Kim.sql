--TABLES
DROP TABLE Price_Change
DROP TABLE travel_criteria;
DROP TABLE additional_accommodations;
DROP TABLE booking;
DROP TABLE payment_information;
DROP TABLE card_information;
DROP TABLE reserve_membership;
DROP TABLE platinum_membership;
DROP TABLE gold_membership;
DROP TABLE membership_program;
DROP TABLE pricing_data;
DROP TABLE approver_profile;
DROP TABLE user_profile;
DROP TABLE account_profile;
DROP TABLE user_information;
DROP TABLE department_info;
DROP SEQUENCE titleID;
DROP SEQUENCE user_information_seq;
DROP SEQUENCE account_profile_seq;
DROP SEQUENCE approver_profile_seq;
DROP SEQUENCE user_profile_seq;
DROP SEQUENCE pricing_data_seq;
DROP SEQUENCE membership_program_seq;
DROP SEQUENCE gold_membership_seq;
DROP SEQUENCE platinum_membership_seq;
DROP SEQUENCE reserve_membership_seq;
DROP SEQUENCE payment_information_seq;
DROP SEQUENCE booking_seq;
DROP SEQUENCE additional_accommodations_seq;
DROP SEQUENCE travel_criteria_seq;

CREATE TABLE department_info (
    TitleID DECIMAL(12) PRIMARY KEY,
    Department VARCHAR (64) NOT NULL,
);

CREATE TABLE user_information (
    UserInformationID DECIMAL (12) NOT NULL PRIMARY KEY,
    TitleID DECIMAL (12) NOT NULL FOREIGN KEY REFERENCES department_info(TitleID),
    EmployeeEmail VARCHAR (255) NOT NULL,
    FirstName VARCHAR (100) NOT NULL,
    LastName VARCHAR (100) NOT NULL,
    PhoneNumber DECIMAL (20) NOT NULL,
    Gender CHAR (1) NOT NULL,
    HireDate DATE NOT NULL,
    EmploymentStatus VARCHAR (20),
);

CREATE TABLE account_profile (
    AccountProfileID DECIMAL(12) NOT NULL PRIMARY KEY,
    UserInformationID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES user_information(UserInformationID),
    AccountID VARCHAR(255) NOT NULL,
    Password VARCHAR(128) NOT NULL,
    ManagerEmployeeID VARCHAR (64) NOT NULL,    
);

CREATE TABLE user_profile (
    AccountProfileID DECIMAL(12) NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES account_profile(AccountProfileID),
);

CREATE TABLE approver_profile (
    AccountProfileID DECIMAL(12) NOT NULL Primary KEY FOREIGN KEY REFERENCES account_profile(AccountProfileID),
    DirectReportEmployeeID VARCHAR(64) NULL,
);

CREATE TABLE pricing_data (
    PricingDataID DECIMAL(12) NOT NULL PRIMARY KEY,
    ComparisonPrice DECIMAL(6, 2) NOT NULL,
    ComparisonDate DATE NOT NULL,
    ComparisonEmmission VARCHAR(20) NOT NULL,
);

CREATE TABLE membership_program (
    MembershipProgramID DECIMAL(12) PRIMARY KEY,
    MembershipType VARCHAR(20),
    StartDate DATE,
    Status VARCHAR(20),
    MileagePoints DECIMAL(15) NOT NULL,
    LastActivityDate DATE NOT NULL,
);

CREATE TABLE gold_membership (
    MembershipProgramID DECIMAL(12) PRIMARY KEY FOREIGN KEY REFERENCES membership_program(MembershipProgramID),
);

CREATE TABLE platinum_membership (
    MembershipProgramID DECIMAL(12) PRIMARY KEY FOREIGN KEY REFERENCES membership_program(MembershipProgramID),
);

CREATE TABLE reserve_membership (
    MembershipProgramID DECIMAL(12) PRIMARY KEY FOREIGN KEY REFERENCES membership_program(MembershipProgramID),

);

CREATE TABLE card_information (
    CardNumber VARCHAR(16) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    ThreeDigitCode VARCHAR(4) NOT NULL,
    ExpirationDate DATE NOT NULL,
);

CREATE TABLE payment_information (
    PaymentInformationID DECIMAL(12) PRIMARY KEY NOT NULL,
    CardNumber VARCHAR(16) FOREIGN KEY REFERENCES card_information(CardNumber) NOT NULL,
);

CREATE TABLE booking (
    BookingID DECIMAL(12) PRIMARY KEY NOT NULL,
    AccountProfileID DECIMAL(12) FOREIGN KEY REFERENCES account_profile(AccountProfileID) NOT NULL,
    PaymentInformationID DECIMAL(12) FOREIGN KEY REFERENCES payment_information(PaymentInformationID) NOT NULL,
    MembershipProgramID DECIMAL(12) FOREIGN KEY REFERENCES membership_program(MembershipProgramID),
    PricingDataID DECIMAL(12) FOREIGN KEY REFERENCES pricing_data(PricingDataID) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    PassportNumber VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    Cost DECIMAL (6, 2),
    BookingDate DATE 
);

CREATE TABLE additional_accommodations (
    AdditionalAccommodationsID DECIMAL(12) PRIMARY KEY,
    BookingID DECIMAL(12) FOREIGN KEY REFERENCES booking(BookingID) NOT NULL,
    SeatPreference CHAR(1),
    CheckInBaggage CHAR(1),
    FoodandBeverage VARCHAR(256),
);

CREATE TABLE travel_criteria (
    TravelCriteriaID DECIMAL(12) PRIMARY KEY NOT NULL,
    BookingID DECIMAL(12) FOREIGN KEY REFERENCES booking(BookingID) NOT NULL,
    DepartingCity VARCHAR(128) NOT NULL,
    ArrivalCity VARCHAR(128) NOT NULL,
    DepartingDate DATE NOT NULL,
    ReturnDate DATE,
    Airline VARCHAR(100),
    RoundTripOption CHAR(1) NOT NULL,
    Price DECIMAL(6, 2) NOT NULL,
);

CREATE TABLE Price_Change (
    PriceChangeID DECIMAL (12) NOT NULL PRIMARY KEY,
    TravelCriteriaID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Travel_Criteria (TravelCriteriaID),
    OldPrice DECIMAL (6, 2) NOT NULL,
    NewPrice DECIMAL (6, 2) NOT NULL,
    ChangeDate DATE NOT NULL,
);


--SEQUENCES
CREATE SEQUENCE titleID START WITH 1;
CREATE SEQUENCE user_information_seq START WITH 1;
CREATE SEQUENCE account_profile_seq START WITH 1;
CREATE SEQUENCE approver_profile_seq START WITH 1;
CREATE SEQUENCE user_profile_seq START WITH 1;
CREATE SEQUENCE pricing_data_seq START WITH 1;
CREATE SEQUENCE membership_program_seq START WITH 1;
CREATE SEQUENCE gold_membership_seq START WITH 1;
CREATE SEQUENCE platinum_membership_seq START WITH 1;
CREATE SEQUENCE reserve_membership_seq START WITH 1;
CREATE SEQUENCE payment_information_seq START WITH 1;
CREATE SEQUENCE booking_seq START WITH 1;
CREATE SEQUENCE additional_accommodations_seq START WITH 1;
CREATE SEQUENCE travel_criteria_seq START WITH 1;

--INDEXES
--Three query driven index creations (both unique and non-unique)
CREATE INDEX BookingDateIdx
ON booking(BookingDate);

CREATE INDEX PricingComparisonIdx
ON pricing_data(ComparisonPrice);

CREATE UNIQUE INDEX BookingPassportIdx
ON booking(PassportNumber);

-- Index creation for foreign keys (both unique and non-unique)
CREATE INDEX UserTitleIdx
ON user_information(titleID);

CREATE UNIQUE INDEX AccountUserIdx
ON account_profile(UserInformationID);

CREATE UNIQUE INDEX ApproverAccountIdx
ON approver_profile(AccountProfileID);

CREATE UNIQUE INDEX UserAccountIdx
ON user_profile(AccountProfileID);

CREATE INDEX BookingAccountIdx
ON booking(AccountProfileID);

CREATE INDEX BookingPaymentIdx
ON booking(PaymentInformationID);

CREATE INDEX BookingMembershipIdx
ON booking(MembershipProgramID);

CREATE INDEX BookingPricingIdx
ON booking(PricingDataID);

CREATE UNIQUE INDEX GoldMembershipIdx
ON Gold_membership(MembershipProgramID);

CREATE UNIQUE INDEX PlatinumMembershipIdx
ON platinum_membership(MembershipProgramID);

CREATE UNIQUE INDEX ReserveMembershipIdx
ON reserve_membership(MembershipProgramID);

CREATE INDEX PaymentCardIdx
ON payment_information(CardNumber);

CREATE INDEX AccommodationsBookingIdx
ON Additional_Accommodations(BookingID);

CREATE INDEX CriteriaBookingIdx
ON Travel_Criteria(BookingID);

-- Index creation for primary keys (both unique and non-unqiue)
CREATE UNIQUE INDEX DepartmentTitleIdx
ON department_info(TitleID);

CREATE UNIQUE INDEX UserInformationIdx
ON user_information(UserInformationID)

CREATE UNIQUE INDEX AccountProfileIdx
ON account_profile(AccountProfileID)

CREATE UNIQUE INDEX ApproverProfileIdx
ON approver_profile(AccountProfileID)

CREATE UNIQUE INDEX UserProfileIdx
ON user_profile(AccountProfileID)

CREATE UNIQUE INDEX BookingIdx
ON booking(bookingID)

CREATE UNIQUE INDEX PricingDataIdx
ON pricing_data(PricingDataID)

CREATE UNIQUE INDEX MembershipProgramIdx
ON membership_program(MembershipProgramID)

CREATE UNIQUE INDEX GoldMembershipIdx
ON gold_membership(MembershipProgramID)

CREATE UNIQUE INDEX PlatinumMembershipIdx
ON platinum_membership(MembershipProgramID)

CREATE UNIQUE INDEX ReserveMembershipIdx
ON reserve_membership(MembershipProgramID)

CREATE UNIQUE INDEX PaymentInofmrationIdx
ON payment_information(PaymentInformationID)

CREATE UNIQUE INDEX CardInformation
ON card_information(CardNumber)

CREATE UNIQUE INDEX AdditionalAccommodationsIdx
ON Additional_Accommodations(AdditionalAccommodationsID);

CREATE UNIQUE INDEX TravelCriteriaIdx
ON Travel_Criteria(TravelCriteriaID)

--STORED PROCEDURES
CREATE PROCEDURE AddUserProfile @AccountProfileID DECIMAL(12), @UserInformationID DECIMAL(12),
 @AccountID VARCHAR(255), @Password VARCHAR(128), @ManagerEmployeeID DECIMAL(12)
AS
BEGIN
    INSERT INTO account_profile(AccountProfileID, UserInformationID, AccountID, Password, ManagerEmployeeID)
    Values (@AccountProfileID, @UserInformationID, @AccountID, @Password, @ManagerEmployeeID)

    INSERT INTO user_profile(AccountProfileID)
    VALUES (@AccountProfileID)
END;

CREATE PROCEDURE AddApproverProfile @AccountProfileID DECIMAL(12), @UserInformationID DECIMAL(12), @AccountID VARCHAR(255), 
@Password VARCHAR(128), @ManagerEmployeeID DECIMAL(12), @DirectReportEmployeeID DECIMAL(12)
AS
BEGIN
    INSERT INTO account_profile (AccountProfileID, UserInformationID, AccountID, Password, ManagerEmployeeID)
    Values (@AccountProfileID, @UserInformationID, @AccountID, @Password, @ManagerEmployeeID)

    INSERT INTO approver_profile(AccountProfileID, ManagerEmployeeID, DirectReportEmployeeID)
    VALUES (@AccountProfileID, @DirectReportEmployeeID)
END;

CREATE PROCEDURE AddReserveMembership @MembershipProgramID DECIMAL(12), @MembershipType VARCHAR(20), @StartDate DATE, @Status VARCHAR(20),
@MileagePoints DECIMAL(15), @LastActivityDate DATE
AS 
BEGIN
    INSERT INTO membership_program (MembershipProgramID, MembershipType, StartDate, Status)
    VALUES (@MembershipProgramID, @MembershipType, @StartDate, @Status)

    INSERT INTO reserve_membership (MembershipProgramID, MileagePoints, LastActivityDate)
    VALUES (@MembershipProgramID, @MileagePoints, @LastActivityDate)
END;

--Error checking
IF @Passowrd != VARCHAR(8)
BEGIN 
    ROLLBACK;
    RAISERROR (...);
    END;
END;


--INSERTS
DECLARE @current_booking_seq INT = NEXT VALUE FOR booking_seq;
DECLARE @current_payment_information_seq INT = NEXT VALUE FOR payment_information_seq;
DECLARE @current_membership_program_seq INT = NEXT VALUE FOR membership_program_seq;
DECLARE @current_pricing_data_seq INT = NEXT VALUE FOR pricing_data_seq;
DECLARE @current_account_profile_seq INT = NEXT VALUE FOR account_profile_seq;
DECLARE @current_user_information_seq INT = NEXT VALUE FOR user_information_seq;
DECLARE @current_titleID_seq INT = NEXT VALUE FOR titleID_seq;

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Engineering');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'sun.kim@sql.com', 'sun', 'kim', 14251111111, 'M', CAST('01-JUN-2015' AS DATE), 'Full-Time');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, @current_user_information_seq, 'sun.kim@sql.com', 'passwordexample123', 111);
INSERT INTO approver_profile
VALUES (@current_account_profile_seq, 234);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 150.50, GETDATE(), '121kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Reserve Membership', CAST('01-JUN-2015' AS DATE), 'Active', 15000, CAST('01-JUL-2024' AS DATE));
INSERT INTO reserve_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (1111111111111111, 'Sun', 'Kim', 123, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 1111111111111111);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, @current_account_profile_seq, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Sun', 'Kim', 14251111111, 123456, CAST('01-JUL-1992' AS DATE), 122.00, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 3, 'Y', 'Dinner Set, Alcoholic Drink, Candy bar');
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'Seattle', 'Los Angeles', CAST('01-APR-2025' AS DATE), CAST ('05-APR-2025' AS DATE), 'Alaskan', 2, 108.00);

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Engineering');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'tina.seo@sql.com', 'Tina', 'Seo', 14252222222, 'F', CAST('01-JUN-2012' AS DATE), 'Full-Time');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, @current_user_information_seq, 'tina.seo@sql.com', 'passwordexample123', 109);
INSERT INTO approver_profile
VALUES (@current_account_profile_seq, 456);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 300.74, GETDATE(), '121kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Reserve Membership', CAST('01-JUN-2013' AS DATE), 'Active', 30000, CAST('01-JUL-2024' AS DATE));
INSERT INTO reserve_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (2222222222222222, 'Tina', 'Seo', 234, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 2222222222222222);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, @current_account_profile_seq, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Tina', 'Seo', 14253333333, 234567, CAST('01-DEC-1990' AS DATE), 290.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 3, 'Y', 'Dinner Set, Alcoholic Drink');
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'Seattle', 'Miami', CAST('01-JAN-2025' AS DATE), CAST ('05-JAN-2025' AS DATE), 'Delta', 2, 265.99);

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Engineering');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'jose.garcia@sql.com', 'Jose', 'Garcia', 14253333333, 'M', CAST('01-JUN-2019' AS DATE), 'Full-Time');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, @current_user_information_seq, 'jose.garcia@sql.com', 'passwordexample123', 111);
INSERT INTO user_profile
VALUES (@current_account_profile_seq);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 145.99, GETDATE(), '121kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Gold Membership', CAST('01-JUN-2019' AS DATE), 'Active', 8000, CAST('01-FEB-2024' AS DATE));
INSERT INTO gold_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (3333333333333333, 'Jose', 'Garcia', 345, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 3333333333333333);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, @current_account_profile_seq, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Jose', 'Garcia', 14253333333, 345678, CAST('01-DEC-1996' AS DATE), 140.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 1, 'Y', 'Soda, Chips');
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'Seattle', 'Phoenix', CAST('01-OCT-2025' AS DATE), CAST ('05-OCT-2025' AS DATE), 'Spirit', 1, 120.99);

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Services');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'john.smith@sql.com', 'John', 'Smith', 14254444444, 'M', CAST('01-JUN-2018' AS DATE), 'Part-Time');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, @current_user_information_seq, 'john.smith@sql.com', 'passwordexample123', 105);
INSERT INTO user_profile
VALUES (@current_account_profile_seq);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 145.99, GETDATE(), '121kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Gold Membership', CAST('01-JUN-2018' AS DATE), 'Inactive', 850, CAST('01-JAN-2019' AS DATE));
INSERT INTO gold_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (4444444444444444, 'John', 'Smith', 456, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 4444444444444444);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, @current_account_profile_seq, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'John', 'Smith', 14254444444, 456789, CAST('01-MAR-1980' AS DATE), 148.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 1, 'Y', NULL);
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'Dallas', 'Los Angeles', CAST('01-MAR-2025' AS DATE), CAST ('05-MAR-2025' AS DATE), 'Southwest', 3, 125.78);

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Services');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'kaitlyn.mars@sql.com', 'Kaitlyn', 'Mars', 14255555555, 'F', CAST('01-APR-2021' AS DATE), 'Part-Time');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, @current_user_information_seq, 'kaitlyn.mars@sql.com', 'passwordexample123', 105);
INSERT INTO user_profile
VALUES (@current_account_profile_seq);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 145.99, GETDATE(), '121kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Gold Membership', CAST('01-APR-2021' AS DATE), 'Inactive', 350, CAST('01-JUL-2021' AS DATE));
INSERT INTO gold_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (5555555555555555, 'Kaitlyn', 'Mars', 567, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 5555555555555555);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, @current_account_profile_seq, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Kaitlyn', 'Mars', 14255555555, 456781, CAST('01-MAY-1999' AS DATE), 136.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 3, 'Y', NULL);
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'Los Angeles', 'Hawaii', CAST('01-JAN-2026' AS DATE), CAST ('05-JAN-2026' AS DATE), 'Hawaiian', 2, 115.99);

SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Finance');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'harley.quinn@sql.com', 'Harley', 'Quinn', 14256666666, 'F', CAST('01-OCT-2024' AS DATE), 'Temporary');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, 7, 'harley.quinn@sql.com', 'passwordexample123', 236);
INSERT INTO approver_profile
VALUES (@current_account_profile_seq, NULL);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 499.99, GETDATE(), '169kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Reserve Membership', CAST('01-APR-2019' AS DATE), 'Active', 50000, CAST('01-JUL-2024' AS DATE));
INSERT INTO reserve_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (7777777777777777, 'Harley', 'Quinn', 269, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 7777777777777777);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, 7, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Harley', 'Quinn', 14257777777, 567891, CAST('01-DEC-1984' AS DATE), 515.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 3, 'Y', 'Dinner, Cocktail Drink');
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'New York', 'San Francisco', CAST('01-FEB-2025' AS DATE), CAST ('05-FEB-2025' AS DATE), 'Delta', 2, 500.99);


SET @current_titleID_seq = NEXT VALUE FOR titleID_seq;
INSERT INTO department_info
VALUES (@current_titleID_seq, 'Finance');
SET @current_user_information_seq = NEXT VALUE FOR user_information_seq;
INSERT INTO user_information
VALUES (@current_user_information_seq, @current_titleID_seq, 'bruce.wayne@sql.com', 'Bruce', 'Wayne', 14257777777, 'M', CAST('01-AUG-2024' AS DATE), 'Temporary');
SET @current_account_profile_seq = NEXT VALUE FOR account_profile_seq;
INSERT INTO account_profile 
VALUES (@current_account_profile_seq, 8, 'Bruce.wayne@sql.com', 'passwordexample123', 236);
INSERT INTO approver_profile
VALUES (@current_account_profile_seq, NULL);
SET @current_pricing_data_seq = NEXT VALUE FOR pricing_data_seq;
INSERT INTO pricing_data
VALUES (@current_pricing_data_seq, 499.99, GETDATE(), '169kgCO2e');
SET @current_membership_program_seq = NEXT VALUE FOR membership_program_seq;
INSERT INTO membership_program
VALUES (@current_membership_program_seq, 'Reserve Membership', CAST('01-JUN-2017' AS DATE), 'Active', 50000, CAST('01-MAY-2024' AS DATE));
INSERT INTO reserve_membership
VALUES (@current_membership_program_seq);
INSERT INTO card_information
VALUES (8888888888888888, 'Bruce', 'Wayne', 355, CAST('01-JUN-2027' AS DATE));
SET @current_payment_information_seq = NEXT VALUE FOR payment_information_seq;
INSERT INTO payment_information
VALUES (@current_payment_information_seq, 8888888888888888);
SET @current_booking_seq = NEXT VALUE FOR booking_seq;
INSERT INTO booking
VALUES (@current_booking_seq, 8, @current_payment_information_seq, @current_membership_program_seq, 
@current_pricing_data_seq, 'Bruce', 'Wayne', 14258888888, 678912, CAST('01-DEC-1979' AS DATE), 519.99, GETDATE());
INSERT INTO additional_accommodations
VALUES (NEXT VALUE FOR additional_accommodations_seq, @current_booking_seq, 3, 'Y', 'Dinner, Beer');
INSERT INTO travel_criteria
VALUES (NEXT VALUE FOR travel_criteria_seq, @current_booking_seq, 'New York', 'San Francisco', CAST('01-FEB-2025' AS DATE), CAST ('05-FEB-2025' AS DATE), 'Delta', 2, 500.99);


--QUERIES
-- This query answers this question:
-- Find out the employees who has an upcoming travel booked and the cost of booking was more than the average price from the
--available pricing data. In the table, populate their employee information, cost and average price of the booking, as
--well as the additional accmodations included in their booking.
SELECT user_information.UserInformationID, user_information.FirstName, user_information.LastName, EmployeeEmail, SeatPreference, CheckInBaggage,
FoodandBeverage, Cost, ComparisonPrice
FROM user_information
JOIN account_profile ON user_information.userinformationID = account_profile.UserInformationID
JOIN booking ON account_profile.accountprofileID = booking.accountprofileID 
JOIN additional_accommodations ON booking.bookingID = additional_accommodations.BookingID
JOIN pricing_data ON booking.PricingDataID = pricing_data.PricingDataID 
WHERE (booking.cost) > pricing_data.ComparisonPrice;

--This query answers this question:
--Determine the employees, along with their bookingID and AccountProfileID, who has an upcoming travel booked and is also in an approver role
SELECT BookingID, approver_profile.AccountProfileID, user_information.FirstName, user_information.LastName 
FROM booking 
JOIN account_profile ON booking.AccountProfileID = account_profileID
JOIN user_information ON account_profile.userinformationID = user_information.userinformationID 
JOIN approver_profile ON account_profile.accountprofileID = approver_profile.accountprofileID 

--This query answers this question:
--Create a view that shows the departments that made more than two travel bookings on Dec-03-20
CREATE OR ALTER VIEW daily_booking_flagging AS
SELECT Department 
FROM department_info 
JOIN user_information ON department_info.titleID = user_information.titleID 
JOIN account_profile ON user_information.UserInformationID = account_profile.UserInformationID 
JOIN booking ON account_profile.AccountProfileID = booking.AccountProfileID
WHERE BookingDate = CAST('03-DEC-2024' AS DATE)
GROUP BY department_info.Department 
HAVING COUNT(booking.bookingID) >= 2;

--TRIGGERS
CREATE TRIGGER PriceChangeTrigger
ON Travel_Criteria
AFTER UPDATE 
AS
BEGIN
    DECLARE @OldPrice DECIMAL(6, 2) = (SELECT Price FROM DELETED);
    DECLARE @NewPrice DECIMAL(6, 2) = (SELECT Price FROM INSERTED);
    IF (@OldPrice <> @NewPrice)
        INSERT INTO Price_Change(PriceChangeID, TravelCriteriaID, OldPrice, NewPrice, ChangeDate)
        VALUES(NEXT VALUE FOR Price_Change_Seq, (SELECT TravelCriteriaID FROM INSERTED), @OldPrice, @NewPrice, GETDATE());
END;


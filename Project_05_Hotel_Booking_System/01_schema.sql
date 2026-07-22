-- Project 5: Hotel Booking System
-- 01_schema.sql
-- Source: Kaggle - Hotel Booking Demand
-- (jessemostipak/hotel-booking-demand)

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS hotels;

-- 1. Hotels Table
-- The source data only distinguishes two hotels ("City Hotel" and
-- "Resort Hotel"), so this is a small lookup table rather than a
-- fully separate operational entity.
CREATE TABLE hotels (
    hotel_id    SERIAL PRIMARY KEY,
    hotel_name  VARCHAR(20) NOT NULL UNIQUE CHECK (hotel_name IN ('City Hotel', 'Resort Hotel'))
);

-- 2. Bookings Table
-- The original CSV is a single flat file with no booking or guest ID.
-- booking_id below is a surrogate key generated for this project.
CREATE TABLE bookings (
    booking_id                      SERIAL PRIMARY KEY,
    hotel_id                        INT NOT NULL REFERENCES hotels(hotel_id),
    is_canceled                     BOOLEAN NOT NULL,
    lead_time                       INT NOT NULL CHECK (lead_time >= 0),
    arrival_date                    DATE NOT NULL,          -- combined from year/month/day in the source file
    arrival_date_week_number        INT NOT NULL,
    stays_in_weekend_nights         INT NOT NULL CHECK (stays_in_weekend_nights >= 0),
    stays_in_week_nights            INT NOT NULL CHECK (stays_in_week_nights >= 0),
    adults                          INT NOT NULL CHECK (adults >= 0),
    children                        INT CHECK (children >= 0),      -- NULL for the handful of rows missing this in source
    babies                          INT NOT NULL CHECK (babies >= 0),
    meal                            VARCHAR(15) NOT NULL,
    country                         VARCHAR(10),                    -- NULL where guest's country wasn't recorded
    market_segment                  VARCHAR(20) NOT NULL,
    distribution_channel            VARCHAR(15) NOT NULL,
    is_repeated_guest                BOOLEAN NOT NULL,
    previous_cancellations          INT NOT NULL CHECK (previous_cancellations >= 0),
    previous_bookings_not_canceled  INT NOT NULL CHECK (previous_bookings_not_canceled >= 0),
    reserved_room_type              VARCHAR(5) NOT NULL,
    assigned_room_type              VARCHAR(5) NOT NULL,
    booking_changes                 INT NOT NULL CHECK (booking_changes >= 0),
    deposit_type                    VARCHAR(15) NOT NULL CHECK (deposit_type IN ('No Deposit', 'Refundable', 'Non Refund')),
    agent                           INT,                            -- NULL where booking wasn't made through an agent
    company                         INT,                            -- NULL where booking wasn't made through a company
    days_in_waiting_list            INT NOT NULL CHECK (days_in_waiting_list >= 0),
    customer_type                   VARCHAR(20) NOT NULL,
    adr                             DECIMAL(8,2) NOT NULL,          -- average daily rate
    required_car_parking_spaces     INT NOT NULL CHECK (required_car_parking_spaces >= 0),
    total_of_special_requests       INT NOT NULL CHECK (total_of_special_requests >= 0),
    reservation_status              VARCHAR(15) NOT NULL CHECK (reservation_status IN ('Check-Out', 'Canceled', 'No-Show')),
    reservation_status_date         DATE NOT NULL
);

-- Performance indexes for common analytical queries
CREATE INDEX idx_bookings_hotel            ON bookings(hotel_id);
CREATE INDEX idx_bookings_arrival_date     ON bookings(arrival_date);
CREATE INDEX idx_bookings_is_canceled      ON bookings(is_canceled);
CREATE INDEX idx_bookings_country          ON bookings(country);
CREATE INDEX idx_bookings_market_segment   ON bookings(market_segment);
CREATE INDEX idx_bookings_reservation_status ON bookings(reservation_status);
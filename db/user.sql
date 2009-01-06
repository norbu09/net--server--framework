CREATE TABLE users (
    username varchar(255) PRIMARY KEY,
    password varchar(255) NOT NULL,
    created integer,
    active boolean default TRUE
);

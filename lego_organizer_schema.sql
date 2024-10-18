-- Create the LEGO Organizer Database
CREATE DATABASE lego_organizer
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE lego_organizer;

-- Table for storing collector details
CREATE TABLE Collectors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL, -- This will store hashed password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing LEGO set information
CREATE TABLE LEGO_Sets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    theme VARCHAR(100),             -- Theme like 'Star Wars', 'Technic', etc.
    piece_count INT,
    release_year YEAR,
    description TEXT,
    image_url VARCHAR(255),         -- Primary image URL for the set
    lego_url VARCHAR(255),          -- Link to the official LEGO page
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for additional set images (each set can have multiple images)
CREATE TABLE Set_Images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lego_set_id INT,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (lego_set_id) REFERENCES LEGO_Sets(id) ON DELETE CASCADE
);

-- Table for LEGO set categories (e.g., themes, subcategories)
CREATE TABLE Set_Categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

-- Relationship table between LEGO sets and categories (many-to-many relationship)
CREATE TABLE LEGO_Set_Category_Relation (
    lego_set_id INT,
    category_id INT,
    PRIMARY KEY (lego_set_id, category_id),
    FOREIGN KEY (lego_set_id) REFERENCES LEGO_Sets(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Set_Categories(id) ON DELETE CASCADE
);

-- Table for storing admirer (end-user) details
CREATE TABLE Admirers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Revised Table for tracking queries made by public users about a LEGO set
CREATE TABLE Queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admirer_id INT,                 -- Link to the admirer (public user)
    query_message TEXT NOT NULL,
    lego_set_id INT,                -- The LEGO set the query is related to
    status ENUM('open', 'closed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admirer_id) REFERENCES Admirers(id) ON DELETE CASCADE,
    FOREIGN KEY (lego_set_id) REFERENCES LEGO_Sets(id) ON DELETE SET NULL
);

-- Table for storing admin details (managers of collectors)
CREATE TABLE Admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL, -- This will store hashed password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relationship table between Admins and Collectors (many-to-many relationship)
CREATE TABLE Admin_Collector_Relation (
    admin_id INT,
    collector_id INT,
    PRIMARY KEY (admin_id, collector_id),
    FOREIGN KEY (admin_id) REFERENCES Admins(id) ON DELETE CASCADE,
    FOREIGN KEY (collector_id) REFERENCES Collectors(id) ON DELETE CASCADE
);

-- Table for mapping collectors to LEGO sets (who created/updated the set)
CREATE TABLE Set_Collector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lego_set_id INT,
    collector_id INT,
    action ENUM('added', 'modified') NOT NULL,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lego_set_id) REFERENCES LEGO_Sets(id) ON DELETE CASCADE,
    FOREIGN KEY (collector_id) REFERENCES Collectors(id) ON DELETE CASCADE
);

-- Optional Table for sales information (if a set is up for sale)
CREATE TABLE Sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lego_set_id INT,
    collector_id INT,
    sale_price DECIMAL(10, 2),
    sale_status ENUM('available', 'sold') DEFAULT 'available',
    FOREIGN KEY (lego_set_id) REFERENCES LEGO_Sets(id) ON DELETE CASCADE,
    FOREIGN KEY (collector_id) REFERENCES Collectors(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional Table for storing email notifications sent to collectors
CREATE TABLE Notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    collector_id INT,
    action_type VARCHAR(100) NOT NULL, -- E.g., 'set_added', 'collector_added'
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collector_id) REFERENCES Collectors(id) ON DELETE CASCADE
);
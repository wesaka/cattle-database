-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 27, 2021 at 01:36 AM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id16605669_cattle`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`id16605669_admin`@`%` FUNCTION `auth` (`uname` VARCHAR(25), `pword` VARCHAR(25)) RETURNS INT(25) BEGIN
        DECLARE userExists TINYINT(1) DEFAULT 0;
        DECLARE passwordCheck TINYINT(1) DEFAULT 0;
        DECLARE userId INT(25) DEFAULT 0;
        # Check if user exists
        SELECT COUNT(username) INTO userExists FROM owners WHERE username = uname;

        # If not, create
        IF userExists = 0 THEN
            INSERT INTO owners(username, password) VALUES (uname, pword);
            RETURN 1;
        ELSE
            #However, if it exists, check if the password is equal, if so, return true, if not, return false
            SELECT password = pword INTO passwordCheck FROM owners WHERE username = uname;
            IF passwordCheck = 1 THEN
                SELECT UID INTO userId FROM owners WHERE username = uname;
                RETURN userId;
            ELSE
                RETURN 0;
            END IF;
        END IF;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cattle`
--

CREATE TABLE `cattle` (
  `UID` int(11) NOT NULL,
  `date_born` date NOT NULL,
  `weight_birth` decimal(10,3) DEFAULT NULL,
  `parent_1` int(11) DEFAULT NULL,
  `parent_2` int(11) DEFAULT NULL,
  `breed` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `purebred` tinyint(4) DEFAULT 0,
  `date_bought` date DEFAULT NULL,
  `weight_received` date DEFAULT NULL,
  `price_bought` decimal(10,2) DEFAULT NULL,
  `last_weight` decimal(10,3) DEFAULT NULL,
  `date_last_weight` date DEFAULT NULL,
  `tag` int(11) NOT NULL,
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `owners`
--

CREATE TABLE `owners` (
  `UID` int(11) NOT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ranches`
--

CREATE TABLE `ranches` (
  `UID` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `ranch_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `local_registration` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tax_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `street_number` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `additional_information` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sold`
--

CREATE TABLE `sold` (
  `transaction_id` int(11) NOT NULL,
  `cattle_uid` int(11) DEFAULT NULL,
  `seller_uid` int(11) DEFAULT NULL,
  `buyer_uid` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `sold`
--
DELIMITER $$
CREATE TRIGGER `update_owner` AFTER INSERT ON `sold` FOR EACH ROW BEGIN
    UPDATE cattle SET owner = NEW.buyer_uid WHERE uid = NEW.cattle_uid;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cattle`
--
ALTER TABLE `cattle`
  ADD PRIMARY KEY (`UID`),
  ADD KEY `owner` (`owner`);

--
-- Indexes for table `owners`
--
ALTER TABLE `owners`
  ADD PRIMARY KEY (`UID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `ranches`
--
ALTER TABLE `ranches`
  ADD PRIMARY KEY (`UID`),
  ADD KEY `owner` (`owner`);

--
-- Indexes for table `sold`
--
ALTER TABLE `sold`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `cattle_uid` (`cattle_uid`),
  ADD KEY `seller_uid` (`seller_uid`),
  ADD KEY `buyer_uid` (`buyer_uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cattle`
--
ALTER TABLE `cattle`
  MODIFY `UID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `owners`
--
ALTER TABLE `owners`
  MODIFY `UID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ranches`
--
ALTER TABLE `ranches`
  MODIFY `UID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sold`
--
ALTER TABLE `sold`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cattle`
--
ALTER TABLE `cattle`
  ADD CONSTRAINT `cattle_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `owners` (`UID`);

--
-- Constraints for table `ranches`
--
ALTER TABLE `ranches`
  ADD CONSTRAINT `ranches_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `owners` (`UID`);

--
-- Constraints for table `sold`
--
ALTER TABLE `sold`
  ADD CONSTRAINT `sold_ibfk_1` FOREIGN KEY (`cattle_uid`) REFERENCES `cattle` (`UID`),
  ADD CONSTRAINT `sold_ibfk_2` FOREIGN KEY (`seller_uid`) REFERENCES `owners` (`UID`),
  ADD CONSTRAINT `sold_ibfk_3` FOREIGN KEY (`buyer_uid`) REFERENCES `owners` (`UID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

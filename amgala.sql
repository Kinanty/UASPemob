-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 18, 2025 at 03:12 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `amgala`
--

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `time` varchar(50) NOT NULL,
  `location` varchar(255) NOT NULL,
  `type` enum('workshop','webinar','volunteer') NOT NULL,
  `image` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `title`, `description`, `date`, `time`, `location`, `type`, `image`, `created_at`, `updated_at`) VALUES
(1, 'React Workshop', 'Learn React from scratch in this beginner-friendly workshop.', '2025-01-10', '08:00:00', 'Online', 'workshop', 'https://goodworks.in/wp-content/uploads/2018/09/React-Js-workshop-1024x536.png', '2025-01-05 22:10:26', '2025-01-05 22:10:26'),
(2, 'Webinar on AI', 'A webinar discussing the latest trends in artificial intelligence.', '2025-01-15', '14:00:00', 'Online', 'webinar', 'https://filkom.ub.ac.id/wp-content/uploads/2023/07/Poster-Webinar-Series-3-1-724x1024.png', '2025-01-05 22:10:26', '2025-01-05 22:10:26'),
(3, 'Beach Cleanup Volunteer', 'Join us to clean the beach and make a difference.', '2025-01-20', '09:00:00', 'Kuta Beach, Bali', 'volunteer', 'https://www.signupgenius.com/cms/socialMediaImages/beach-clean-up-tips-ideas-facebook-1200x630.png', '2025-01-05 22:10:26', '2025-01-05 22:10:26'),
(4, 'Membuat Pohon Impian Bersama Adik-Adik Panti', 'lorempisuvnjsih sufbwuygdfhwc jwyfvguwybdiuc sugfiubdjs audiubdhjwbd sjfuwygefeuwqgfqu', '2025-01-18', '08:00 - 12:00 ', 'Dompet Dhuafa Depok', 'volunteer', 'https://rencanamu.id/assets/file_uploaded/blog/1581606003-images-60.jpeg', '2025-01-08 08:53:26', '2025-01-08 08:53:26');

-- --------------------------------------------------------

--
-- Table structure for table `event_registration`
--

CREATE TABLE `event_registration` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `institution` varchar(255) NOT NULL,
  `whatsapp` varchar(15) NOT NULL,
  `reasons` text NOT NULL,
  `proof_file` varchar(255) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `registration_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) DEFAULT NULL,
  `approval` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_registration`
--

INSERT INTO `event_registration` (`id`, `full_name`, `date_of_birth`, `institution`, `whatsapp`, `reasons`, `proof_file`, `event_id`, `registration_date`, `user_id`, `approval`, `notes`) VALUES
(2, 'asdasdasd', '2025-01-06', 'asdasdasdasd', 'asdasdasdasd', 'asdasdasdasd', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRx22jmDQr28j2EZWzx1BLzXNVeWfVFrBzdQ&s', 3, '2025-01-06 11:00:01', 2, 2, 'https://zoom.us/signin'),
(3, 'Nana Gajah', '2025-01-06', 'University of Indonesia', '0893432423', 'no reason', 'https://img.com', 3, '2025-01-06 14:27:56', 5, 1, 'https://zoom.us/signin'),
(4, 'budi', '2025-01-01', 'indo', '084246553431', 'gapapa', 'https://dhsjjakajs', 3, '2025-01-07 13:44:08', 6, 1, 'https://zoom.us/signin'),
(5, 'budi', '2025-01-01', 'indo', '08523945269', 'gpp', 'http://grjhchsy', 1, '2025-01-07 13:45:44', 6, 2, NULL),
(6, 'joko', '2001-01-29', 'esq', '08754139558', 'mau aja', 'https://foto', 3, '2025-01-08 08:58:40', 7, 1, NULL),
(7, 'titi', '2025-01-07', 'esq', '08782544862', 'mau ajaaa', 'https://sfxfvvh', 3, '2025-01-08 09:21:55', 8, 1, NULL),
(8, 'kinkin', '2025-01-06', 'fuh', '087556', 'fhnv', 'https://fgjjgghj', 1, '2025-01-08 09:27:22', 8, 1, NULL),
(9, 'gigi', '2025-01-05', 'esq', '084665565', 'gpp', 'https://fhjkjjgfgh', 2, '2025-01-08 09:30:27', 8, 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `event_id`, `title`, `subtitle`) VALUES
(1, 1, 'Daftarkan diri anda segera', 'Dapatkan sertifikasi handal!');

-- --------------------------------------------------------

--
-- Table structure for table `terms`
--

CREATE TABLE `terms` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `terms` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `terms`
--

INSERT INTO `terms` (`id`, `event_id`, `terms`) VALUES
(1, 1, 'Mengisi formulir pendaftaran.'),
(2, 1, 'Jika sudah diterima tidak dapat dibatalkan.'),
(3, 1, 'Bersedia mengikuti aturan yang berlaku.'),
(4, 1, 'Menjadi inspirasi kebaikan dengan membagikan pengalaman menjadi relawan lewat media sosial yang kamu miliki.'),
(5, 2, 'Mengisi formulir pendaftaran.'),
(6, 2, 'Jika sudah diterima tidak dapat dibatalkan.'),
(7, 2, 'Bersedia mengikuti aturan yang berlaku.'),
(8, 2, 'Menjadi inspirasi kebaikan dengan membagikan pengalaman menjadi relawan lewat media sosial yang kamu miliki.'),
(9, 3, 'Mengisi formulir pendaftaran.'),
(10, 3, 'Jika sudah diterima tidak dapat dibatalkan.'),
(11, 3, 'Bersedia mengikuti aturan yang berlaku.'),
(12, 3, 'Menjadi inspirasi kebaikan dengan membagikan pengalaman menjadi relawan lewat media sosial yang kamu miliki.');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `fullname`, `image`, `created_at`, `updated_at`) VALUES
(3, 'dadang123', 'dadang123@gmail.com', 'dadang123', 'Dadang', NULL, '2025-01-06 12:38:40', '2025-01-06 12:38:40'),
(4, 'nanagajah', 'nanagajah@gmail.com', 'nana123', 'nana gajah', NULL, '2025-01-06 14:24:59', '2025-01-06 14:24:59'),
(5, 'nana gajaah', 'nana@gmail.com', 'nana123', 'nana satu', 'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg', '2025-01-06 14:26:27', '2025-01-06 14:28:47'),
(6, 'budi1', 'budi@gmail.com', 'budi123', 'budi', NULL, '2025-01-07 13:39:19', '2025-01-07 13:39:19'),
(7, 'joko1', 'joko@gmail.com', 'joko123', 'joko', NULL, '2025-01-08 08:56:32', '2025-01-08 08:56:32'),
(8, 'titi1', 'titi@gmail.com', 'titi123', 'titi jooo', '', '2025-01-08 09:20:26', '2025-01-08 09:38:27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `event_registration`
--
ALTER TABLE `event_registration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `terms`
--
ALTER TABLE `terms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `event_registration`
--
ALTER TABLE `event_registration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `terms`
--
ALTER TABLE `terms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

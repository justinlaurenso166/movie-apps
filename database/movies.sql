-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 17, 2022 at 04:54 AM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movies`
--

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `movie_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `movie_id`) VALUES
(17, 'USR-1632022-2', 7),
(19, 'USR-1632022-2', 1),
(20, 'USR-1632022-2', 8),
(21, 'USR-1442022-1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `list_movies`
--

CREATE TABLE `list_movies` (
  `id` int(11) NOT NULL,
  `image` text NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `genre` text NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `list_movies`
--

INSERT INTO `list_movies` (`id`, `image`, `name`, `description`, `genre`, `status`) VALUES
(1, 'image_1650066337710.jpg', 'Morbeus', 'Ahli biokimia Michael Morbius (Jared Leto) mencoba menyembuhkan dirinya sendiri dari penyakit darah langka, namun secara tidak sengaja ia menginfeksi tubuhnya dan berubah jadi mahluk yang menyerupai vampir.', 'Horror, Adventure', 'premiere'),
(2, 'image_1650084888266.jpg', 'FANTASTIC BEASTS: THE SECRETS OF DUMBLEDORE', 'Seri ketiga dari Fantastic Beasts and Where to Find Them kali ini akan mengisahkan petualangan Newt Scamander (Eddie Redmayne) yang mendapat tugas dari Albus Dumbledore (Jude Law) memimpin kelompok penyihir dan seorang muggle dalam misi berbahaya untuk menghentikan penyihir gelap, Gellert Grindelwald.', 'Comedy', 'coming_soon'),
(7, 'image_1650094661190.jpg', 'JUJUTSU KAISEN 0', 'Yuta Okkotsu is a nervous high school student who is suffering from a serious problem—his childhood friend Rika has turned into a curse and won’t leave him alone. Since Rika is no ordinary curse, his plight is noticed by Satoru Gojo, a teacher at Jujutsu High, a school where fledgling exorcists learn how to combat curses. Gojo convinces Yuta to enroll, but can he learn enough in time to confront the curse that haunts him', 'Horror, Thriller', 'premiere'),
(8, 'image_1650094922294.jpg', 'SONIC THE HEDGEHOG 2', 'Saat Dr. Robotnik kembali ke bumi dengan sekutu baru, Knuckles. Sonic dan teman barunya Tails akan berjuang melawan mereka.', 'Comedy', 'premiere'),
(9, 'image_1650098986772.jpg', 'CONTRACTOR', 'James Harper (Pine), yang secara tidak sengaja diberhentikan dari U.S. Army Special Forces, bergabung dengan organisasi kontraktor swasta\r\nbersama sahabatnya (Foster), demi menafkahi keluarganya. Mereka berdua berada di bawah komando sesama veteran (Sutherland).\r\nMenjalani misi rahasia di luar negaranya, Harper harus menghindari orang-orang yang mencoba membunuhnya saat kembali menuju ke rumah.', 'Action', 'coming_soon'),
(10, 'image_1650099053901.jpg', 'THE LOST CITY', 'Loretta Sage (Sandra Bullock) adalah seorang novelis romantis yang senang menyendiri. Kehidupannya tiba-tiba berubah saat ia dan Alan (Channing Tatum) model tampan yang menjadi cover novel terbarunya diculik oleh Fairfax (Daniel Radcliffe) seorang miliuner yang berambisi menemukan harta karun di kota yang hilang.', 'Action, Adventure', 'coming_soon');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `rating` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `user_id`, `movie_id`, `rating`) VALUES
(9, 'USR-1632022-2', 7, 4.5),
(17, 'USR-1632022-2', 1, 4.5),
(18, 'USR-1632022-2', 8, 4.4),
(19, 'USR-1442022-1', 1, 3.4),
(20, 'USR-1442022-1', 8, 5);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(20) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `autorithy` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `username`, `password`, `autorithy`) VALUES
('USR-1442022-1', 'Justin Laurenso', 'admin', 'admin', 1),
('USR-1632022-2', 'user', 'user', 'user', 2),
('USR-1632022-3', 'justin', 'justin', 'justin', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `list_movies`
--
ALTER TABLE `list_movies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ratings_ibfk_2` (`user_id`),
  ADD KEY `ratings_ibfk_1` (`movie_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `list_movies`
--
ALTER TABLE `list_movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `list_movies` (`id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `list_movies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

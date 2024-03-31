-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.4.33-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- diary 데이터베이스 구조 내보내기
DROP DATABASE IF EXISTS `diary`;
CREATE DATABASE IF NOT EXISTS `diary` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `diary`;

-- 테이블 diary.diary 구조 내보내기
CREATE TABLE IF NOT EXISTS `diary` (
  `diary_date` date NOT NULL,
  `feeling` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `title` text NOT NULL,
  `weather` enum('맑음','흐림','비','눈') NOT NULL,
  `content` text NOT NULL,
  `update_date` datetime NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`diary_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.diary:~31 rows (대략적) 내보내기
DELETE FROM `diary`;
INSERT INTO `diary` (`diary_date`, `feeling`, `title`, `weather`, `content`, `update_date`, `create_date`) VALUES
	('2023-05-03', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:50'),
	('2023-05-10', '&#128512;', '34', '맑음', 'sdjflkajsdfkljdsklfjlksdjfalksdjflksdfj', '2024-03-26 16:39:07', '2024-03-26 16:39:07'),
	('2023-06-07', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 09:01:48'),
	('2023-06-28', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:43'),
	('2023-09-06', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:36'),
	('2023-11-01', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:30'),
	('2024-01-19', '&#128512;', 'nononame', '비', 'null', '2024-03-26 14:53:06', '2024-03-26 14:53:06'),
	('2024-01-31', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 12:34:51'),
	('2024-02-02', '&#128512;', 'name', '눈', '', '2024-03-26 14:52:49', '2024-03-26 14:52:49'),
	('2024-02-14', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:35:40'),
	('2024-02-19', '&#128512;', 'noname', '눈', 'noname23', '2024-03-26 14:52:37', '2024-03-26 14:52:37'),
	('2024-02-27', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:35:44'),
	('2024-03-01', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 13:43:20'),
	('2024-03-04', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:30:00'),
	('2024-03-05', '&#128512;', 'title', '맑음', 'name', '2024-03-26 14:09:14', '2024-03-26 14:09:14'),
	('2024-03-06', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 21:03:18'),
	('2024-03-10', '&#128512;', 'title2', '맑음', 'noname', '2024-03-26 14:52:19', '2024-03-26 14:52:19'),
	('2024-03-13', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:09'),
	('2024-03-19', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 14:47:22'),
	('2024-03-21', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 13:49:32'),
	('2024-03-29', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:35:03'),
	('2024-04-01', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 13:52:32'),
	('2024-04-06', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:35:53'),
	('2024-04-24', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:24'),
	('2024-04-30', '&#128512;', '23', '비', 'no               name                 title\r\nalsdfjalskdjflaksdjflsdjflakdjsfl', '2024-03-26 16:38:47', '2024-03-26 16:38:47'),
	('2024-05-15', '&#128512;', 'title', '맑음', 'dfd', '2024-03-26 14:21:38', '2024-03-26 14:21:38'),
	('2024-08-07', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-24 22:36:57'),
	('2024-08-15', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 08:58:09'),
	('2024-10-09', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 13:34:18'),
	('2024-10-10', '&#128512;', 'chagner', '흐림', 'update', '2024-03-25 15:11:36', '2024-03-25 13:30:00'),
	('2025-07-09', '&#128512;', 'ti3333tle', '눈', 'asdfas', '2024-03-26 14:22:08', '2024-03-26 14:22:08');

-- 테이블 diary.login 구조 내보내기
CREATE TABLE IF NOT EXISTS `login` (
  `my_session` enum('ON','OFF') NOT NULL,
  `on_date` datetime DEFAULT NULL,
  `off_date` datetime DEFAULT NULL,
  PRIMARY KEY (`my_session`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.login:~1 rows (대략적) 내보내기
DELETE FROM `login`;
INSERT INTO `login` (`my_session`, `on_date`, `off_date`) VALUES
	('ON', '2024-03-26 13:37:01', '2024-03-24 23:51:51');

-- 테이블 diary.lunch 구조 내보내기
CREATE TABLE IF NOT EXISTS `lunch` (
  `lunch_date` date NOT NULL,
  `menu` varchar(50) NOT NULL,
  `update_date` datetime NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`lunch_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.lunch:~0 rows (대략적) 내보내기
DELETE FROM `lunch`;

-- 테이블 diary.member 구조 내보내기
CREATE TABLE IF NOT EXISTS `member` (
  `member_id` varchar(50) NOT NULL,
  `member_pw` varchar(50) NOT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.member:~0 rows (대략적) 내보내기
DELETE FROM `member`;
INSERT INTO `member` (`member_id`, `member_pw`) VALUES
	('admin', '1234');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

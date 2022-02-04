/*
SQLyog Enterprise v10.42 
MySQL - 5.5.5-10.1.31-MariaDB : Database - ocr
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ocr` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ocr`;

/*Table structure for table `tb_jenis_karakter` */

DROP TABLE IF EXISTS `tb_jenis_karakter`;

CREATE TABLE `tb_jenis_karakter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=latin1;

/*Data for the table `tb_jenis_karakter` */

insert  into `tb_jenis_karakter`(`id`,`nama`) values (1,'a'),(2,'na'),(3,'ca'),(4,'ra'),(5,'ka'),(6,'da'),(7,'ta'),(8,'sa'),(9,'wa'),(10,'la'),(11,'ma'),(12,'ga'),(13,'ba'),(14,'nga'),(15,'pa'),(16,'ja'),(17,'ya'),(18,'nya'),(19,'na gantungan'),(20,'ca gantungan'),(21,'ra gantungan'),(22,'ka gantungan'),(23,'da gantungan'),(24,'ta gantungan'),(25,'sa gantungan'),(26,'wa gantungan'),(27,'la gantungan'),(28,'ma gantungan'),(29,'ga gantungan'),(30,'ba gantungan'),(31,'nga gantungan'),(32,'pa gantungan'),(33,'ja gantungan'),(34,'ya gantungan'),(35,'nya gantungan'),(36,'a gantungan'),(37,'ulu'),(38,'suku'),(39,'taleng'),(40,'pepet'),(41,'tedong'),(42,'adeg adeg'),(43,'cecek'),(44,'surang'),(45,'bisah'),(46,'le lenga'),(47,'na rambat'),(48,'da damadu'),(49,'ta talatik'),(50,'ta tatawa'),(51,'sa sasaga'),(52,'sa sasapa'),(53,'ba bakembang'),(54,'pa pakapal'),(55,'re repa'),(56,'a kara'),(57,'i kara'),(58,'u kara'),(59,'e kara'),(60,'o kara'),(61,'aa kara'),(62,'le e lenga'),(63,'a tedong'),(64,'na tedong'),(65,'na tedong rambat'),(66,'ca tedong'),(67,'ra tedong'),(68,'ka tedong'),(69,'da tedong'),(70,'da tedong damadu'),(71,'ta tedong'),(72,'ta tedong talatik'),(73,'ta tedong tatawa'),(74,'sa tedong'),(75,'sa tedong sasaga'),(76,'sa tedong sasapa'),(77,'wa tedong'),(78,'la tedong'),(79,'ma tedong'),(80,'ga tedong'),(81,'ba tedong bakembang'),(82,'pa tedong'),(83,'ya a'),(84,'re repa gantungan'),(85,'da damadu gantungan'),(86,'suku gantungan'),(87,'koma'),(88,'suku ilut'),(89,'titik');

/*Table structure for table `tb_karakter` */

DROP TABLE IF EXISTS `tb_karakter`;

CREATE TABLE `tb_karakter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(5) DEFAULT NULL,
  `gambar_aksara` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

/*Data for the table `tb_karakter` */

insert  into `tb_karakter`(`id`,`nama`,`gambar_aksara`) values (1,'le','per_karakter\\karakter_1.jpg'),(2,'ga','per_karakter\\karakter_2.jpg'),(3,',','per_karakter\\karakter_3.jpg'),(4,'le','per_karakter\\karakter_4.jpg'),(5,'ga','per_karakter\\karakter_5.jpg'),(6,',','per_karakter\\karakter_6.jpg'),(7,'ma','per_karakter\\karakter_7.jpg'),(8,'a','per_karakter\\karakter_8.jpg'),(9,'i','per_karakter\\karakter_9.jpg'),(10,'ra','per_karakter\\karakter_10.jpg'),(11,'ma','per_karakter\\karakter_11.jpg'),(12,'pa','per_karakter\\karakter_12.jpg'),(13,'u','per_karakter\\karakter_13.jpg'),(14,'wa','per_karakter\\karakter_14.jpg'),(15,'ta','per_karakter\\karakter_15.jpg'),(16,',','per_karakter\\karakter_16.jpg'),(17,'ka','per_karakter\\karakter_99.jpg'),(18,'e','per_karakter\\karakter_18.jpg'),(19,'wa','per_karakter\\karakter_19.jpg'),(20,'wa','per_karakter\\karakter_20.jpg'),(21,'sa','per_karakter\\karakter_21.jpg'),(22,'ga','per_karakter\\karakter_22.jpg'),(23,'adeg','per_karakter\\karakter_23.jpg'),(24,'ra','per_karakter\\karakter_24.jpg'),(25,'i','per_karakter\\karakter_25.jpg'),(26,'ka','per_karakter\\karakter_100.jpg'),(27,'r','per_karakter\\karakter_27.jpg'),(28,'wa','per_karakter\\karakter_28.jpg'),(29,'i','per_karakter\\karakter_29.jpg'),(30,'ya','per_karakter\\karakter_30.jpg'),(31,',','per_karakter\\karakter_31.jpg');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

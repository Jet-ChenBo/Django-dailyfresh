-- MySQL dump 10.13  Distrib 5.7.26, for Linux (x86_64)
--
-- Host: localhost    Database: dailyfresh
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.18.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group__permission_id_2d213a19b015dcc0_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_group__permission_id_2d213a19b015dcc0_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permission_group_id_537941cbf825e9a0_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  CONSTRAINT `auth__content_type_id_434cc53af3b26b5a_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add permission',2,'add_permission'),(5,'Can change permission',2,'change_permission'),(6,'Can delete permission',2,'delete_permission'),(7,'Can add group',3,'add_group'),(8,'Can change group',3,'change_group'),(9,'Can delete group',3,'delete_group'),(10,'Can add content type',4,'add_contenttype'),(11,'Can change content type',4,'change_contenttype'),(12,'Can delete content type',4,'delete_contenttype'),(13,'Can add session',5,'add_session'),(14,'Can change session',5,'change_session'),(15,'Can delete session',5,'delete_session'),(16,'Can add 用户',6,'add_user'),(17,'Can change 用户',6,'change_user'),(18,'Can delete 用户',6,'delete_user'),(19,'Can add 地址',7,'add_address'),(20,'Can change 地址',7,'change_address'),(21,'Can delete 地址',7,'delete_address'),(22,'Can add 商品种类',8,'add_goodstype'),(23,'Can change 商品种类',8,'change_goodstype'),(24,'Can delete 商品种类',8,'delete_goodstype'),(25,'Can add 商品',9,'add_goodssku'),(26,'Can change 商品',9,'change_goodssku'),(27,'Can delete 商品',9,'delete_goodssku'),(28,'Can add 商品SPU',10,'add_goods'),(29,'Can change 商品SPU',10,'change_goods'),(30,'Can delete 商品SPU',10,'delete_goods'),(31,'Can add 商品图片',11,'add_goodsimage'),(32,'Can change 商品图片',11,'change_goodsimage'),(33,'Can delete 商品图片',11,'delete_goodsimage'),(34,'Can add 首页轮播商品',12,'add_indexgoodsbanner'),(35,'Can change 首页轮播商品',12,'change_indexgoodsbanner'),(36,'Can delete 首页轮播商品',12,'delete_indexgoodsbanner'),(37,'Can add 主页分类展示商品',13,'add_indextypegoodsbanner'),(38,'Can change 主页分类展示商品',13,'change_indextypegoodsbanner'),(39,'Can delete 主页分类展示商品',13,'delete_indextypegoodsbanner'),(40,'Can add 主页促销活动',14,'add_indexpromotionbanner'),(41,'Can change 主页促销活动',14,'change_indexpromotionbanner'),(42,'Can delete 主页促销活动',14,'delete_indexpromotionbanner'),(43,'Can add 订单',15,'add_orderinfo'),(44,'Can change 订单',15,'change_orderinfo'),(45,'Can delete 订单',15,'delete_orderinfo'),(46,'Can add 订单商品',16,'add_ordergoods'),(47,'Can change 订单商品',16,'change_ordergoods'),(48,'Can delete 订单商品',16,'delete_ordergoods');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_address`
--

DROP TABLE IF EXISTS `df_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `receiver` varchar(20) NOT NULL,
  `addr` varchar(256) NOT NULL,
  `zip_code` varchar(6) DEFAULT NULL,
  `phone` varchar(11) NOT NULL,
  `is_default` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_address_user_id_56391e0aae613279_fk_df_user_id` (`user_id`),
  CONSTRAINT `df_address_user_id_56391e0aae613279_fk_df_user_id` FOREIGN KEY (`user_id`) REFERENCES `df_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_address`
--

LOCK TABLES `df_address` WRITE;
/*!40000 ALTER TABLE `df_address` DISABLE KEYS */;
INSERT INTO `df_address` VALUES (1,'2019-06-11 13:33:01.745509','2019-06-11 13:33:01.745734',0,'陈波','四川省成都市','621001','15281678200',1,1),(2,'2019-06-14 13:52:16.294399','2019-06-14 13:52:16.294437',0,'文莉','四川省成都市','621001','15281678200',1,4),(3,'2019-06-20 09:05:39.461257','2019-06-20 09:05:39.461329',0,'文莉','四川省 成都市 金牛区','12345','18980425481',0,1),(4,'2019-06-21 07:46:02.353353','2019-06-21 07:46:02.353433',0,'陈波','四川省 绵阳市 嘻嘻','111111','15281678200',0,4);
/*!40000 ALTER TABLE `df_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_goods`
--

DROP TABLE IF EXISTS `df_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `name` varchar(20) NOT NULL,
  `detail` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_goods`
--

LOCK TABLES `df_goods` WRITE;
/*!40000 ALTER TABLE `df_goods` DISABLE KEYS */;
INSERT INTO `df_goods` VALUES (1,'2019-06-14 14:05:14.413973','2019-06-17 07:13:35.999633',0,'草莓','<p>红红的草莓，你肯定喜欢</p>'),(2,'2019-06-17 07:14:08.176662','2019-06-17 07:14:08.176710',0,'葡萄','<p>大大的葡萄，来一串？</p>'),(3,'2019-06-17 07:14:57.044970','2019-06-17 07:14:57.045021',0,'猪肉','<p>新鲜的猪肉</p>'),(4,'2019-06-17 07:20:52.038556','2019-06-17 07:20:52.038591',0,'轮播展示',''),(5,'2019-06-17 07:26:05.498193','2019-06-17 07:26:05.498227',0,'小龙虾',''),(6,'2019-06-21 07:33:36.819429','2019-06-21 07:33:36.819509',0,'柠檬','<p>好吃的柠檬</p>'),(7,'2019-06-24 13:03:47.716649','2019-06-24 13:03:47.716683',0,'苹果','<p>天空一号苹果</p>'),(8,'2019-06-25 00:45:49.272192','2019-06-25 00:45:49.272270',0,'鱼','<p>北海道的鱼</p>');
/*!40000 ALTER TABLE `df_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_goods_image`
--

DROP TABLE IF EXISTS `df_goods_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_goods_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `image` varchar(100) NOT NULL,
  `sku_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_goods_image_22ad5bca` (`sku_id`),
  CONSTRAINT `df_goods_image_sku_id_2b03f7d614419076_fk_df_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `df_goods_sku` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_goods_image`
--

LOCK TABLES `df_goods_image` WRITE;
/*!40000 ALTER TABLE `df_goods_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `df_goods_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_goods_sku`
--

DROP TABLE IF EXISTS `df_goods_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_goods_sku` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `name` varchar(20) NOT NULL,
  `desc` varchar(256) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `unite` varchar(20) NOT NULL,
  `image` varchar(100) NOT NULL,
  `stock` int(11) NOT NULL,
  `sales` int(11) NOT NULL,
  `status` smallint(6) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_goods_sku_goods_id_3266be29af735569_fk_df_goods_id` (`goods_id`),
  KEY `df_goods_sku_94757cae` (`type_id`),
  CONSTRAINT `df_goods_sku_goods_id_3266be29af735569_fk_df_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `df_goods` (`id`),
  CONSTRAINT `df_goods_sku_type_id_1fa8d7351b4a2f2a_fk_df_goods_type_id` FOREIGN KEY (`type_id`) REFERENCES `df_goods_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_goods_sku`
--

LOCK TABLES `df_goods_sku` WRITE;
/*!40000 ALTER TABLE `df_goods_sku` DISABLE KEYS */;
INSERT INTO `df_goods_sku` VALUES (1,'2019-06-14 14:06:53.850121','2019-06-20 15:57:45.489334',0,'葡萄','大颗葡萄',1.23,'kg','group1/M00/00/00/wKj2k10Dqf2AS_UPAAAjjiYTEkw9896755',26,7,1,2,4),(2,'2019-06-16 15:00:45.741986','2019-06-20 15:58:11.587622',0,'草莓','红红的草莓',2.30,'kg','group1/M00/00/00/wKj2k10GWZ2AT4lRAAAljHPuXJg1573356',19,18,1,1,4),(7,'2019-06-17 07:35:48.437011','2019-06-20 14:42:08.969555',0,'鲜嫩虾','精致的小虾',26.50,'kg','group1/M00/00/00/wKj2lF0HQtSAVedcAAAk0DN4-yE4091550',10,10,1,5,3),(8,'2019-06-17 07:40:00.495082','2019-06-20 14:41:53.503410',0,'盒装草莓','一盒新鲜的草莓',10.00,'盒','group1/M00/00/00/wKj2lF0HQ9CAVxo2AAAljHPuXJg6866911',22,8,1,1,4),(9,'2019-06-18 09:55:30.458159','2019-06-24 13:11:05.202615',0,'草莓','去芯的草莓，见过没？',13.00,'kg','group1/M00/00/00/wKj2ll0ItRKAXjXSAAAgrKNKuOg6723603',30,0,1,1,4),(10,'2019-06-21 07:34:21.396164','2019-06-21 07:34:21.396204',0,'小柠檬','不酸哦',13.00,'kg','group1/M00/00/00/wKj2mV0MiH2AbDGhAAAgnaeGwNQ7151160',30,0,1,6,4),(11,'2019-06-21 07:36:44.369553','2019-06-21 07:36:44.369596',0,'大柠檬','这个也不酸',10.00,'盒','group1/M00/00/00/wKj2mV0MiQyAFrzWAAAcLRyfMSc9680928',20,0,1,6,4),(12,'2019-06-24 13:06:56.453960','2019-06-24 13:21:11.665188',0,'青苹果','青青草园的苹果',8.00,'kg','group1/M00/00/00/wKj2nF0QyvCALDbGAAAWnwO6wpU9386697',30,2,1,7,4),(13,'2019-06-25 00:48:51.298424','2019-06-25 00:48:51.298508',0,'北海道秋刀鱼','肉多刺少',36.00,'kg','group1/M00/00/00/wKj2nF0Rb3OAA_XHAAAkaP_7_185246471',50,1,1,8,3);
/*!40000 ALTER TABLE `df_goods_sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_goods_type`
--

DROP TABLE IF EXISTS `df_goods_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_goods_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `name` varchar(20) NOT NULL,
  `logo` varchar(20) NOT NULL,
  `image` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_goods_type`
--

LOCK TABLES `df_goods_type` WRITE;
/*!40000 ALTER TABLE `df_goods_type` DISABLE KEYS */;
INSERT INTO `df_goods_type` VALUES (2,'2019-06-13 06:41:12.573165','2019-06-14 13:32:08.553107',0,'猪牛羊肉','meet','group1/M00/00/00/wKj2k10DodiAbqRYAAAy1Tlm9So7053033'),(3,'2019-06-14 07:22:56.843400','2019-06-14 13:33:32.197675',0,'美味海鲜','seafood','group1/M00/00/00/wKj2kl0DS1CAUDiZAABHr3RQqFs3728443'),(4,'2019-06-14 13:45:46.330175','2019-06-17 07:23:04.128961',0,'新鲜水果','fruit','group1/M00/00/00/wKj2k10DpQqAR8nqAAAmv27pX4k2428821'),(5,'2019-06-17 07:21:55.567805','2019-06-17 07:21:55.567860',0,'禽类蛋品','egg','group1/M00/00/00/wKj2lF0HP5OAXvYOAAAqR4DoSUg7950395'),(6,'2019-06-17 07:22:14.128462','2019-06-17 07:22:14.128574',0,'新鲜蔬菜','vegetables','group1/M00/00/00/wKj2lF0HP6aAFat9AAA-0ZoYkpM0580705'),(7,'2019-06-17 07:22:25.419363','2019-06-17 07:22:25.419495',0,'速冻食品','ice','group1/M00/00/00/wKj2lF0HP7GAUpNjAAA3sZPrVzQ2707990');
/*!40000 ALTER TABLE `df_goods_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_index_banner`
--

DROP TABLE IF EXISTS `df_index_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_index_banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `image` varchar(100) NOT NULL,
  `index` smallint(6) NOT NULL,
  `sku_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_index_banner_sku_id_723c73ff2799c2b7_fk_df_goods_sku_id` (`sku_id`),
  CONSTRAINT `df_index_banner_sku_id_723c73ff2799c2b7_fk_df_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `df_goods_sku` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_index_banner`
--

LOCK TABLES `df_index_banner` WRITE;
/*!40000 ALTER TABLE `df_index_banner` DISABLE KEYS */;
INSERT INTO `df_index_banner` VALUES (5,'2019-06-17 07:36:25.120652','2019-06-17 07:36:25.120690',0,'group1/M00/00/00/wKj2lF0HQvmADu2fAACpB-LsCdE8124758',0,2),(6,'2019-06-17 07:36:35.337518','2019-06-17 07:36:35.337557',0,'group1/M00/00/00/wKj2lF0HQwOAANdwAAD0akkXmFo5732193',1,7),(7,'2019-06-25 00:50:25.555889','2019-06-25 00:50:25.555927',0,'group1/M00/00/00/wKj2nF0Rb9GAL-fCAAETwXb_pso1566980',2,13);
/*!40000 ALTER TABLE `df_index_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_index_promotion`
--

DROP TABLE IF EXISTS `df_index_promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_index_promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `name` varchar(20) NOT NULL,
  `url` varchar(200) NOT NULL,
  `image` varchar(100) NOT NULL,
  `index` smallint(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_index_promotion`
--

LOCK TABLES `df_index_promotion` WRITE;
/*!40000 ALTER TABLE `df_index_promotion` DISABLE KEYS */;
INSERT INTO `df_index_promotion` VALUES (1,'2019-06-14 07:11:43.334091','2019-06-14 13:32:43.025200',0,'大促销','no','group1/M00/00/00/wKj2k10DofuAE42YAAA98yvCs1I1549012',0),(2,'2019-06-14 07:15:59.088923','2019-06-14 13:32:37.081002',0,'猪牛羊肉','no','group1/M00/00/00/wKj2k10DofWAXLWLAAA2pLUeB603378694',1);
/*!40000 ALTER TABLE `df_index_promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_index_type_goods`
--

DROP TABLE IF EXISTS `df_index_type_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_index_type_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `display_type` smallint(6) NOT NULL,
  `index` smallint(6) NOT NULL,
  `sku_id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_index_type_goods_sku_id_19645908463c0712_fk_df_goods_sku_id` (`sku_id`),
  KEY `df_index_type_goods_type_id_1bf5f36d79e060ad_fk_df_goods_type_id` (`type_id`),
  CONSTRAINT `df_index_type_goods_sku_id_19645908463c0712_fk_df_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `df_goods_sku` (`id`),
  CONSTRAINT `df_index_type_goods_type_id_1bf5f36d79e060ad_fk_df_goods_type_id` FOREIGN KEY (`type_id`) REFERENCES `df_goods_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_index_type_goods`
--

LOCK TABLES `df_index_type_goods` WRITE;
/*!40000 ALTER TABLE `df_index_type_goods` DISABLE KEYS */;
INSERT INTO `df_index_type_goods` VALUES (1,'2019-06-14 14:07:19.246342','2019-06-14 14:07:19.246375',0,1,0,1,4),(2,'2019-06-16 15:02:32.672656','2019-06-16 15:02:32.672700',0,1,1,2,4),(3,'2019-06-17 07:37:51.209443','2019-06-17 07:37:51.209496',0,1,0,7,3),(4,'2019-06-21 07:34:54.166627','2019-06-21 07:34:54.166660',0,1,2,10,4),(5,'2019-06-21 07:37:02.828718','2019-06-21 07:37:02.828764',0,1,3,11,4),(6,'2019-06-24 13:07:49.809839','2019-06-24 13:07:49.809938',0,1,2,12,4),(7,'2019-06-25 00:50:46.754259','2019-06-25 00:50:46.754339',0,1,1,13,3);
/*!40000 ALTER TABLE `df_index_type_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_order_goods`
--

DROP TABLE IF EXISTS `df_order_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_order_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `count` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `comment` varchar(256) NOT NULL,
  `order_id` varchar(128) NOT NULL,
  `sku_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `df_order_goods_69dfcb07` (`order_id`),
  KEY `df_order_goods_22ad5bca` (`sku_id`),
  CONSTRAINT `df_order_goo_order_id_2136b054ec249af0_fk_df_order_info_order_id` FOREIGN KEY (`order_id`) REFERENCES `df_order_info` (`order_id`),
  CONSTRAINT `df_order_goods_sku_id_38e43565c3204820_fk_df_goods_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `df_goods_sku` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_order_goods`
--

LOCK TABLES `df_order_goods` WRITE;
/*!40000 ALTER TABLE `df_order_goods` DISABLE KEYS */;
INSERT INTO `df_order_goods` VALUES (7,'2019-06-23 13:06:10.143752','2019-06-23 13:06:10.143847',0,2,26.50,'','201906232106104',7),(8,'2019-06-23 13:16:35.328123','2019-06-23 13:16:35.328168',0,1,1.23,'','201906232116354',1),(9,'2019-06-24 04:57:21.883479','2019-06-24 04:59:50.397186',0,2,26.50,'特别好吃的小虾子','201906241257211',7),(10,'2019-06-24 04:57:21.886911','2019-06-24 04:59:50.404301',0,3,10.00,'草莓很棒','201906241257211',8),(11,'2019-06-24 12:29:39.860661','2019-06-24 12:29:39.860699',0,2,2.30,'','201906242029391',2);
/*!40000 ALTER TABLE `df_order_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_order_info`
--

DROP TABLE IF EXISTS `df_order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_order_info` (
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `order_id` varchar(128) NOT NULL,
  `pay_method` smallint(6) NOT NULL,
  `total_count` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `transit_price` decimal(10,2) NOT NULL,
  `order_status` smallint(6) NOT NULL,
  `trade_no` varchar(128) NOT NULL,
  `addr_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `df_order_info_90ccbf41` (`addr_id`),
  KEY `df_order_info_e8701ad4` (`user_id`),
  CONSTRAINT `df_order_info_addr_id_670ad13ad90cb1a7_fk_df_address_id` FOREIGN KEY (`addr_id`) REFERENCES `df_address` (`id`),
  CONSTRAINT `df_order_info_user_id_6b71d60ea4dec110_fk_df_user_id` FOREIGN KEY (`user_id`) REFERENCES `df_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_order_info`
--

LOCK TABLES `df_order_info` WRITE;
/*!40000 ALTER TABLE `df_order_info` DISABLE KEYS */;
INSERT INTO `df_order_info` VALUES ('2019-06-23 13:06:10.131163','2019-06-23 13:09:16.443814',0,'201906232106104',3,2,53.00,10.00,4,'2019062322001405631000039956',2,4),('2019-06-23 13:16:35.314298','2019-06-23 13:19:09.014860',0,'201906232116354',3,1,1.23,10.00,4,'2019062322001405631000038150',2,4),('2019-06-24 04:57:21.878208','2019-06-24 04:59:50.411597',0,'201906241257211',3,5,83.00,10.00,5,'2019062422001405631000038151',1,1),('2019-06-24 12:29:39.736433','2019-06-24 12:29:39.861376',0,'201906242029391',3,2,4.60,10.00,1,'',1,1);
/*!40000 ALTER TABLE `df_order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_user`
--

DROP TABLE IF EXISTS `df_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_user`
--

LOCK TABLES `df_user` WRITE;
/*!40000 ALTER TABLE `df_user` DISABLE KEYS */;
INSERT INTO `df_user` VALUES (1,'pbkdf2_sha256$20000$F6cwIHkoz5wk$G7BxEKvgleRuvf620399UlIykMiU0SAgLGFerz+7Ky0=','2019-06-25 02:13:04.427915',0,'chenbo','','','15281678200@163.com',0,1,'2019-06-10 02:12:18.009518','2019-06-10 02:12:18.025203','2019-06-10 02:12:18.027586',0),(2,'pbkdf2_sha256$20000$1XNv6vSdxwQX$UaB10ajSEGQTOlbKAh0F6a1ENM6JX4ok1ngk7Wpxsoo=','2019-06-11 12:53:19.580056',0,'chenbo1','','','15281678200@163.com',0,1,'2019-06-10 04:12:12.187078','2019-06-10 04:12:12.206066','2019-06-10 04:12:12.217808',0),(3,'pbkdf2_sha256$20000$Wum1GTChYkFy$B5s4GvfMy6+9NHV7pEKLkjfMAv3wrjAbrR2bJtN3Jm8=','2019-06-25 00:45:03.733984',1,'admin','','','862354023@qq.com',1,1,'2019-06-13 06:22:24.003611','2019-06-13 06:22:24.024151','2019-06-13 06:22:24.024172',0),(4,'pbkdf2_sha256$20000$QTtBATm1q0b3$Ep9X1ypsUcqUdZ6jBpx4qV2Fp1Q0zdNDWyRM1zMG7Zc=','2019-06-25 02:18:54.887160',0,'wenli','','','15281678200@163.com',0,1,'2019-06-14 13:48:22.700306','2019-06-14 13:48:22.722225','2019-06-14 13:50:41.580400',0);
/*!40000 ALTER TABLE `df_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_user_groups`
--

DROP TABLE IF EXISTS `df_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `df_user_groups_group_id_7e684165f191254c_fk_auth_group_id` (`group_id`),
  CONSTRAINT `df_user_groups_group_id_7e684165f191254c_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `df_user_groups_user_id_5d91e25a1794951a_fk_df_user_id` FOREIGN KEY (`user_id`) REFERENCES `df_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_user_groups`
--

LOCK TABLES `df_user_groups` WRITE;
/*!40000 ALTER TABLE `df_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `df_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `df_user_user_permissions`
--

DROP TABLE IF EXISTS `df_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `df_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `df_user_user_permission_id_f4a4aaf43117895_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `df_user_user_permission_id_f4a4aaf43117895_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `df_user_user_permissions_user_id_67b7c936295c92e7_fk_df_user_id` FOREIGN KEY (`user_id`) REFERENCES `df_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `df_user_user_permissions`
--

LOCK TABLES `df_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `df_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `df_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `djang_content_type_id_453fc91b0f9aa544_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_4cc58f9e659b22b6_fk_df_user_id` (`user_id`),
  CONSTRAINT `djang_content_type_id_453fc91b0f9aa544_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_4cc58f9e659b22b6_fk_df_user_id` FOREIGN KEY (`user_id`) REFERENCES `df_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2019-06-13 06:38:56.119575','1','猪牛羊肉',1,'',8,3),(2,'2019-06-13 06:40:33.960899','1','猪牛羊肉',3,'',8,3),(3,'2019-06-13 06:41:12.722773','2','猪牛羊肉',1,'',8,3),(4,'2019-06-13 07:06:41.860966','2','猪牛羊肉',2,'已修改 image 。',8,3),(5,'2019-06-13 07:07:15.586576','2','猪牛羊肉',2,'已修改 image 。',8,3),(6,'2019-06-14 01:47:24.792642','2','猪牛羊肉',2,'已修改 image 。',8,3),(7,'2019-06-14 06:17:10.434247','2','猪牛羊肉',2,'没有字段被修改。',8,3),(8,'2019-06-14 07:11:43.725459','1','IndexPromotionBanner object',1,'',14,3),(9,'2019-06-14 07:15:59.153308','2','IndexPromotionBanner object',1,'',14,3),(10,'2019-06-14 07:22:56.925308','3','美味海鲜',1,'',8,3),(11,'2019-06-14 13:32:08.952098','2','猪牛羊肉',2,'已修改 image 。',8,3),(12,'2019-06-14 13:32:37.090617','2','IndexPromotionBanner object',2,'已修改 image 。',14,3),(13,'2019-06-14 13:32:43.030085','1','IndexPromotionBanner object',2,'已修改 image 。',14,3),(14,'2019-06-14 13:33:32.200175','3','美味海鲜',2,'已修改 logo 。',8,3),(15,'2019-06-14 13:45:46.338389','4','水果',1,'',8,3),(16,'2019-06-14 14:05:14.415322','1','Goods object',1,'',10,3),(17,'2019-06-14 14:06:54.019585','1','GoodsSKU object',1,'',9,3),(18,'2019-06-14 14:07:19.403271','1','IndexTypeGoodsBanner object',1,'',13,3),(19,'2019-06-14 14:08:46.709463','1','IndexGoodsBanner object',1,'',12,3),(20,'2019-06-16 15:00:45.746163','2','草莓',1,'',9,3),(21,'2019-06-16 15:02:33.094750','2','IndexTypeGoodsBanner object',1,'',13,3),(22,'2019-06-17 06:41:39.069820','1','IndexGoodsBanner object',2,'已修改 image 。',12,3),(23,'2019-06-17 07:13:36.001133','1','草莓',2,'已修改 name 和 detail 。',10,3),(24,'2019-06-17 07:14:08.177262','2','葡萄',1,'',10,3),(25,'2019-06-17 07:14:22.366560','1','葡萄',2,'已修改 goods 。',9,3),(26,'2019-06-17 07:14:57.046278','3','猪肉',1,'',10,3),(27,'2019-06-17 07:20:52.174725','4','轮播展示',1,'',10,3),(28,'2019-06-17 07:21:55.850954','5','禽类蛋品',1,'',8,3),(29,'2019-06-17 07:22:14.134960','6','新鲜蔬菜',1,'',8,3),(30,'2019-06-17 07:22:25.447362','7','速冻食品',1,'',8,3),(31,'2019-06-17 07:23:04.136232','4','新鲜水果',2,'已修改 name 。',8,3),(32,'2019-06-17 07:23:44.062312','3','新鲜水果',1,'',9,3),(33,'2019-06-17 07:24:24.814238','4','新鲜水果2',1,'',9,3),(34,'2019-06-17 07:25:02.162482','5','猪牛羊肉',1,'',9,3),(35,'2019-06-17 07:26:05.499398','5','小龙虾',1,'',10,3),(36,'2019-06-17 07:26:52.436872','6','进口海鲜',1,'',9,3),(37,'2019-06-17 07:27:36.708267','1','IndexGoodsBanner object',2,'已修改 sku 和 image 。',12,3),(38,'2019-06-17 07:27:47.667401','2','IndexGoodsBanner object',1,'',12,3),(39,'2019-06-17 07:27:57.419960','3','IndexGoodsBanner object',1,'',12,3),(40,'2019-06-17 07:28:17.689140','4','IndexGoodsBanner object',1,'',12,3),(41,'2019-06-17 07:31:42.687038','6','进口海鲜',3,'',9,3),(42,'2019-06-17 07:31:42.807719','5','猪牛羊肉',3,'',9,3),(43,'2019-06-17 07:31:42.815004','4','新鲜水果2',3,'',9,3),(44,'2019-06-17 07:31:42.825887','3','新鲜水果',3,'',9,3),(45,'2019-06-17 07:35:48.449422','7','鲜嫩虾',1,'',9,3),(46,'2019-06-17 07:36:25.124707','5','IndexGoodsBanner object',1,'',12,3),(47,'2019-06-17 07:36:35.480159','6','IndexGoodsBanner object',1,'',12,3),(48,'2019-06-17 07:37:51.212169','3','IndexTypeGoodsBanner object',1,'',13,3),(49,'2019-06-17 07:40:00.498092','8','盒装草莓',1,'',9,3),(50,'2019-06-18 09:55:30.719097','9','草莓',1,'',9,3),(51,'2019-06-21 07:33:36.841321','6','柠檬',1,'',10,3),(52,'2019-06-21 07:34:22.670293','10','小柠檬',1,'',9,3),(53,'2019-06-21 07:34:54.535433','4','IndexTypeGoodsBanner object',1,'',13,3),(54,'2019-06-21 07:36:45.194309','11','大柠檬',1,'',9,3),(55,'2019-06-21 07:37:02.847261','5','IndexTypeGoodsBanner object',1,'',13,3),(56,'2019-06-24 13:03:47.735873','7','苹果',1,'',10,3),(57,'2019-06-24 13:06:58.215051','12','青苹果',1,'',9,3),(58,'2019-06-24 13:07:50.207179','6','IndexTypeGoodsBanner object',1,'',13,3),(59,'2019-06-24 13:11:06.419259','9','草莓',2,'已修改 type 。',9,3),(60,'2019-06-24 13:21:12.926399','12','青苹果',2,'已修改 sales 。',9,3),(61,'2019-06-25 00:45:49.435423','8','鱼',1,'',10,3),(62,'2019-06-25 00:48:53.114765','13','北海道秋刀鱼',1,'',9,3),(63,'2019-06-25 00:50:25.904813','7','IndexGoodsBanner object',1,'',12,3),(64,'2019-06-25 00:50:46.830962','7','IndexTypeGoodsBanner object',1,'',13,3);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_5e47ea23d5645a3d_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(10,'goods','goods'),(11,'goods','goodsimage'),(9,'goods','goodssku'),(8,'goods','goodstype'),(12,'goods','indexgoodsbanner'),(14,'goods','indexpromotionbanner'),(13,'goods','indextypegoodsbanner'),(16,'order','ordergoods'),(15,'order','orderinfo'),(5,'sessions','session'),(7,'user','address'),(6,'user','user');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2019-06-07 13:16:35.369627'),(2,'contenttypes','0002_remove_content_type_name','2019-06-07 13:16:35.706557'),(3,'auth','0001_initial','2019-06-07 13:16:36.729296'),(4,'auth','0002_alter_permission_name_max_length','2019-06-07 13:16:36.924893'),(5,'auth','0003_alter_user_email_max_length','2019-06-07 13:16:36.939821'),(6,'auth','0004_alter_user_username_opts','2019-06-07 13:16:36.951210'),(7,'auth','0005_alter_user_last_login_null','2019-06-07 13:16:36.959501'),(8,'auth','0006_require_contenttypes_0002','2019-06-07 13:16:36.963656'),(9,'user','0001_initial','2019-06-07 13:16:38.327091'),(10,'admin','0001_initial','2019-06-07 13:16:38.831484'),(11,'goods','0001_initial','2019-06-07 13:16:41.203604'),(12,'order','0001_initial','2019-06-07 13:16:41.406492'),(13,'order','0002_auto_20190607_2116','2019-06-07 13:16:43.141897'),(14,'sessions','0001_initial','2019-06-07 13:16:43.314661');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-25 13:30:53

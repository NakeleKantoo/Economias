
DROP TABLE IF EXISTS `categoria`;

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `categoria` WRITE;

INSERT INTO `categoria` VALUES
(1,'Contas Casa'),
(2,'Contas Carro'),
(3,'Faculdade'),
(4,'Lanches'),
(5,'Combustivel'),
(6,'Compras'),
(7,'Moveis'),
(8,'Eventuais'),
(9, 'Almoço Trabalho');
UNLOCK TABLES;

DROP TABLE IF EXISTS `gastos`;

CREATE TABLE `gastos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `categoria` int(11) NOT NULL,
  `meioPagamento` int(11) NOT NULL,
  `dsc` varchar(255) DEFAULT NULL,
  `dtgasto` datetime(6) NOT NULL,
  `valor` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `categoria` (`categoria`),
  KEY `meioPagamento` (`meioPagamento`),
  CONSTRAINT `gastos_ibfk_1` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`id`),
  CONSTRAINT `gastos_ibfk_2` FOREIGN KEY (`meioPagamento`) REFERENCES `meioPagamento` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `meioPagamento`;

CREATE TABLE `meioPagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


LOCK TABLES `meioPagamento` WRITE;
INSERT INTO `meioPagamento` VALUES
(1,'Credito'),
(2,'Debito'),
(3,'Pix'),
(4,'Dinheiro'),
(5,'Boleto'),
(6,'Vale-transporte')
UNLOCK TABLES;

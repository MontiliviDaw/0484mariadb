CREATE DATABASE IF NOT EXISTS `hospital`;
use hospital;

###*************************************************************************************
###                        Procés de creació massiva taules SGBD
###*************************************************************************************
###  Es creen taules
###     DEPT      PK-> dept_num
###     EMPL      PK-> empl_num                      
###               FK-> empl_dept_num 
###     MALALT    PK-> malalt_num 
###     HOSPITAL  PK-> hospital_codi
###     SALA      PK-> sala_codi, sala_hospital_codi 
###               FK-> sala_hospital_codi
###     PLANTILLA PK-> plantilla_empleat_num
###               FK-> plantilla_sala_codi,plantilla_hospital_codi
###     DOCTOR    PK-> doctor_codi
###               FK-> doctor_hospital_codi
###*************************************************************************************
-- Guardem les dades de la connexió actual
SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET NAMES utf8mb4;
SET @OLD_TIME_ZONE=@@TIME_ZONE;
SET TIME_ZONE='+00:00';
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0;
SET FOREIGN_KEY_CHECKS=0;
### Comencem eliminant totes les possibles taules
###

DROP TABLE IF EXISTS plantilla;  
DROP TABLE IF EXISTS doctor;
DROP TABLE IF EXISTS empl;
DROP TABLE IF EXISTS dept;
DROP TABLE IF EXISTS malalt;
DROP TABLE IF EXISTS sala;
DROP TABLE IF EXISTS hospital;

###*************************************
###   Definició estructura taula DEPT
###*************************************
CREATE TABLE dept(
	dept_num  INT(2) PRIMARY KEY,
	dept_nom  VARCHAR(14),
	dept_loc  VARCHAR(13));

###*************************************
###   Insercció de dades a la taula DEPT
###*************************************
INSERT INTO  dept VALUES (10,'Comptabilitat','Sevilla');
INSERT INTO  dept VALUES (20,'Investigacio','Madrid');
INSERT INTO  dept VALUES (30,'Vendes','Barcelona');
INSERT INTO  dept VALUES (40,'Produccio','Bilbao');

###*************************************
###   Definició estructura taula EMPL
###*************************************
CREATE TABLE empl
 (empl_num      INT(4)   PRIMARY KEY,
  empl_nom      VARCHAR(16),
  empl_ofici    VARCHAR(10),
  empl_dir      INT(4),
  empl_datalt   date,
  empl_salari   DECIMAL(11,2),
  empl_comissio DECIMAL(11,2),
  empl_dept_num INT(2));

ALTER TABLE empl
  ADD CONSTRAINT fk_empl_dept_num
  FOREIGN KEY (empl_dept_num)
  REFERENCES dept(dept_num);

###*************************************
###   Insercció de dades a la taula EMPL
###*************************************
INSERT INTO  empl VALUES
(7369,'SANCHEZ','EMPLEAT',7902,str_to_date('17-12-1980','%d-%m-%Y'),104000,null,20);
INSERT INTO  empl VALUES
(7499,'ARROYO','VENEDOR',7698,str_to_date('22-02-1981','%d-%m-%Y'),208000,39000,30);
INSERT INTO  empl VALUES
(7521,'SALA','VENEDOR',698,str_to_date('22-02-1981','%d-%m-%Y'),162500,65000,30);
INSERT INTO  empl VALUES
(7566,'JIMENEZ','DIRECTOR',7839,str_to_date('02-04-1981','%d-%m-%Y'),386750,null,20);
INSERT INTO  empl VALUES
(7654,'MARTIN','VENEDOR',7698,str_to_date('28-09-1981','%d-%m-%Y'),182000,182000,30);
INSERT INTO  empl VALUES
(7698,'NEGRO','DIRECTOR',7839,str_to_date('01-05-1981','%d-%m-%Y'),370500,null,30);
INSERT INTO  empl VALUES
(7782,'CEREZO','DIRECTOR',7839,str_to_date('09-06-1981','%d-%m-%Y'),318500,null,10);
INSERT INTO  empl VALUES
(7788,'GIL','ANALISTA',7566,str_to_date('30-03-1987','%d-%m-%Y'),390000,null,20);
INSERT INTO  empl VALUES
(7839,'REY','PRESIDENT',null,str_to_date('17-11-1981','%d-%m-%Y'),650000,null,10);
INSERT INTO  empl VALUES
(7844,'TOVAR','VENEDOR',7698,str_to_date('08-09-1981','%d-%m-%Y'),195000,0,30);
INSERT INTO  empl VALUES
(7876,'ALONSO','EMPLEAT',7788,str_to_date('03-05-1987','%d-%m-%Y'),143000,null,20);
INSERT INTO  empl VALUES
(7900,'JIMENO','EMPLEAT',7698,str_to_date('03-12-1981','%d-%m-%Y'),123500,null,30);
INSERT INTO  empl VALUES
(7902,'FERNANDEZ','ANALISTA',7566,str_to_date('03-12-1981','%d-%m-%Y'),390000,null,20);
INSERT INTO  empl VALUES
(7934,'MUNOZ','EMPLEAT',7782,str_to_date('23-01-1982','%d-%m-%Y'),169000,null,10);

###*************************************
###   Definició estructura taula MALALT
###*************************************
CREATE TABLE malalt
 (malalt_num    INT(5) PRIMARY KEY,
  malalt_nom    VARCHAR(12),
  malalt_adreca VARCHAR(20),
  malalt_dnaixa date,
  malalt_sexe   VARCHAR(1),
  malalt_nss    INT(9));

###***************************************
###   Insercció de dades a la taula MALALT
###***************************************
INSERT INTO  malalt VALUES 
(10995,'Laguia M.','Goya 20',str_to_date('16-05-1956','%d-%m-%Y'),'M',280862482);
INSERT INTO  malalt VALUES 
(18004,'Serrano V.','Alcala 12',str_to_date('21-05-1960','%d-%m-%Y'),'F',284991452);
INSERT INTO  malalt VALUES 
(14024,'Fernandez M.','Recoletos 20',str_to_date('23-06-1967','%d-%m-%Y'),'F',321790059);
INSERT INTO  malalt VALUES 
(36658,'Domin S.','Major 71',str_to_date('01-01-1942','%d-%m-%Y'),'M',160654471);
INSERT INTO  malalt VALUES 
(38702,'Neal R.','Orense 11',str_to_date('18-06-1940','%d-%m-%Y'),'F',380010217);
INSERT INTO  malalt VALUES
(39217,'Cervantes M.','Peron 38',str_to_date('29-02-1952','%d-%m-%Y'),'M',440294390);
INSERT INTO  malalt VALUES 
(59076,'Miller B.','Lopez de Hoyos 2',str_to_date('16-09-1945','%d-%m-%Y'),'F',311969044);
INSERT INTO  malalt VALUES 
(63827,'Ruiz P.','Esquerdo 103',str_to_date('26-12-1980','%d-%m-%Y'),'M',100973253);
INSERT INTO  malalt VALUES 
(64823,'Fraser A.','Soto 3',str_to_date('10-07-1980','%d-%m-%Y'),'F',285201776);
INSERT INTO  malalt VALUES
(74835,'Benitez E.','Argentina 5',str_to_date('05-10-1957','%d-%m-%Y'),'M',154811767);

###*************************************
###   Definició estructura taula HOSPITAL
###*************************************
CREATE TABLE hospital
 (hospital_codi    INT(2) PRIMARY KEY,
  hospital_nom     VARCHAR(12),
  hospital_adreca  VARCHAR(20),
  hospital_telefon VARCHAR(8),
  hospital_nllits  INT(4));

###*****************************************
###   Insercció de dades a la taula HOSPITAL
###*****************************************
INSERT INTO  hospital VALUES (13,'Provincial','O''Donell,20','964-4264',502);
INSERT INTO  hospital VALUES (18,'General','Atocha, s/n','595-3111',987);
INSERT INTO  hospital VALUES (22,'La Paz','Castellana, 1000','923-5411',412);
INSERT INTO  hospital VALUES (45,'San Carlos','Ciudad Universitaria','597-1500',845);

###*************************************
###   Definició estructura taula SALA
###*************************************
CREATE TABLE sala
 (sala_codi          INT(2),
  sala_hospital_codi INT(2),
  sala_nom           VARCHAR(20),
  sala_nllits        INT(4));

ALTER TABLE sala
ADD CONSTRAINT pk_sala_codi_hospital
PRIMARY KEY (sala_codi, sala_hospital_codi);

ALTER TABLE sala
ADD CONSTRAINT fk_sala_hospital_codi
FOREIGN KEY (sala_hospital_codi)
REFERENCES hospital(hospital_codi);

###*****************************************
###   Insercció de dades a la taula SALA
###*****************************************
INSERT INTO  sala VALUES (3,13,'Cures Intensives',21);
INSERT INTO  sala VALUES (6,13,'Psiquiatric',67);
INSERT INTO  sala VALUES (3,18,'Cures Intensives',10);
INSERT INTO  sala VALUES (4,18,'Cardiologia',53);
INSERT INTO  sala VALUES (1,22,'Recuperacio',10);
INSERT INTO  sala VALUES (6,22,'Psiquiatric',118);
INSERT INTO  sala VALUES (2,22,'Maternitat',34);
INSERT INTO  sala VALUES (4,45,'Cardiologia',55);
INSERT INTO  sala VALUES (1,45,'Recuperacio',13);
INSERT INTO  sala VALUES (2,45,'Maternitat',2);

###***************************************
###   Definició estructura taula PLANTILLA
###***************************************
CREATE TABLE plantilla
 ( plantilla_hospital_codi INT(2),
   plantilla_sala_codi     INT(2),
   plantilla_empleat_num   INT(4) PRIMARY KEY,
   plantilla_nom           VARCHAR(16),
   plantilla_funcio        VARCHAR(10),
   plantilla_torn          VARCHAR(1),
   plantilla_salari        DECIMAL(11,2));

ALTER TABLE plantilla
ADD CONSTRAINT fk_plantilla_sala_codi
FOREIGN KEY (plantilla_sala_codi,plantilla_hospital_codi)
REFERENCES sala(sala_codi,sala_hospital_codi);

###*****************************************
###   Insercció de dades a la taula PLANTILLA
###*****************************************
INSERT INTO  plantilla VALUES 
(13,6,3754,'Diaz B.','Infermera','T',ROUND(1.25 * 226200 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(13,6,3106,'Hernandez J.','Infermer','T',ROUND(1.25 * 275000 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(18,4,6357,'Karplus W.','Intern','T',ROUND(1.25 * 337900 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(22,6,1009,'Higueras D.','Infermera','T',ROUND(1.25 * 200500 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(22,6,8422,'Bocina G.','Infermer','M',ROUND(1.25 * 183800 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(22,2,9901,'Nunez C.','Intern','M',ROUND(1.25 * 221000 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(22,1,6065,'Rivera G.','Infermera','N',ROUND(1.25 * 162600 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(22,1,7379,'Carlos R.','Infermera','T',ROUND(1.25 * 221900 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(45,4,1280,'Amigo R.','Intern','N',ROUND(1.25 * 221000 / 166.386, 2));
INSERT INTO  plantilla VALUES 
(45,1,8526,'Frank H.','Infermera','T',ROUND(1.25 * 252200 / 166.386, 2));

###***************************************
###   Definició estructura taula DOCTOR
###***************************************
CREATE TABLE doctor
 ( doctor_codi          INT(3) PRIMARY KEY,
   doctor_hospital_codi INT(2),
   doctor_nom           VARCHAR(16),
   doctor_especialitat  VARCHAR(16));

ALTER TABLE doctor 
ADD CONSTRAINT fk_doctor_hospital_codi
FOREIGN KEY (doctor_hospital_codi)
REFERENCES hospital(hospital_codi);

###*****************************************
###   Insercció de dades a la taula DOCTOR
###*****************************************   
INSERT INTO  doctor VALUES (435,13,'Lopez A', 'Cardiologia');
INSERT INTO  doctor VALUES (585,18,'Miller G.', 'Ginecologia');
INSERT INTO  doctor VALUES (982,18,'Cajal R.', 'Cardiologia');
INSERT INTO  doctor VALUES (453,22,'Galo D.', 'Pediatria');
INSERT INTO  doctor VALUES (398,22,'Best D.', 'Urologia');
INSERT INTO  doctor VALUES (386,22,'Cabeza D.', 'Psiquiatria');
INSERT INTO  doctor VALUES (607,45,'Nino P.', 'Pediatria');
INSERT INTO  doctor VALUES (522,45,'Adams C.', 'Neurologia');

SET FOREIGN_KEY_CHECKS=1;

-- Restaurem les dades de la connexió actual
SET TIME_ZONE=@OLD_TIME_ZONE;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT;
SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS;
SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION;
SET SQL_NOTES=@OLD_SQL_NOTES;

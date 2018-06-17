-- create schema RedeSocial;
-- use RedeSocial;
 create database WantWork;
 use WantWork;
-- drop schema RedeSocial;
-- drop database WantWork;

CREATE TABLE Utilizador (
    util_id INT NOT NULL UNIQUE auto_increment, /*public*/
    util_nome VARCHAR(50) NOT NULL, /*public*/
    util_foto BLOB, /*public*/
    util_dataNascimento DATE NOT NULL, /*public*/
    util_nSeguidores INT DEFAULT 0, /*public*/
    util_nAmigos int default 0,
    PRIMARY KEY (util_id)
);

create table Pessoas (
pess_id int not null unique auto_increment, /*private*/
pess_educaçao varchar(50) not null, /*public*/
pess_trabalhoAtual varchar(50) default "Desempregado",  /*public*/
pess_nAmigos int default 0,  /*public*/
pess_nSeguidores int default 0, /* public*/
pess_utilID int not null unique, /*private*/
primary key(pess_id),
foreign key(pess_utilID) references Utilizador(util_id));

create table Empresas (
emp_id int not null unique auto_increment, /*private*/
emp_Ntrabalhadores int default 0, /*public*/
emp_utilID int not null unique, /*public*/
emp_nAmigos int default 0,
primary key(emp_id),
foreign key(emp_utilID) references Utilizador(util_id));

create table Publicacao(
pub_id int not null unique auto_increment, 
pub_texto varchar(1000) not null, /*public*/
pub_data date not null, /*public*/
pub_foto blob, /*public*/
pub_utilId int not null, /*public*/
primary key(pub_id),
foreign key(pub_utilId) references Utilizador(util_id));

create table Comentario (
com_id int not null unique auto_increment, 
com_texto varchar(1000), /*public*/
com_foto blob, /*public*/
com_data date not null, /*public*/
com_utilID int not null, /*public*/
com_pubId int not null, /*public*/
primary key(com_id),
foreign key(com_utilID) references Utilizador(util_id),
foreign key(com_pubID) references Publicacao(pub_id));

create table Grupo(
grupo_id int not null auto_increment, /*private*/
grupo_utilID int not null, /*public*/
primary key(grupo_id, grupo_utilID),
foreign key(grupo_utilID) references Utilizador(util_id));

create table Mensagens(
men_id int not null unique auto_increment, 
men_texto varchar(1000), /*public*/
men_foto blob, /*public*/
men_data date not null, /*public*/
men_utilID int not null, /*public*/
men_grupoID int not null, /*public*/
primary key(men_id),
foreign key(men_utilID) references Utilizador(util_id),
foreign key(men_grupoID) references Grupo(grupo_id));

create table Contactos(
email varchar(20), /*public*/
cont_nTelefone int, /*public*/
cont_utilID int not null, /*public*/
primary key(email, cont_nTelefone, cont_utilID),
foreign key(cont_utilID) references Utilizador(util_id));

create table ComentarioComentario (
id_comentario1 int not null, /*public*/
id_comentario2 int, /*public*/
primary key(id_comentario1,id_comentario2),
foreign key(id_comentario1) references Comentario(com_id),
foreign key(id_comentario2) references Comentario(com_id));


create table UtilizadorUtilizador (
utut_utilId1 int not null, /*public*/
utut_utilId2 int, /*public*/
primary key (utut_utilId1, utut_utilId2),
foreign key (utut_utilId1) references Utilizador(util_id),
foreign key (utut_utilId2) references Utilizador(util_id));


create table Ranking(
rank_id int not null auto_increment, /*private*/
rank_pubId int, /*public*/
rank_comId int, /*public*/
rank_rank int, /*public*/
primary key(rank_id),
foreign key(rank_pubId) references publicacao(pub_id),
foreign key(rank_comId) references comentario(com_id));






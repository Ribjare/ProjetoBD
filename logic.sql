 use WantWork;

/** Procedures*/
drop procedure utilPublicacoes;
drop procedure utilComentarios;
drop procedure utilAmigos;

Create view Publicacoes(Publicações) as
	select pub_texto
    from publicacao;
    select * from Publicacoes;
    
    select * from Publicacoes;
    
delimiter //    -- ver publicaçoes de um utilizador
create procedure utilPublicacoes(
in id_utilizador int)
    begin
    select pub_texto
    from publicacao
    where pub_utilId=id_utilizador;
	end//
    delimiter ;    


Create View Comentarios(Comentários) as 
	select com_texto
    from comentario;
    
    
 delimiter //    
   -- ver os comentarios feitos por utilizador
create procedure utilComentarios(
in id__util int)
	begin
    select com_texto as 'Comentarios'
    from comentario
    where com_utilID = id__util;
    
    end//

    
delimiter ;    
    
    
Select * from utilComentarios;

Create View utilAmigos(Amigos) as 
	select util_nome
    from utilizador 
    where util_id in (select utut_utilId2 from utilizadorutilizador where utut_utilId1 = 3);
    
Select * from utilAmigos;


delimiter // -- ver amigos do utilizador
Create procedure utilAmigos(
int id_alu int)
select util_nome
    from utilizador 
    where util_id in (	select utut_utilId2 
						from utilizadorutilizador 
						where utut_utilId1 = id_alu);

delimiter ; 





delimiter //
-- ver comentarios de uma publicaçao
Create procedure comentariosDaPublicacao(
in id_publicao int)
begin

select com_texto as Comentario, util_id as 'Id do Utilizador', com_data as 'Data'
from comentario
join utilizador on com_utilID=util_id
where com_pubId=id_publicao
order by com_data;

end//
delimiter ; 
drop procedure comentariosDaPublicacao;
call comentariosDaPublicacao(1);









-- Gestor
-- ver numero total de utilizadores inscritos 
create view NumeroUtilizadores(Total) as
select count(*)
from utilizador;


select* from NumeroUtilizadores;


-- ver numero total de comentarios feitos
create view NumeroComentarios(Total) as
select count(*)
from comentario;


select* from NumeroComentarios;

-- ver numero total de publicaçoes feitos

create view NumeroPosts(Total) as
select count(*)
from publicacao;

select* from NumeroPosts;

-- ver a media de comentarios por utilizador
create view mediaComentarioConteudo(Media) as
select count(com_id)/count(pub_id)
from comentario
join utilizador on util_id=com_utilID
join publicacao on util_id=pub_utilId;


select * from mediaComentarioConteudo;

delimiter //-- ver a media de rank das publicaçoes de um utilizador
-- por eliminar but not yet
create procedure mediaRankPublicacaoUtilizador(in x_id_util int, out media float)
begin

if(x_id_util not in (select util_id from utilizador)) 
then 
-- ------------------------
signal error;

else

select avg(rank_rank) into media
from publicacao
join ranking on pub_id=rank_pubId
where pub_utilId=x_id_util;

end if;

end//
-- calcula a media 
create function mediaRankPublicacaoUtilizador(x_id_util int)
returns float
deterministic
begin
declare media int;
select avg(rank_rank) into media
from publicacao
join ranking on pub_id=rank_pubId
where pub_utilId=x_id_util;


return media;
end//
delimiter ;

drop procedure mediaRankPublicacaoUtilizador;
-- provisorio
select avg(rank_rank)
from publicacao
join ranking on pub_id=rank_pubId
where  pub_utilId=3;

-- select * from publicacao join ranking on pub_id=rank_pubId;



delimiter //-- ver os utilizadores com maior media de rank nas suas publicaçoes
-- testar como mais dados

create procedure rankUtilizador()
begin
select util_id as 'Id',util_nome as 'Nome', mediaRankPublicacaoUtilizador(util_id) as 'Media do rank'
from utilizador
order by  mediaRankPublicacaoUtilizador(util_id) asc;

end//
delimiter ;

drop procedure rankUtilizador;


call rankUtilizador();



delimiter //
create function avgRankPublicao(id_publica int)
returns int
deterministic
begin

declare x int;

select avg(rank_rank) into x
from publicacao 
join ranking on pub_id=rank_pubId
where pub_id =id_publica;

return x;
end//

drop function avgRankPublicao;
delimiter;

delimiter//
create procedure melhorDaSemana()
begin
-- ver do distinct
select distinct pub_texto as 'Publicacao', avgRankPublicao(pub_id) as 'Rank'
from publicacao 
join ranking on pub_id=rank_pubId
where dayofmonth(pub_data) >= dayofmonth(now())-7
order by avgRankPublicao(pub_id) desc;


end//

delimiter ;


drop procedure melhorDaSemana;

call melhorDaSemana;



create view classificacaoPub(Utilizador, Id, Media_Publicacao)
as 
select util_nome,util_id, avg(rank_rank)
from publicacao
join utilizador on util_id=pub_utilId
join ranking on pub_id=rank_pubId;


select * from classificacaoPub;


-- fim gestor


delimiter //
create procedure createPessoa(in nome varchar(50), in dataNacimento date,in educacao varchar(120), in email varchar(50), in telemovel int)
begin

insert into utilizador(util_nome, util_dataNascimento)
		values(nome, dataNascimento);
        set id= last_insert_id();
insert into pessoas(pess_educaçao, pess_utilID)
		values(educacao, id);
insert into contactos(email, cont_nTelefone,cont_utilID)
		values(email, telemovel, id);

end//

delimiter ;

delimiter //
create procedure createEmpresa(in nome varchar(50), in dataNacimento date, in numeroTrabalhadores int)
begin
insert into utilizador(util_nome, util_dataNascimento)
		values(nome, dataNascimento);
        set id= last_insert_id();
insert into empresas(emp_Ntrabalhadores,emp_utilID)
		values(numeroTrabalhadores, id);

end//
delimiter ;



delimiter //

create procedure createPublicacaoSoTexto(in texto varchar(120), in id_utilizador int)
begin

declare continue handler for utilizador_nao_existe
resignal set message_text= 'Não existe utilizador com esse id';

if not exists(select * from utilizador where util_id=id_utilizador )
then

signal utilizador_nao_existe;

else 

insert into publicacao (pub_texto, pub_data,pub_utilId)
		values(texto, curdate(), id_utilizador);

end if;

end//

delimiter ;





-- falta testar

delimiter //

create procedure createAmigos(in id_utilizador_amigo int, in id_utilizador_tu int)
begin
declare continue handler for utilizador_amigo_nao_existe
resignal set message_text= 'Não existe utilizador com esse id';

declare continue handler for utilizador_tu_nao_existe
resignal set message_text= 'Não existe utilizador com esse id';

if not exists(select * from utilizador where util_id=id_utilizador_amigo )
then

signal utilizador_amigo_nao_existe;

else if not exists(select * from utilizador where util_id=id_utilizador_tu ) then

signal utilizador_tu_nao_existe;

else 
insert into utilizadorutilizador(utut_utilId1,utut_utilId2)
values(id_utilizador_amigo, id_utilizador_tu);

end if;

end//

delimiter ;




delimiter //

create procedure createGroupChat()
begin



end//

delimiter ;






delimiter //
delimiter ;













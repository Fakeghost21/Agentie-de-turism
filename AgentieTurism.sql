Create database [Agentie de turism]
use [Agentie de turism]

--Tabelul de pe partea one a relatiei
create table FirmaTransport
(cod_t int PRIMARY KEY IDENTITY,
nume varchar(50),
nr_angajati int,
website varchar(100)
)

--Tabelul de pe partea many a relatiei(va fi folosit si in partea m-n)
create table Traseu
(cod_t int PRIMARY KEY IDENTITY,
OPRIRI VARCHAR(200),
TIP VARCHAR(100) not null,
data_plecarii datetime not null,
data_intoarcerii datetime not null,
FIRMA_TRANSPORT INT FOREIGN KEY REFERENCES FirmaTransport(cod_t) 
on delete cascade
on update cascade)

ALTER TABLE	FirmaTransport
ADD Contact varchar(10)

alter table Traseu
add ora_plecarii time

alter table Traseu
add ora_intoarcerii time

create table Cazare
(cod_cazare int PRIMARY KEY IDENTITY,
rating int,
contact varchar(10),
locatie varchar(200) not null)

create table Ghid
(cod_ghid int PRIMARY KEY IDENTITY,
nume varchar(100) not null,
contact varchar(10) not null,
website varchar(100))

--Tabelul de legatura intre traseu,cazare si ghid
create table Itinerariu
(cod_traseu INT FOREIGN KEY REFERENCES Traseu(cod_t),
cod_cazare INT FOREIGN KEY REFERENCES Cazare(cod_cazare),
cod_ghid INT FOREIGN KEY REFERENCES Ghid(cod_ghid),
locuri_disponibile int,
locuri_ocupate int,
pret int not null,
CONSTRAINT pk_itinerariu PRIMARY KEY(cod_traseu,cod_cazare,cod_ghid)
)

drop database [Agentie de turism]

--Inserare in tabelul FirmaTransport
insert into FirmaTransport
(nume,nr_angajati,website)
values('Alis',12000,'www.alis.ro');

insert into FirmaTransport
(Contact)
values('0723123457')

insert into FirmaTransport
(nume,nr_angajati,website,Contact)
values('Afrodita',6000,'afro.ro','0213789012');

Alter table Traseu
drop column Durata

--Inserare in tabelul Traseu
insert into Traseu
(OPRIRI,TIP,data_plecarii,data_intoarcerii,FIRMA_TRANSPORT)
values('Izvoare,Cavnic','City break','10-02-2021 10:30','10-06-2021 12:30',1)

insert into Traseu
(OPRIRI,TIP,data_plecarii,data_intoarcerii,FIRMA_TRANSPORT)
values('Suior,Mogosa','Excursie montana','03-19-2021 11:30','03-24-2021 18:15',1);

insert into Traseu
(OPRIRI,TIP,data_plecarii,data_intoarcerii,FIRMA_TRANSPORT)
values('Transfagarasan,Transalpina','Excursie montana','05-31-2021 11:30','06-01-2021 18:15',2);

--Inserare in tabelul Cazare
insert into Cazare
(rating,contact,locatie)
values(5,'0213420978','Mogosa');

insert into Cazare
(rating,locatie)
values(4,'Suior');

insert into Cazare
(contact,locatie)
values('0213420998','Izvoare');

--Inserare in tabelul Ghid
insert into Ghid
(nume,contact)
values('Paul Hoban','071253468');

insert into Ghid
(nume,contact,website)
values('Mircea Tarot','071253468','myTravel.com');

--Itinerariu
insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(1,2,2,50,30,400);

--Cazare
insert into Cazare
(contact,locatie)
values('0234628890','Izvoare');

insert into Cazare
(rating,contact,locatie)
values(5,'0734628890','Transfagarasan');

alter table Cazare 
add nume varchar(30)

--Actualizare
update Cazare
set rating = 3
where rating is null

--Traseu
insert into Traseu
(OPRIRI,TIP,data_plecarii,data_intoarcerii,FIRMA_TRANSPORT)
values('Padurea regilor,Lacul Vidraru','City break','06-20-2021 12:30','06-23-2021 18:45',1);

--Actualizare date Traseu
update Traseu
set FIRMA_TRANSPORT = 2
where FIRMA_TRANSPORT = 1 and TIP = 'City break'

--Itinerariu
insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(3,4,2,50,70,450);

insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(3,5,2,50,70,450);

insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(4,5,3,100,10,650);

insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(4,5,2,100,25,500);

insert into Itinerariu
(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
values(3,3,3,110,49,500);

--Stergere de date din itierariu
delete from Itinerariu
where pret >= 500 or locuri_ocupate < 40

select * from Cazare

--1)Procedura de adaugare a unei firme de transport(Lab4)
go
create procedure uspAdaugaFirmaTransport
@nume varchar(50),
@nr_angajati int,
@website varchar(100),
@contact varchar(10)
as
begin 
	Insert into FirmaTransport
	(nume,nr_angajati,website,Contact)
	Values(@nume,@nr_angajati,@website,@contact);

	print 'S-a inserat cu succes in firma de transport';
end

--drop procedure uspAdaugaFirmaTransport

exec uspAdaugaFirmaTransport 'Corola',2000,'coro.ro';
exec uspAdaugaFirmaTransport 'Ruben',3400,'www.rubi.com';
exec uspAdaugaFirmaTransport 'Tuleila',8900,'leila.com';

select * from Traseu

select * from Ghid

--drop procedure uspAdaugaGhid

--exec uspAdaugaGhid 'Horeaul Bolcsa',07896253543,'travel_theWorld.com'

Select * from Ghid

--rating int,
--contact varchar(10),
--locatie varchar(200) not null



--drop procedure uspAdaugaCazare

exec uspAdaugaCazare 5,'0784359432','Oradea','Astoria'


Select * from Itinerariu

--1.1)functie care verifica daca codul de traseu exista(lab4)
go
create function ExistaTraseu
(@cod_traseu int)
returns bit as 
begin
if(exists(
select cod_t from Traseu
where @cod_traseu = cod_t))
return 1;
return 0;
end

--1.2)functie care verifica daca codul de cazare exista(lab4)
go
create function ExistaCazare
(@cod_cazare int)
returns bit as 
begin
if(exists(
select cod_cazare from Cazare
where @cod_cazare = cod_cazare))
return 1;
return 0;
end

--1.3)functie care verifica daca codul ghidului exista
go
create function ExistaGhid
(@cod_ghid int)
returns bit as 
begin
if(exists(
select cod_ghid from Ghid
where @cod_ghid = cod_ghid))
return 1;
return 0;
end

--2.)procedura de adaugare in tabelul itinerariu care arunca erori pentru cazurile in care nu vreunul din
--codurile necesare creerii itinerariului
go
create procedure uspAdaugaItinerariu
@cod_traseu int,
@cod_cazare int,
@cod_ghid int,
@locuri_disponibile int,
@locuri_ocupate int,
@pret int
as
begin 
	if(dbo.ExistaTraseu(@cod_traseu) = 0)
		raisError('Codul traseului introdus nu s-a gasit',11,1)
	else if(dbo.ExistaCazare(@cod_cazare) = 0)
		raisError('Codul cazarii introduse nu exista',11,1)
	else if(dbo.ExistaGhid(@cod_ghid) = 0)
		raisError('Codul ghidului introdus nu exista',11,1)
	else
	Insert into Itinerariu
	(cod_traseu,cod_cazare,cod_ghid,locuri_disponibile,locuri_ocupate,pret)
	Values(@cod_traseu,@cod_cazare,@cod_ghid,@locuri_disponibile,@locuri_ocupate,@pret)
	
end

select * from Itinerariu
exec uspAdaugaItinerariu 2,4,5,200,100,1200

--drop procedure uspAdaugaItinerariu

--1.4)functie care verifica daca ratingul este de o anumita valoare
go
create function VerificareRating
(@rating float)
returns bit as 
begin
if(@rating < 0 or @rating > 5)
return 0;
return 1;
end

--3.)procedura de adaugare a unei cazari ce arunca o eroare daca ratingul introdus nu especa intervalul de la 0 la 5
go
create procedure uspAdaugaCazare
@rating float,
@contact varchar(10),
@locatie varchar(200),
@nume varchar(30)
as
begin 
	if(dbo.VerificareRating(@rating) = 0)
		RaisError('Rating-ul trebuie sa ia valori reale de la 0 la 5',11,1)
	else
	Insert into Cazare
	(rating,contact,locatie,nume)
	Values(@rating,@contact,@locatie,@nume);

end

exec uspAdaugaCazare 11,0789536789,'Pri','Verduna'
Select * from Cazare

--drop procedure uspAdaugaCazare

--4.)procedura de adaugare a unui ghid
go
create procedure uspAdaugaGhid
@nume varchar(100),
@contact varchar(10),
@website varchar(100),
@pret float
as
begin 
	Insert into Ghid
	(nume,contact,website,pret_excursie)
	Values(@nume,@contact,@website,@pret);

	print 'S-a inserat cu succes in tabelul ghizilor';
end

--1.5)functie ce verifica daca id-ul introdus apare in tabelul de firma transport
go
create function idFirma
(@id float)
returns bit as 
begin
if(exists(
select cod_t from FirmaTransport
where @id = cod_t))
return 1;
return 0;
end

--5.)procedura de adaugare a unui traseu care arunca eroare daca id-l firmei de transport introdus nu exista
go
create procedure uspAdaugaTraseu
@opriri varchar(200),
@tip varchar(100),
@data_plecarii datetime,
@data_intoarcerii datetime,
@id_firma_transport int
as
begin 
	if(dbo.idFirma(@id_firma_transport) = 0)
		RaisError('Codul introdus al firmei de transport nu exista',11,1)
	else
	Insert into Traseu
	(OPRIRI,TIP,data_plecarii,data_intoarcerii,FIRMA_TRANSPORT)
	Values(@opriri,@tip,@data_plecarii,@data_intoarcerii,@id_firma_transport);
end

--drop procedure uspAdaugaItinerariu

exec uspAdaugaItinerariu 1,2,4,100,20,1290
select * from Traseu
exec uspAdaugaTraseu 'acolo,dincoace','City break','06-20-2021 12:30','06-24-2021 12:30',16

exec uspAdaugaTraseu 'Beregunele','City break','06-20-2021 12:30','06-24-2021 12:30',3;
select * from Traseu


--Uniune intre firma de transport si traseu(cerinta 1) *
Select nume,contact from FirmaTransport
Union
Select OPRIRI,TIP from Traseu;

--Inner Join intre doua tabele;afiseaza opririle si data plecarii dintr-un traseu care este folosit intr-un
--itinerariu,folosind Distinct(cerinta 2)
SELECT Distinct T.OPRIRI,T.data_plecarii from Traseu T 
INNER JOIN 
Itinerariu I ON I.cod_traseu=T.cod_t 

--Full Outer Join intre tabelele itinerariu,ghid si traseu,utilitatea tabelului fiind in faptul ca se pot observa
--opririle traseelor,iar daca acestea sunt utilizate intr-un itinerariu,apare si numele ghidului,cat si contactul
--acestuia precum si locurile disponibile(cerinta 2)
SELECT Distinct T.OPRIRI, G.nume, G.contact,I.locuri_disponibile FROM Traseu T 
FULL OUTER JOIN 
Itinerariu I ON T.cod_t = I.cod_traseu 
FULL OUTER JOIN 
Ghid G ON I.cod_ghid = G.cod_ghid;

--Creeaza o tabela care contine toate tipurile de traseu cat si de cate ori este utilizat(cerinta 3)
Select TIP,count(TIP) as Aparitii from Traseu
group by TIP;

alter table Ghid
add pret_excursie float

alter table Cazare
alter column rating float

--Creeaza un tabel ce va contine toate cazarile cu locatiile lor daca au un rating mediu mai mare de 3(cerinta 3)
--folosind media ratingurilor per locatie *
SELECT locatie,rating,nume FROM Cazare 
GROUP BY locatie,rating,nume having avg(rating) > 3;

--Creeaza un tabel ce va contine totalul de locuri ocupate pentru fiecare traseu din itinerariu(cerinta 3)
Select cod_traseu,sum(locuri_ocupate) as [Locuri Ocupate] from Itinerariu
group by cod_traseu;

--where
Select * from Traseu

--view care verifica traseul planificat in itinerariu pentru fiecare cazare din itinerariu

go
CREATE VIEW vw_Traseu 
as
SELECT C.nume,C.locatie, T.OPRIRI,T.data_plecarii,T.data_intoarcerii 
FROM Cazare C INNER JOIN Itinerariu I on I.cod_cazare = C.cod_cazare
inner join Traseu T on I.cod_traseu = T.cod_t

Select * from vw_Traseu

Select * from Traseu
Select * from Cazare
Select * from Itinerariu

create table istoric_cazare
(nr int PRIMARY KEY IDENTITY,
nume varchar(30),
data_adaugare datetime)

--Trigger care creeaza si insereaza intr-un tabel de istoric pentru cazare,numele cazarii si data pentru care este 
--rezervata cazarea,pentru fiecare noua cazare introdusa in itinerariu si afiseaza data si ora la care s-a introdus
--cat si faptul ca este o operatie de adaugare impreuna cu umele tabelului
go
CREATE TRIGGER [dbo].[istoric] ON [dbo].[Itinerariu]
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;

declare @cod_cazare datetime
declare @nume varchar(30)
declare @cod_traseu datetime
declare @data datetime
Select @cod_cazare = lista.cod_cazare from inserted lista;
Select @cod_traseu = lista.cod_traseu from inserted lista;

Select @nume =C.nume from Cazare C where @cod_cazare = C.cod_cazare
Select @data =T.data_plecarii from Traseu T where @cod_traseu = T.cod_t

INSERT INTO istoric_cazare(nume,data_rezervare)
Values(@nume,@data);
Print getdate();
Print 'Adaugare in tabelul Itinerariu';

END;
exec uspAdaugaItinerariu 12,5,5,180,20,1200
select * from istoric_cazare

--Redenumirea unei coloane dintr-un tabel
exec sp_rename 'istoric_cazare.data_adaugare','data_rezervare','Column';

create table istoric_cazari_libere
(nr int PRIMARY KEY IDENTITY,
nume varchar(30),
data_libera datetime)

--Trigger care creeaza si insereaza intr-un tabel de istoric pentru cazare,numele cazarii si data pentru care este 
--libera cazarea,pentru fiecare cazare stearsa din itinerariu si afiseaza data si ora la care s-a sters
--cat si faptul ca este o operatie de stergere impreuna cu numele tabelului
go
CREATE TRIGGER [dbo].[istoric2] ON [dbo].[Itinerariu]
AFTER DELETE
AS
BEGIN
SET NOCOUNT ON;

declare @cod_cazare datetime
declare @nume varchar(30)
declare @cod_traseu datetime
declare @data datetime

Select @cod_cazare = lista.cod_cazare from deleted lista;
Select @cod_traseu = lista.cod_traseu from deleted lista;

Select @nume =C.nume from Cazare C where @cod_cazare = C.cod_cazare
Select @data =T.data_plecarii from Traseu T where @cod_traseu = T.cod_t

INSERT INTO istoric_cazari_libere(nume,data_libera)
Values(@nume,@data);
Print getdate();
Print 'Stergere din tabelul Itinerariu';

END;

delete from Itinerariu where locuri_disponibile = 19
delete from Itinerariu where locuri_disponibile = 50

exec uspAdaugaItinerariu 12,7,2,18,200,120
exec uspAdaugaItinerariu 12,1,3,189,20,140
select * from istoric_cazare
select * from Itinerariu
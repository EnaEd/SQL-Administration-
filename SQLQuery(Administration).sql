--1 Структура памяти MDF/LDF
--уровень вниз EXTENT
--Удаление  DROP INDEX <TableName>.<IndexName>
--При принятии решения  о назначении индекаса
--Смотрим на селективноесть, вставка непоследовательных
USE AERO 
GO
SELECT Passenger.name,Pass_in_trip.place,Trip.town_from
FROM dbo.Passenger JOIN dbo.Pass_in_trip
ON Passenger.ID_psg=Pass_in_trip.ID_psg JOIN dbo.Trip
ON Trip.trip_no=Pass_in_trip.trip_no
WHERE Trip.town_from='Moscow'
GO
--CTRL+L жмякаем
--можно вторым способом 
--SQLProfile
--Tools->SQLSERVER Profile->COnnect->Run
--***************-

CREATE TABLE tst(
ID int,--тут без PRAIMERY KEY т.к. был бы создан идекс
field2 float--тип флоат это важно т.к. дальше используем функцию RAND(возврат значений BETWEEN 0 and 1)
)
GO
Declare @cnt int
set @cnt = 0
while(@cnt < 100000)
begin
insert tst values(@cnt, rand());
set @cnt = @cnt + 1
end
GO
select * from tst where ID = 99999
GO
--Построили индекс, существенно увеличил скорость работы
CREATE INDEX indTst on tst (ID)

--Просмотр загрузки
DBCC SHOWCONTIG ('tst','indTst')
--DBCC SHOWCONTIG scanning 'tst' table...
--Table: 'tst' (978102525); index ID: 3, database ID: 45
--LEAF level scan performed.
--- Pages Scanned................................: 224
--- Extents Scanned..............................: 30
--- Extent Switches..............................: 29
--- Avg. Pages per Extent........................: 7.5
--- Scan Density [Best Count:Actual Count].......: 93.33% [28:30]
--- Logical Scan Fragmentation ..................: 2.23%
--- Extent Scan Fragmentation ...................: 13.33%
--- Avg. Bytes Free per Page.....................: 60.3
--- Avg. Page Density (full).....................: 99.26%--Хорошо для поиска, плохо для ALTER
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.
delete from tst where ID%2 = 0

DBCC DBREINDEX ('tst','indTst')
DBCC SHOWCONTIG ('tst','indTst')
DBCC SHOW_STATISTICS('tst','indTst')
--ДЗ
--Выполнить создание индексов для БД «SantaBelinda» для ускорения:
--- поиск жильца по фамилии
--- вывода всех жильцов, живущих в заданном городе
--- поиск по полному имени в пределах категории (составной индекс: фамилия+имя)
--- выбор всех бизнесов указанного жильца(рассмотреть преимущества и недостатки такого
--индкса: замедление вставки, фрагментация при удалении)
--Проверить изменение времени выполнения запросов при наличие и отсутсвии индексов.
--1 ��������� ������ MDF/LDF
--������� ���� EXTENT
--��������  DROP INDEX <TableName>.<IndexName>
--��� �������� �������  � ���������� ��������
--������� �� ��������������, ������� ������������������
USE AERO 
GO
SELECT Passenger.name,Pass_in_trip.place,Trip.town_from
FROM dbo.Passenger JOIN dbo.Pass_in_trip
ON Passenger.ID_psg=Pass_in_trip.ID_psg JOIN dbo.Trip
ON Trip.trip_no=Pass_in_trip.trip_no
WHERE Trip.town_from='Moscow'
GO
--CTRL+L �������
--����� ������ �������� 
--SQLProfile
--Tools->SQLSERVER Profile->COnnect->Run
--***************-

CREATE TABLE tst(
ID int,--��� ��� PRAIMERY KEY �.�. ��� �� ������ �����
field2 float--��� ����� ��� ����� �.�. ������ ���������� ������� RAND(������� �������� BETWEEN 0 and 1)
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
--��������� ������, ����������� �������� �������� ������
CREATE INDEX indTst on tst (ID)

--�������� ��������
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
--- Avg. Page Density (full).....................: 99.26%--������ ��� ������, ����� ��� ALTER
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.
delete from tst where ID%2 = 0

DBCC DBREINDEX ('tst','indTst')
DBCC SHOWCONTIG ('tst','indTst')
DBCC SHOW_STATISTICS('tst','indTst')
--��
--��������� �������� �������� ��� �� �SantaBelinda� ��� ���������:
--- ����� ������ �� �������
--- ������ ���� �������, ������� � �������� ������
--- ����� �� ������� ����� � �������� ��������� (��������� ������: �������+���)
--- ����� ���� �������� ���������� ������(����������� ������������ � ���������� ������
--������: ���������� �������, ������������ ��� ��������)
--��������� ��������� ������� ���������� �������� ��� ������� � ��������� ��������.
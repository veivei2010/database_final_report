USE [master]
GO
/****** Object:  Database [QUANLYDIEM]    Script Date: 6/30/2021 9:40:15 PM ******/
CREATE DATABASE [QUANLYDIEM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QUANLYDIEM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\QUANLYDIEM.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QUANLYDIEM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\QUANLYDIEM_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QUANLYDIEM] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QUANLYDIEM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QUANLYDIEM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET ARITHABORT OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYDIEM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYDIEM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QUANLYDIEM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QUANLYDIEM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QUANLYDIEM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QUANLYDIEM] SET  MULTI_USER 
GO
ALTER DATABASE [QUANLYDIEM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QUANLYDIEM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QUANLYDIEM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QUANLYDIEM] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QUANLYDIEM]
GO
/****** Object:  StoredProcedure [dbo].[spBangDiem]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBangDiem](@MSV int) 
as
begin
	select
		MSV,
		MonHoc.TenMon, 
		MonHoc.TC,
		max(DiemTrungBinhMon) as DiemTBMon
	from dbo.fDiemTB(), MonHoc
	where fDiemTB.MaMon = MonHoc.MaMon
	and @MSV = MSV
	group by
		MSV,
		MonHoc.TenMon, 
		MonHoc.TC
return 
end;
GO
/****** Object:  StoredProcedure [dbo].[spBuocThoiHoc]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spBuocThoiHoc]
as
begin
	select 
		fTinChiNo.MSV,
		HoTenSV,
		TinChiNo 
	from dbo.fTinChiNo() left join SINHVIEN
	on fTinChiNo.MSV = SinhVien.MSV where TinChiNo >27
end;
GO
/****** Object:  StoredProcedure [dbo].[spCanhCao]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spCanhCao]
as
begin
	select 
		MSV,
		Case 
			When dbo.fTCNoSV (MSV) > 8 and dbo.fTCNoSV (MSV)<17 then 'Muc 1'
			When dbo.fTCNoSV (MSV) > 16 and dbo.fTCNoSV (MSV) <28 then 'Muc 2'
			When dbo.fTCNoSV (MSV) > 27 then 'Muc 3'
		end as MucCanhCao
	from dbo.fTinChiNo()
	where TinChiNo >8
end;
GO
/****** Object:  StoredProcedure [dbo].[spDKMH]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spDKMH] (@MSV int, @kihoc int)
as
begin
	select
		Diem.MSV, 
		MonHoc.MaMon,
		TenMon,
		TC,
		Diem.MaLopMH 
	from MonHoc, LopMH, Diem
	where MonHoc.MaMon = LopMH.MaMon
	and LopMH.MaLopMH = Diem.MaLopMH
	and Diem.MSV = @MSV
	and LopMH.KyHocTT = @kihoc
return 
end;

GO
/****** Object:  StoredProcedure [dbo].[spDKThiCK]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spDKThiCK]
(
	@MaLopMH AS int
)
AS
BEGIN
	SELECT* FROM dbo.fDiemQT()
	where @MaLopMH = MaLopMH 
	AND DiemQuaTrinh >= 3
end;
GO
/****** Object:  StoredProcedure [dbo].[spGPACacKy]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[spGPACacKy]
(
	@MSV int
)
AS 
begin
	select 
		MSV, HoTenSV, KyHocTT,
		ROUND((Sum(DiemQuyDoi*MonHoc.TC)/SUM(MonHoc.TC)),2) AS GPA
	from dbo.f10_to_4() udf10_to_4, MonHoc
	where MonHoc.MaMon = udf10_to_4.MaMon
	And MSV = @MSV
	group by MSV, HoTenSV, KyHocTT
	end;
GO
/****** Object:  StoredProcedure [dbo].[spHocBong]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHocBong]
(@KyHocTT int)
AS
Begin
	SELECT
		DiemRL.MSV, 
		HoTenSV,
		DiemRL.KyHocTT,
		GPA,
		DiemRL,
	Case
		When DiemRL>=90 and GPA>=3.6 then 'A'
		When DiemRL>=80 And GPA>=3.2 then 'B'
		When DiemRL>=65 And GPA>=2.5 Then 'C'
		else 'Khong'
	End As LoaiHocBong
	From dbo.fGPA(@KyHocTT) udfGPA, DiemRL
	Where udfGPA.MSV = DiemRL.MSV
	and DiemRL.KyHocTT = @KyHocTT
	Order by LoaiHocBong
	end;


GO
/****** Object:  StoredProcedure [dbo].[spTienDoTiengAnh]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spTienDoTiengAnh]
as
begin
	select
		fTinChiTichLuy.MSV,
		max(DiemTA.KyHocTT) as KyHocTT,
		sum(TinChiTichLuy) as TinChiTichLuy,
		max(DiemTA) as DiemTA,
		dbo.fDiemTA(DiemTA.MSV, max(DiemTA.KyHocTT)) as TienDoTiengAnh
	from DiemTA, dbo.fTinChiTichLuy()
	where DiemTA.MSV = fTinChiTichLuy.MSV
	group by 
		DiemTA.MSV,
		fTinChiTichLuy.MSV
end
GO
/****** Object:  StoredProcedure [dbo].[spXepLoaiDiemRL]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spXepLoaiDiemRL]
as
begin
	select 
	MSV,
	KyHocTT,
	DiemRL,
	Case 
	When DiemRL <50 then 'Yeu'
	When DiemRL>=50 and DiemRL < 65 then 'Trung Binh'
	When DiemRL>=65 and DiemRL < 80 then 'Kha'
	When DiemRL>=80 and DiemRL < 90 then 'Gioi'
	When DiemRL>=90 then 'Xuat Sac'
	end as XepLoai
	from DiemRL 
end;
GO
/****** Object:  StoredProcedure [dbo].[spXHLopMH]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spXHLopMH]
(	@MaLopMH int)
AS
begin 
	Select 
		MSV, 
		HoTenSV,
		MaLopMH,
		TenMon,
		KyHocTT,
		DiemTrungBinhMon
	From dbo.fDiemTB()
	where MaLopMH = @MaLopMH
	order by DiemTrungBinhMon desc
end;
GO
/****** Object:  StoredProcedure [dbo].[spXHLopSV]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spXHLopSV]
(	
	@MaLopSV varchar(20),
	@KyHocTT int
)
as
begin
	select 
		LopSV.MSV,
		HoTenSV,
		GPA
	From  dbo.fGPA(@KyHocTT), LopSV
	where fGPA.MSV = LopSV.MSV
	AND @KyHocTT = fGPA.KyHocTT 
	And @MalopSV = LopSv.MaLopSV
	order by GPA desc
End;
GO
/****** Object:  UserDefinedFunction [dbo].[fDiemTA]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fDiemTA] (@MSV int, @kihochientai int)
returns nvarchar(20)
as
begin
	declare @tinchitichluy int
set @tinchitichluy = (select sum(TinChiTichLuy) from dbo.fTinChiTichLuy() where   fTinChiTichLuy.MSV = @MSV and fTinChiTichLuy.KyHocTT <= @kihochientai group by MSV)
	declare @diemTA int
	set @diemTA = (select max(DiemTA.DiemTA) from DiemTA where DiemTA.MSV = @MSV and DiemTA.KyHocTT <= @kihochientai group by MSV)
	declare @tiendo nvarchar(20)
	IF (@tinchitichluy < 64 ) 
		BEGIN
		if (@diemTA >= 350) set @tiendo = 'Dat'
		else
		begin
			if (exists (select MSV from fQuaMon() where MaMon = 'FL1020' and MSV = @MSV)) set @tiendo = 'Dat'
			else set @tiendo = 'Khong Dat'
		end
		END

	IF (@tinchitichluy >= 64 and @tinchitichluy <= 95) 
		BEGIN
		if (@diemTA >= 350) set @tiendo = 'Dat'
		else set @tiendo = 'Khong Dat'
		END

	IF (@tinchitichluy >= 96 ) 
		BEGIN
		if (@diemTA >= 500) set @tiendo = 'Dat'
		else set @tiendo = 'Khong Dat'
		END

return @tiendo
end

GO
/****** Object:  UserDefinedFunction [dbo].[fTCNoSV]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fTCNoSV] (@MSV int)
returns int
as
begin
	declare @TCNo int
	Set @TCNo = (select TinChiNo from dbo.fTinChiNo() where @MSV = MSV)
	return @TCNo
end;

GO
/****** Object:  UserDefinedFunction [dbo].[fTinhDiemQT]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fTinhDiemQT]
(
	@DiemGK real,
	@DiemCongQT real
)
returns real
as
begin 
	Declare @DiemQT real
	Set @DiemQT = @DiemGK + @DiemCongQT;
	If @DiemQT>10 
	begin
		Return 10;
	end
	return @DiemQT;
End;
GO
/****** Object:  UserDefinedFunction [dbo].[fTinhDiemTB]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fTinhDiemTB]
(
	@DiemQT real,
	@DiemCK real
)
Returns real
AS
Begin
	Declare @DiemTB real
	Set @DiemTB = @DiemQT*0.3 + @DiemCK*0.7
Return @DiemTB 
End;



GO
/****** Object:  Table [dbo].[CTGvMh]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CTGvMh](
	[MaGV] [int] NOT NULL,
	[MaMon] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC,
	[MaMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CTLopSV]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CTLopSV](
	[MaLopSV] [varchar](20) NOT NULL,
	[TenLop] [nvarchar](100) NOT NULL,
	[MaGV] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLopSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Diem]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Diem](
	[MSV] [int] NOT NULL,
	[MaLopMH] [int] NOT NULL,
	[DiemCongQT] [real] NULL,
	[DiemCK] [real] NULL,
	[DiemGK] [real] NULL,
PRIMARY KEY CLUSTERED 
(
	[MSV] ASC,
	[MaLopMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiemRL]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiemRL](
	[MSV] [int] NOT NULL,
	[KyHocTT] [int] NOT NULL,
	[DiemRL] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MSV] ASC,
	[KyHocTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiemTA]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiemTA](
	[MSV] [int] NOT NULL,
	[KyHocTT] [int] NOT NULL,
	[DiemTA] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MSV] ASC,
	[KyHocTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GiangVien]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GiangVien](
	[MaGV] [int] NOT NULL,
	[HoTenGV] [nvarchar](100) NOT NULL,
	[HocVi] [nvarchar](50) NULL,
	[MaVien] [varchar](20) NULL,
	[ChuyenNganhGV] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InDiem]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InDiem](
	[MaPhieu] [int] NOT NULL,
	[MSV] [int] NOT NULL,
	[NgayIn] [date] NULL,
	[NDIn] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LopMH]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LopMH](
	[MaLopMH] [int] NOT NULL,
	[MaMon] [varchar](20) NOT NULL,
	[MGV] [int] NULL,
	[KyHocTT] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLopMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LopSV]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LopSV](
	[MaLopSV] [varchar](20) NOT NULL,
	[MSV] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLopSV] ASC,
	[MSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MonHoc]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MonHoc](
	[MaMon] [varchar](20) NOT NULL,
	[TenMon] [nvarchar](100) NOT NULL,
	[TC] [int] NOT NULL,
	[KyHocDK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MSV] [int] NOT NULL,
	[HoTenSV] [nvarchar](50) NOT NULL,
	[KhoaHoc] [int] NOT NULL,
	[GioiTinh] [nvarchar](10) NULL,
	[NgaySinh] [date] NULL,
	[QueQuan] [nvarchar](100) NULL,
	[TrangThai] [nvarchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[MSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vien]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vien](
	[MaVien] [varchar](20) NOT NULL,
	[TenVien] [nvarchar](200) NOT NULL,
	[DiaChi] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fDiemTB]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[fDiemTB]()
Returns table
AS
Return
	Select
		SINHVIEN.MSV,
		SINHVIEN.HoTenSV,
		Diem.MaLopMH,
		MonHoc.TenMon,
		LopMh.MaMon,
		LopMH.KyHocTT,
		dbo.fTinhDiemTB(dbo.fTinhDiemQT(DiemGK, DiemCongQT), DiemCK) AS DiemTrungBinhMon 
	From 
		Sinhvien,
		Diem,
		MonHoc,
		LopMH
	Where  SINHVIEN.MSV = Diem.MSV
	AND	   Diem.MaLopMH = LopMH.MaLopMH
	AND	   LopMH.MaMon = MonHoc.MaMon



GO
/****** Object:  UserDefinedFunction [dbo].[fQuaMon]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[fQuaMon] ()
returns TABLE 
as
return
	select 
		MSV,
		HoTenSV,
		MaLopMH,
		MonHoc.TenMon,
		MonHoc.MaMon,
		MonHoc.TC,
		KyHocTT,
		DiemTrungBinhMon 
	from dbo.fDiemTB(), MonHoc
	where fDiemTB.MaMon = MonHoc.MaMon
	and DiemTrungBinhMon >= 4
	group by 
		MSV,
		HoTenSV,
		MaLopMH,
		MonHoc.TenMon,
		MonHoc.MaMon,
		MonHoc.TC,
		KyHocTT,
		DiemTrungBinhMon 

GO
/****** Object:  UserDefinedFunction [dbo].[f10_to_4]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[f10_to_4]()
Returns table
AS
Return 
Select
	MSV,
	HoTenSV,
	MonHoc.TenMon,
	MonHoc.MaMon,
	MaLopMH,
	KyHocTT,
	(Case 
		When DiemTrungBinhMon >=8 And DiemTrungBinhMon <=10 then 4.0
		when DiemTrungBinhMon >= 8 and DiemTrungBinhMon < 8.5 then 3.5
		when DiemTrungBinhMon >= 7 and DiemTrungBinhMon < 8 then 3.0
		when DiemTrungBinhMon >= 6.5 and DiemTrungBinhMon <7 then 2.5
		when DiemTrungBinhMon >= 5.5 and DiemTrungBinhMon <6.5 then 2.0
		when DiemTrungBinhMon >= 5.0 and DiemTrungBinhMon <5.5 then 1.5
		when DiemTrungBinhMon >= 4 and DiemTrungBinhMon <5 then 1.0
		when DiemTrungBinhMon < 4 then 0
	end) AS DiemQuyDoi
FROM dbo.fDiemTB() udfDiemTB join MonHoc
on udfDiemTB.MaMon = MonHoc.MaMon

GO
/****** Object:  UserDefinedFunction [dbo].[fGPA]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fGPA]
(
	@KyHocTT int
)
returns table
AS 
return
	select 
		MSV, HoTenSV, KyHocTT,
		ROUND((Sum(DiemQuyDoi*MonHoc.TC)/SUM(MonHoc.TC)),2) AS GPA
	from dbo.f10_to_4() udf10_to_4, MonHoc
	where MonHoc.MaMon = udf10_to_4.MaMon
	And KyHocTT=@KyHocTT
	group by MSV, HoTenSV, KyHocTT
		
GO
/****** Object:  UserDefinedFunction [dbo].[fCPA]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fCPA]()
returns table
as
return 
	select
		MSV, HoTenSV, 
		ROUND((Sum(DiemQuyDoi*MonHoc.TC)/SUM(MonHoc.TC)),2) AS CPA
	from dbo.f10_to_4() udf10_to_4, MonHoc
	where MonHoc.MaMon = udf10_to_4.MaMon
	group by MSV, HoTenSV
GO
/****** Object:  UserDefinedFunction [dbo].[fNumberToText]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fNumberToText]()
returns table
as
return 
	select 
		MSV,
		HoTenSV,
		MaMon,
		TenMon,
		kyHocTT,
	case DiemQuyDoi
		When 4.0 then 'A'
		when 3.5 then 'B+'
			when 3.0 then 'B'
			when 2.5 then 'C+'
			when 2.0 then 'C'
			when 1.5 then 'D+'
			when 1.0 then 'D'
			else 'F'
		end as DiemChu
	from dbo.f10_to_4()

GO
/****** Object:  UserDefinedFunction [dbo].[fUpDateDiemTB]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fUpDateDiemTB]()
returns table 
as
return 
	select 
		fDiemTB.MSV,
		HoTenSV,
		fDiemTB.TenMon,
		fDiemTB.MaMon,
		MonHoc.TC,
		Max(DiemTrungBinhMon) as DiemTBMon
	From
		dbo.fDiemTB(), MonHoc
	where 
		fDiemTB.MaMon = MonHoc.MaMon
	group by fDiemTB.MSV, HoTenSV,fDiemTB.TenMon, fDiemTB.MaMon, MonHoc.TC
GO
/****** Object:  UserDefinedFunction [dbo].[fTruotMon]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fTruotMon]()  
returns Table 
as 
return 
	select * 
	from  dbo.fUpDateDiemTB() 
	where DiemTBMon<4
	
GO
/****** Object:  UserDefinedFunction [dbo].[fTinChiTichLuy]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fTinChiTichLuy] ()
returns table
as
return
	select 
		MSV,
		KyHocTT,
		sum(TC) as TinChiTichLuy
	from dbo.fQuaMon()
	group by MSV, KyHocTT

GO
/****** Object:  UserDefinedFunction [dbo].[fTinChiNo]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[fTinChiNo] ()
returns table
as
return
	select 
		MSV,
		sum(TC) as TinChiNo
	from dbo.fTruotMon()
	group by MSV

GO
/****** Object:  UserDefinedFunction [dbo].[fDiemQT]    Script Date: 6/30/2021 9:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fDiemQT]()
returns table
As
return 
	select
		SINHVIEN.MSV,
		HoTenSV,
		Diem.MaLopMH,
		MonHoc.MaMon,
		TenMon,
		KyHocTT,
		[dbo].[fTinhDiemQT](Diem.DiemGK, Diem.DiemCongQT) as DiemQuaTrinh
	FROM 
		SINHVIEN,
		Diem,
		LopMH,
		MonHoc
	Where SINHVIEN.MSV = Diem.MSV
	AND	   Diem.MaLopMH = LopMH.MaLopMH
	AND	   LopMH.MaMon = MonHoc.MaMon

GO
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (100, N'ME2030')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (100, N'ME2040')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (101, N'ME2030')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (101, N'ME2040')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (102, N'MI1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (102, N'MI1020')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (102, N'MI1030')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (103, N'MI1020')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (103, N'MI1030')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (104, N'MI5000')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (105, N'MI4069')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (105, N'MI5000')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (106, N'IT1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (107, N'IT3112')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (107, N'IT4069')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (108, N'IT4069')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (109, N'EM1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (109, N'EM3170')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (109, N'EM4069')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (110, N'EM1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (110, N'EM3160')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (110, N'EM3210')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (111, N'EM3111')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (111, N'EM3200')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (111, N'EM4069')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (112, N'FL1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (112, N'FL1020')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (113, N'FL1020')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (113, N'FL2010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (114, N'FL2010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (115, N'ET3046')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (115, N'ET3102')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (116, N'ET3130')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (116, N'ET3181')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (117, N'CH1010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (117, N'CH2005')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (118, N'CH3009')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (118, N'CH3070')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (119, N'EE2010')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (120, N'EE3030')
INSERT [dbo].[CTGvMh] ([MaGV], [MaMon]) VALUES (120, N'EE3040')
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'EM1-62', N'Quản lý công nghiệp 62', 109)
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'EM2-64', N'Quản trị kinh doanh 64', 110)
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'IT1-63', N'Công nghệ phần mềm 63', 106)
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'IT2-62', N'Khoa học máy tính 62', 107)
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'MI1-63', N'Toán tin 63', 104)
INSERT [dbo].[CTLopSV] ([MaLopSV], [TenLop], [MaGV]) VALUES (N'MI2-64', N'Hệ thống thông tin quản lý 64', 103)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62170, 1, 2, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62171, 1.5, 2, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62173, 2, 3, 1)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62174, 2, 1.5, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62175, 2, 3, 1)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62176, 1, 3, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62178, 2, 9, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175979, 62179, 0.5, 2, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62170, 2, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62171, 2, 6, 5.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62173, 2, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62174, 1.5, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62175, 2, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62176, 1, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62178, 2, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175980, 62179, 2, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62170, 1, 4.5, 5.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62171, 2, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62173, 2, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62174, 2, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62175, 1, 6, 4.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62176, 1, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62178, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175981, 62179, 2, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62170, 1.5, 5, 1)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62171, 2, 2, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62173, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62174, 1, 6, 0)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62175, 1.5, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62176, 1, 4, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62178, 2, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175983, 62179, 1, 9, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62170, 2, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62171, 2, 6, 4.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62173, 2, 2.5, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62174, 2, 8, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62175, 2, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62176, 1, 4, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62178, 2, 5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 62179, 1.5, 8, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175984, 63183, 2, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62170, 2, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62171, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62173, 2, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62174, 1, 9, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62175, 1, 8, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62176, 1, 4.5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62178, 1, 4, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20175985, 62179, 0, 10, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62170, 2, 8.5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62171, 2, 9.5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62172, 2, 8, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62173, 1, 10, 10)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62175, 2, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176000, 62177, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62170, 2, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62171, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62172, 2, 5, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62173, 1.5, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62175, 1.5, 6, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176001, 62177, 2, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62170, 1, 6, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62171, 2, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62172, 2, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62173, 1, 8.5, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62175, 2, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176003, 62177, 2, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62170, 2, 5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62171, 2, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62172, 2, 5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62173, 2, 9, 5.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62175, 1, 8, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176008, 62177, 2, 8, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62170, 2, 6, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62171, 1.5, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62172, 1, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62173, 1.5, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62175, 1, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176009, 62177, 2, 7, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62170, 1, 8.5, 8.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62171, 2, 8, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62172, 1.5, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62173, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62175, 1, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20176010, 62177, 2, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185986, 63180, 1, 7, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185986, 63181, 1, 7, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185986, 63185, 0.5, 5.5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185986, 63186, 2, 5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185986, 63187, 2, 5, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185987, 63180, 1, 5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185987, 63181, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185987, 63185, 0.5, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185987, 63186, 1, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185987, 63187, 2, 6, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185988, 63180, 2, 7, 2.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185988, 63181, 1, 5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185988, 63185, 0, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185988, 63186, 2, 5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185988, 63187, 1, 7, 6)
GO
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185989, 63180, 1, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185989, 63181, 1, 4, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185989, 63185, 1, 3, 5.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185989, 63186, 1, 2, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185989, 63187, 1.5, 6, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63180, 1.5, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63181, 1, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63183, 2, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63185, 0.5, 5, 6.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63186, 1, 5, 3.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185991, 63187, 1, 5, 9.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63180, 1, 4, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63182, 2, 5, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63183, 1, 5.5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63184, 2, 7, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63186, 0.5, 2, 1)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185993, 63188, 0.5, 8, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63180, 2, 5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63182, 2, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63183, 2, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63184, 1, 8, 9.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63186, 0.5, 4.5, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185994, 63188, 0, 5, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185995, 63181, 1, 5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185995, 63182, 2, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185995, 63184, 1, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185995, 63187, 2, 5.5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185995, 63188, 0.5, 8, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63180, 1, 6, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63182, 2, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63183, 2, 5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63184, 1, 7.7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63187, 2, 4.5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185996, 63188, 0, 6, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63180, 0.5, 6, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63181, 1, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63183, 1.5, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63185, 1, 6, 4.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63186, 1, 6, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185997, 63187, 1, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185998, 63181, 1, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185998, 63182, 2, 4, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185998, 63184, 1, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185998, 63187, 2, 4, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185998, 63188, 1, 7, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185999, 63181, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185999, 63182, 2, 2, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185999, 63184, 1.5, 2.5, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185999, 63187, 1, 0.5, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20185999, 63188, 1, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63180, 0, 3, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63181, 1, 4, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63183, 1, 4, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63185, 1, 2, 6.6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63186, 1, 7, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186004, 63187, 1, 3.5, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63180, 1, 4, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63182, 2, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63183, 0.5, 5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63184, 2, 6, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63186, 1.5, 5, 3.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186005, 63188, 1, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63180, 2, 3, 2)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63182, 2, 4, 3)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63183, 0, 4.5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63184, 1, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63186, 2, 6, 2.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186006, 63188, 1, 8, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186007, 63181, 1, 6, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186007, 63182, 2, 3, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186007, 63184, 2, 8, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186007, 63187, 1, 0, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20186007, 63188, 1, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20190111, 64190, 1, 4, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20190111, 64192, 1, 5, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195946, 64190, 1, 5, 4)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195946, 64192, 1, 4, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195947, 64190, 2, 2.5, 4.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195947, 64192, 2, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195949, 64190, 2, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195949, 64192, 2, 7, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195950, 64191, 1, 5.5, 7)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195950, 64192, 2, 8, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195951, 64191, 1.5, 4, 5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195951, 64192, 2, 7, 8)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195952, 64191, 1.5, 5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195952, 64192, 1, 9, 9)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195953, 64191, 0.5, 6, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195953, 64192, 2, 9.5, 6)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195960, 64191, 1, 7, 7.5)
INSERT [dbo].[Diem] ([MSV], [MaLopMH], [DiemCongQT], [DiemCK], [DiemGK]) VALUES (20195960, 64192, 2, 0, 5)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175979, 20171, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175979, 20172, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175979, 20181, 94)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175979, 20182, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175980, 20171, 34)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175980, 20172, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175980, 20181, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175980, 20182, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175981, 20171, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175981, 20172, 34)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175981, 20181, 78)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175981, 20182, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175983, 20171, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175983, 20172, 74)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175983, 20181, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175983, 20182, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175984, 20171, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175984, 20172, 83)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175984, 20181, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175984, 20182, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175985, 20171, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175985, 20172, 92)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175985, 20181, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20175985, 20182, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176000, 20171, 78)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176000, 20172, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176000, 20181, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176000, 20182, 94)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176001, 20171, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176001, 20172, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176001, 20181, 89)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176001, 20182, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176003, 20171, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176003, 20172, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176003, 20181, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176003, 20182, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176008, 20171, 78)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176008, 20172, 54)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176008, 20181, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176008, 20182, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176009, 20171, 89)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176009, 20172, 78)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176009, 20181, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176009, 20182, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176010, 20171, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176010, 20172, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176010, 20181, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20176010, 20182, 34)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185986, 20181, 50)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185986, 20182, 57)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185986, 20191, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185987, 20181, 43)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185987, 20182, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185987, 20191, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185988, 20181, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185988, 20182, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185988, 20191, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185989, 20181, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185989, 20182, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185989, 20191, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185991, 20181, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185991, 20182, 99)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185991, 20191, 100)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185993, 20181, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185993, 20182, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185993, 20191, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185994, 20181, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185994, 20182, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185994, 20191, 89)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185995, 20181, 80)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185995, 20182, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185995, 20191, 80)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185996, 20181, 88)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185996, 20182, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185996, 20191, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185997, 20181, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185997, 20182, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185997, 20191, 90)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185998, 20181, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185998, 20182, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185998, 20191, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185999, 20181, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185999, 20182, 78)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20185999, 20191, 54)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186004, 20181, 100)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186004, 20182, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186004, 20191, 89)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186005, 20181, 46)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186005, 20182, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186005, 20191, 76)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186006, 20181, 57)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186006, 20182, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186006, 20191, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186007, 20181, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186007, 20182, 43)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20186007, 20191, 32)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20190111, 20191, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195946, 20191, 98)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195947, 20191, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195948, 20191, 87)
GO
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195949, 20191, 87)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195950, 20191, 67)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195951, 20191, 56)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195952, 20191, 45)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195953, 20191, 65)
INSERT [dbo].[DiemRL] ([MSV], [KyHocTT], [DiemRL]) VALUES (20195960, 20191, 76)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175979, 20182, 880)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175980, 20182, 990)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175981, 20182, 654)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175983, 20182, 870)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175984, 20182, 360)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20175985, 20182, 870)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176000, 20181, 456)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176001, 20181, 530)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176003, 20181, 650)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176008, 20181, 320)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176008, 20182, 550)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176009, 20181, 345)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176009, 20182, 455)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20176010, 20181, 360)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185986, 20191, 320)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185987, 20191, 670)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185988, 20191, 980)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185989, 20191, 890)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185991, 20191, 900)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185993, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185994, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185995, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185996, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185997, 20191, 915)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185998, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20185999, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20186004, 20191, 540)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20186005, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20186006, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20186007, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20190111, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195946, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195947, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195948, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195949, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195950, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195951, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195952, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195953, 20191, NULL)
INSERT [dbo].[DiemTA] ([MSV], [KyHocTT], [DiemTA]) VALUES (20195960, 20191, NULL)
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (100, N'Trương Hoành Sơn', N'Phó giáo Sư - Tiến sĩ', N'ME', N'Công nghệ chế tạo máy')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (101, N'Nguyễn Thị Thu Nga', N'Thạc sĩ', N'ME', N'Cơ ứng dụng')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (102, N'Trịnh Ngọc Hải', N'Tiến sĩ', N'MI', N'Toán cơ bản')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (103, N'Nguyễn Thị Thu Hương', N'Tiến sĩ', N'MI', N'Toán ứng dụng')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (104, N'Bùi xuân Diệu', N'Tiến sĩ', N'MI', N'Toán tin ứng dụng')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (105, N'Vương Mai Phương', N'Tiến sĩ', N'MI', N'Toán tin ứng dụng')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (106, N'Vũ Thị Hương Giang', N'Tiến sĩ', N'IT', N'Công nghệ phần mềm')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (107, N'Nguyễn Bình Minh', N'Tiến sĩ', N'IT', N'Hệ thống thông tin')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (108, N'Phạm Hải Đăng', N'Tiến sĩ', N'IT', N'Khoa học máy tính')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (109, N'Nguyễn Đức Trọng', N'Tiến sĩ', N'EM', N'Hành vi của tổ chức')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (110, N'Nguyễn Hải Anh', N'Thạc sĩ', N'EM', N'Quản trị học')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (111, N'Nguyễn Thu Hằng', N'Tiến sĩ', N'EM', N'Kinh tế học')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (112, N'Đậu Thị Lê Hiếu', N'Tiến sĩ', N'FL', N'Tiếng Anh chuyên nghiệp')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (113, N'Nguyễn Thị Kim Oanh', N'Thạc sĩ', N'FL', N'Tiếng Anh kỹ thuật')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (114, N'Nguyễn Thanh Mai', N'Tiến sĩ', N'FL', N'Tiếng Anh Hóa - Môi trường')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (115, N'Nguyễn Xuân Dũng', N'Phó giáo Sư - Tiến sĩ', N'ET', N'Kỹ thuật thông tin')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (116, N'Trương Thu Hương', N'Tiến sĩ', N'ET', N'Điện tử và kỹ thuật máy tính')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (117, N'Hoàng Trọng Yêm', N'Phó giáo Sư - Tiến sĩ', N'CH', N'Hóa hữu cơ')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (118, N'Mai Văn Thanh', N'Tiến sĩ', N'CH', N'Hóa phân tích')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (119, N'Lê Thị Minh Châu', N'Tiến sĩ', N'EE', N'Hệ thống điện')
INSERT [dbo].[GiangVien] ([MaGV], [HoTenGV], [HocVi], [MaVien], [ChuyenNganhGV]) VALUES (120, N'Ngô Văn Quyền', N'Thạc sĩ', N'EE', N'Thiết bị điện - điện tử')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (1, 20195947, CAST(N'2019-06-25' AS Date), N'In Bảng điểm cá nhân
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (2, 20186006, CAST(N'2019-04-04' AS Date), N'In bảng điểm tiếng Anh
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (3, 20185993, CAST(N'2019-05-07' AS Date), N'In Bảng điểm cá nhân
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (4, 20185994, CAST(N'2019-05-07' AS Date), N'In Bảng điểm cá nhân
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (5, 20186004, CAST(N'2018-12-12' AS Date), N'In bảng điểm tiếng Anh
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (6, 20186005, CAST(N'2018-01-03' AS Date), N'In thông tin sinh viên
')
INSERT [dbo].[InDiem] ([MaPhieu], [MSV], [NgayIn], [NDIn]) VALUES (7, 20176009, CAST(N'2018-04-06' AS Date), N'In thông tin sinh viên
')
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62170, N'MI1010', 102, 20171)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62171, N'EM1010', 109, 20171)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62172, N'IT1010', 106, 20172)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62173, N'FL1020', 112, 20172)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62174, N'MI1020', 102, 20172)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62175, N'FL2010', 113, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62176, N'ME2040', 100, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62177, N'EM3160', 110, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62178, N'EE2010', 119, 20182)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62179, N'EE3030', 120, 20182)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62180, N'EM3170', 109, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62181, N'EM3111', 111, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (62182, N'ET3130', 116, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63180, N'MI1010', 102, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63181, N'MI1030', 103, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63182, N'FL1010', 112, 20181)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63183, N'FL1020', 113, 20182)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63184, N'IT1010', 106, 20182)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63185, N'MI1020', 103, 20182)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63186, N'FL2010', 114, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63187, N'EM3160', 110, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (63188, N'ME2040', 101, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (64190, N'MI1010', 102, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (64191, N'EM1010', 109, 20191)
INSERT [dbo].[LopMH] ([MaLopMH], [MaMon], [MGV], [KyHocTT]) VALUES (64192, N'FL1010', 112, 20191)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175979)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175980)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175981)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175983)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175984)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM1-62', 20175985)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM2-64', 20195950)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM2-64', 20195951)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM2-64', 20195952)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM2-64', 20195953)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'EM2-64', 20195960)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185993)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185994)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185995)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185996)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185998)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20185999)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20186005)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20186006)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT1-63', 20186007)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176000)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176001)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176003)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176008)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176009)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'IT2-62', 20176010)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185986)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185987)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185988)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185989)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185991)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20185997)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI1-63', 20186004)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI2-64', 20190111)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI2-64', 20195946)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI2-64', 20195947)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI2-64', 20195948)
INSERT [dbo].[LopSV] ([MaLopSV], [MSV]) VALUES (N'MI2-64', 20195949)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'CH1010', N'Hoá học đại cương', 3, 1)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'CH2005', N'Thực tập Nhập môn Kỹ thuật in và truyền thông', 3, 4)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'CH3009', N'Hóa học trong CN in', 2, 6)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'CH3070', N'Hóa lý', 3, 7)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EE2010', N'Kỹ thuật điện', 3, 5)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EE3030', N'Lý thuyết trường điện từ', 2, 5)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EE3040', N'An toàn điện', 3, 6)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM1010', N'Quản trị học đại cương', 3, 1)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM3111', N'Đồ án 1', 5, 6)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM3160', N'Tâm lý trong quản lý', 2, 4)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM3170', N'Văn hóa kinh doanh', 2, 5)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM3200', N'Quản trị doanh nghiệp', 3, 6)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM3210', N'Đồ án 2', 5, 7)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'EM4069', N'Thực tập doanh nghiệp', 4, 8)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ET3046', N'Cơ sinh ', 3, 5)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ET3102', N'Kỹ thuật điện tử', 4, 7)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ET3130', N'Thông tin số', 3, 7)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ET3181', N'Thông tin vô tuyến', 3, 6)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'FL1010', N'Tiếng Anh I', 4, 1)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'FL1020', N'Tiếng Anh II', 4, 2)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'FL2010', N'Tiếng Anh KHKT', 3, 3)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'IT1010', N'Tin Học đại cương', 4, 2)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'IT3112', N'Hạ tầng công nghệ thông tin mã nguồn mở', 3, 8)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'IT4069', N'Thực tập kỹ thuật', 4, 8)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ME2030', N'Cơ khí đại cương', 3, 4)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'ME2040', N'Cơ học kỹ thuật', 3, 3)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'MI1010', N'Giải tích I', 4, 1)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'MI1020', N'Giải tích II', 3, 2)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'MI1030', N'Đại số', 4, 1)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'MI4069', N'Thực tập kỹ thuật Hệ thống', 4, 8)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [TC], [KyHocDK]) VALUES (N'MI5000', N'Đồ án tốt nghiệp', 8, 8)
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175979, N'Nguyễn Hoàng Long', 62, N'Nam', CAST(N'1999-02-02' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175980, N'Hoàng Thanh Mai', 62, N'Nữ', CAST(N'1999-08-16' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175981, N'Trần Thị Hoa Mỹ', 62, N'Nữ', CAST(N'1999-06-22' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175983, N'Đào Thị Phương Nga', 62, N'Nữ', CAST(N'1999-08-15' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175984, N'Kiều Thị Kim Ngân', 62, N'Nữ', CAST(N'1999-05-08' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20175985, N'Vũ Trọng Nghĩa', 62, N'Nam', CAST(N'1999-02-13' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176000, N'Lê Thị Hồng Trang', 62, N'Nữ', CAST(N'1999-01-27' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176001, N'Lê Thu Trang', 62, N'Nữ', CAST(N'1999-08-10' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176003, N'Trịnh Xuân Trường', 62, N'Nam', CAST(N'1999-02-16' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176008, N'Hoàng Tiến Việt', 62, N'Nam', CAST(N'1999-04-01' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176009, N'Chu Thị Vy', 62, N'Nữ', CAST(N'1999-06-21' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20176010, N'Đoàn Lê Tường Vy', 62, N'Nữ', CAST(N'1999-10-20' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185986, N'Phạm Thanh Nhã', 63, N'Nữ', NULL, N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185987, N'Nguyễn Văn Quân', 63, N'Nam', CAST(N'2000-02-03' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185988, N'Chu Hồng Quý', 63, N'Nam', CAST(N'2000-11-23' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185989, N'Vũ Phong Quý', 63, N'Nam', CAST(N'2000-09-22' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185991, N'Phạm Xuân Sang', 63, N'Nam', CAST(N'2000-01-24' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185993, N'Nguyễn Đình Thái', 63, N'Nam', CAST(N'2000-05-19' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185994, N'Đặng Thị Hồng Thu', 63, N'Nữ', CAST(N'2000-06-24' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185995, N'Đỗ Xuân Thưởng', 63, N'Nam', CAST(N'2000-04-19' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185996, N'Nguyễn Thị Thu Thủy', 63, N'Nữ', CAST(N'2000-01-25' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185997, N'Vũ Mạnh Tiền', 63, N'Nam', CAST(N'2000-07-31' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185998, N'Nguyễn Thị Thanh Trà', 63, N'Nữ', CAST(N'2000-09-02' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20185999, N'Đỗ Thị Trang', 63, N'Nữ', CAST(N'2000-07-08' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20186004, N'Nguyễn Minh Tú', 63, N'Nam', CAST(N'2000-02-18' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20186005, N'Đoàn Minh Tuấn', 63, N'Nam', CAST(N'2000-05-21' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20186006, N'Ngô Quang Tùng', 63, N'Nam', CAST(N'2000-03-24' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20186007, N'Hà Huyền Vi', 63, N'Nữ', CAST(N'2000-05-19' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20190111, N'Đoàn Minh Bảo', 64, N'Nam', CAST(N'2001-06-04' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195946, N'Giang Thế An', 64, N'Nam', CAST(N'2001-09-22' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195947, N'Đặng Minh Anh', 64, N'Nữ', CAST(N'2001-12-06' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195948, N'Nguyễn Quỳnh Anh', 64, N'Nữ', CAST(N'2001-04-14' AS Date), N'Hà Nội', N'Thôi học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195949, N'Nguyễn Vân Anh', 64, N'Nữ', CAST(N'2001-05-23' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195950, N'Hoàng Thanh Bình', 64, N'Nữ', CAST(N'2001-05-15' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195951, N'Nguyễn Minh Châu', 64, N'Nam', CAST(N'2001-08-11' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195952, N'Bùi Thị Lan Chi', 64, N'Nữ', CAST(N'2001-01-02' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195953, N'Nguyễn Tiến Chung', 64, N'Nam', CAST(N'2001-08-01' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[SINHVIEN] ([MSV], [HoTenSV], [KhoaHoc], [GioiTinh], [NgaySinh], [QueQuan], [TrangThai]) VALUES (20195960, N'Bùi Văn Duy', 64, N'Nam', CAST(N'2001-12-13' AS Date), N'Hà Nội', N'Học')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'CH', N'Viện kỹ thuật Hóa học', N'C7')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'EE', N'Viện Điện', N'C10')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'EM', N'Viện Kinh tế và Quản lý', N'C9')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'ET', N'Viện Điện tử - Viện thông', N'B2')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'FL', N'Viện Ngoại Ngữ', N'D4')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'IT', N'Viện Công nghệ Thông tin và Truyền thông', N'B1')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'ME', N'Viện Cơ Khí', N'D1')
INSERT [dbo].[Vien] ([MaVien], [TenVien], [DiaChi]) VALUES (N'MI', N'Viện Toán ứng dụng và Tin học', N'D3')
ALTER TABLE [dbo].[CTGvMh]  WITH CHECK ADD  CONSTRAINT [FK_CTGvMh_GiangVien] FOREIGN KEY([MaGV])
REFERENCES [dbo].[GiangVien] ([MaGV])
GO
ALTER TABLE [dbo].[CTGvMh] CHECK CONSTRAINT [FK_CTGvMh_GiangVien]
GO
ALTER TABLE [dbo].[CTGvMh]  WITH CHECK ADD  CONSTRAINT [FK_CTGvMh_MonHoc] FOREIGN KEY([MaMon])
REFERENCES [dbo].[MonHoc] ([MaMon])
GO
ALTER TABLE [dbo].[CTGvMh] CHECK CONSTRAINT [FK_CTGvMh_MonHoc]
GO
ALTER TABLE [dbo].[CTLopSV]  WITH CHECK ADD  CONSTRAINT [FK_CTLopSV_GiangVien] FOREIGN KEY([MaGV])
REFERENCES [dbo].[GiangVien] ([MaGV])
GO
ALTER TABLE [dbo].[CTLopSV] CHECK CONSTRAINT [FK_CTLopSV_GiangVien]
GO
ALTER TABLE [dbo].[Diem]  WITH CHECK ADD  CONSTRAINT [FK_Diem_LopMH] FOREIGN KEY([MaLopMH])
REFERENCES [dbo].[LopMH] ([MaLopMH])
GO
ALTER TABLE [dbo].[Diem] CHECK CONSTRAINT [FK_Diem_LopMH]
GO
ALTER TABLE [dbo].[Diem]  WITH CHECK ADD  CONSTRAINT [FK_Diem_SINHVIEN] FOREIGN KEY([MSV])
REFERENCES [dbo].[SINHVIEN] ([MSV])
GO
ALTER TABLE [dbo].[Diem] CHECK CONSTRAINT [FK_Diem_SINHVIEN]
GO
ALTER TABLE [dbo].[DiemRL]  WITH CHECK ADD  CONSTRAINT [FK_DiemRL_SINHVIEN] FOREIGN KEY([MSV])
REFERENCES [dbo].[SINHVIEN] ([MSV])
GO
ALTER TABLE [dbo].[DiemRL] CHECK CONSTRAINT [FK_DiemRL_SINHVIEN]
GO
ALTER TABLE [dbo].[DiemTA]  WITH CHECK ADD  CONSTRAINT [FK_DiemTA_SINHVIEN] FOREIGN KEY([MSV])
REFERENCES [dbo].[SINHVIEN] ([MSV])
GO
ALTER TABLE [dbo].[DiemTA] CHECK CONSTRAINT [FK_DiemTA_SINHVIEN]
GO
ALTER TABLE [dbo].[GiangVien]  WITH CHECK ADD  CONSTRAINT [FK_GiangVien_Vien] FOREIGN KEY([MaVien])
REFERENCES [dbo].[Vien] ([MaVien])
GO
ALTER TABLE [dbo].[GiangVien] CHECK CONSTRAINT [FK_GiangVien_Vien]
GO
ALTER TABLE [dbo].[InDiem]  WITH CHECK ADD  CONSTRAINT [FK_InDiem_SINHVIEN1] FOREIGN KEY([MSV])
REFERENCES [dbo].[SINHVIEN] ([MSV])
GO
ALTER TABLE [dbo].[InDiem] CHECK CONSTRAINT [FK_InDiem_SINHVIEN1]
GO
ALTER TABLE [dbo].[LopMH]  WITH CHECK ADD  CONSTRAINT [FK_LopMH_GiangVien] FOREIGN KEY([MGV])
REFERENCES [dbo].[GiangVien] ([MaGV])
GO
ALTER TABLE [dbo].[LopMH] CHECK CONSTRAINT [FK_LopMH_GiangVien]
GO
ALTER TABLE [dbo].[LopMH]  WITH CHECK ADD  CONSTRAINT [FK_LopMH_MonHoc] FOREIGN KEY([MaMon])
REFERENCES [dbo].[MonHoc] ([MaMon])
GO
ALTER TABLE [dbo].[LopMH] CHECK CONSTRAINT [FK_LopMH_MonHoc]
GO
ALTER TABLE [dbo].[LopSV]  WITH CHECK ADD  CONSTRAINT [FK_LopSV_CTLopSV] FOREIGN KEY([MaLopSV])
REFERENCES [dbo].[CTLopSV] ([MaLopSV])
GO
ALTER TABLE [dbo].[LopSV] CHECK CONSTRAINT [FK_LopSV_CTLopSV]
GO
ALTER TABLE [dbo].[LopSV]  WITH CHECK ADD  CONSTRAINT [FK_LopSV_SINHVIEN] FOREIGN KEY([MSV])
REFERENCES [dbo].[SINHVIEN] ([MSV])
GO
ALTER TABLE [dbo].[LopSV] CHECK CONSTRAINT [FK_LopSV_SINHVIEN]
GO
USE [master]
GO
ALTER DATABASE [QUANLYDIEM] SET  READ_WRITE 
GO

USE [master]
GO
/****** Object:  Database [NotesMarketPlace]    Script Date: 10-04-2021 18:28:41 ******/
CREATE DATABASE [NotesMarketPlace]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NotesMarketPlace', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\NotesMarketPlace.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NotesMarketPlace_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\NotesMarketPlace_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [NotesMarketPlace] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NotesMarketPlace].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NotesMarketPlace] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET ARITHABORT OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NotesMarketPlace] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NotesMarketPlace] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET  DISABLE_BROKER 
GO
ALTER DATABASE [NotesMarketPlace] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NotesMarketPlace] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET RECOVERY FULL 
GO
ALTER DATABASE [NotesMarketPlace] SET  MULTI_USER 
GO
ALTER DATABASE [NotesMarketPlace] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NotesMarketPlace] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NotesMarketPlace] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NotesMarketPlace] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NotesMarketPlace] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NotesMarketPlace] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'NotesMarketPlace', N'ON'
GO
ALTER DATABASE [NotesMarketPlace] SET QUERY_STORE = OFF
GO
USE [NotesMarketPlace]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[CountryCode] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Downloads]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Downloads](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Seller] [int] NOT NULL,
	[Downloader] [int] NOT NULL,
	[IsSellerHasAllowedDownload] [bit] NOT NULL,
	[AttachmentPath] [varchar](max) NULL,
	[IsAttachmentDownloaded] [bit] NOT NULL,
	[AttachmentDownloadedDate] [datetime] NULL,
	[IsPaid] [int] NOT NULL,
	[PurchasedPrice] [decimal](18, 0) NULL,
	[NoteTitle] [varchar](100) NOT NULL,
	[NoteCategory] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Downloads] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoteCategories]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoteCategories](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_NoteCategories] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoteTypes]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoteTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_NoteTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paid]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paid](
	[ID] [int] NOT NULL,
	[PaidType] [varchar](50) NULL,
 CONSTRAINT [PK_Paid] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReferenceData]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReferenceData](
	[ID] [int] NOT NULL,
	[Value] [varchar](100) NOT NULL,
	[DataValue] [varchar](100) NOT NULL,
	[RefCategory] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ReferenceData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotes]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SellerNotes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SellerID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[ActionedBy] [int] NULL,
	[AdminRemark] [varchar](max) NULL,
	[PublishedDate] [datetime] NULL,
	[Title] [varchar](100) NOT NULL,
	[Category] [int] NOT NULL,
	[DisplayPicture] [varchar](500) NULL,
	[NoteType] [int] NULL,
	[NumberOfPages] [int] NULL,
	[Description] [varchar](max) NOT NULL,
	[UniversityName] [varchar](200) NULL,
	[Country] [int] NULL,
	[Course] [varchar](100) NULL,
	[CourseCode] [varchar](100) NULL,
	[Professor] [varchar](100) NULL,
	[IsPaid] [int] NOT NULL,
	[SellingPrice] [decimal](18, 0) NULL,
	[NotesPreview] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SellerNotes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesAttachements]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SellerNotesAttachements](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[FileName] [varchar](100) NOT NULL,
	[FilePath] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SellerNotesAttachements] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesReportedIssues]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SellerNotesReportedIssues](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[ReportedByID] [int] NOT NULL,
	[AgainstDownloadID] [int] NOT NULL,
	[Remarks] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_SellerNotesReportedIssues] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesReviews]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SellerNotesReviews](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[ReviewedByID] [int] NOT NULL,
	[AgainstDownloadsID] [int] NOT NULL,
	[Ratings] [decimal](18, 0) NOT NULL,
	[Comments] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SellerNotesReviews] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemConfiguration]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemConfiguration](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](100) NOT NULL,
	[Value] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SystemConfiguration] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfile](
	[ID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DOB] [datetime] NULL,
	[Gender] [int] NULL,
	[SecondaryEmailAddress] [varchar](100) NULL,
	[PhoneNumberCountryCode] [varchar](5) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[ProfilePicture] [varchar](500) NULL,
	[AddressLine1] [varchar](100) NOT NULL,
	[AddressLine2] [varchar](100) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[ZipCode] [varchar](50) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[University] [varchar](100) NULL,
	[College] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10-04-2021 18:28:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[EmailID] [varchar](100) NOT NULL,
	[Password] [varchar](24) NOT NULL,
	[IsEmailVerified] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[ActivationCode] [varchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Countries] ON 

INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'India', N'91', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'USA', N'43', NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (5, N'CANADA', N'c5845', CAST(N'2021-04-01T19:13:25.040' AS DateTime), 1033, CAST(N'2021-04-10T11:03:22.137' AS DateTime), 1038, 1)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (6, N'LONDON', N'543', CAST(N'2021-04-05T21:23:01.827' AS DateTime), 1038, CAST(N'2021-04-05T21:23:01.827' AS DateTime), 1038, 1)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (7, N'POLAND', N'r43', CAST(N'2021-04-05T21:44:07.990' AS DateTime), 1038, CAST(N'2021-04-05T21:44:26.157' AS DateTime), 1038, 0)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (8, N'russia', N'5845f', CAST(N'2021-04-07T14:43:56.540' AS DateTime), 1038, CAST(N'2021-04-07T14:44:10.640' AS DateTime), 1038, 0)
SET IDENTITY_INSERT [dbo].[Countries] OFF
GO
SET IDENTITY_INSERT [dbo].[Downloads] ON 

INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (69, 92, 1030, 1031, 1, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-04-10T09:42:22.530' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:41:47.617' AS DateTime), 1031, CAST(N'2021-03-27T13:41:47.617' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (70, 97, 1030, 1031, 1, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-04-09T23:26:58.710' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:42:07.550' AS DateTime), 1031, CAST(N'2021-03-27T13:42:07.550' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (71, 100, 1032, 1031, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:42:25.357' AS DateTime), 1031, CAST(N'2021-03-27T13:42:25.357' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (72, 101, 1032, 1031, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:42:39.257' AS DateTime), 1031, CAST(N'2021-03-27T13:42:39.257' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (73, 102, 1032, 1031, 0, N'~/UserFile/FileName/engineering graphics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(210 AS Decimal(18, 0)), N'engineering graphics', N'CA', CAST(N'2021-03-27T13:42:57.730' AS DateTime), 1031, CAST(N'2021-03-27T13:42:57.730' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (74, 103, 1032, 1031, 0, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:43:20.297' AS DateTime), 1031, CAST(N'2021-03-27T13:43:20.297' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (75, 104, 1032, 1031, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:43:31.353' AS DateTime), 1031, CAST(N'2021-03-27T13:43:31.353' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (76, 105, 1032, 1031, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:43:43.263' AS DateTime), 1031, CAST(N'2021-03-27T13:43:43.263' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (77, 106, 1032, 1031, 1, N'~/UserFile/FileName/Automatic Control Systems.pdf', 0, CAST(N'2021-03-27T14:31:44.483' AS DateTime), 1, CAST(240 AS Decimal(18, 0)), N'Automatic Control Systems', N'IT', CAST(N'2021-03-27T13:44:02.847' AS DateTime), 1031, CAST(N'2021-03-27T13:44:02.847' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (78, 107, 1032, 1031, 0, N'~/UserFile/FileName/Control Systems Engineering.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(120 AS Decimal(18, 0)), N'Control Systems Engineering', N'CS', CAST(N'2021-03-27T13:45:02.510' AS DateTime), 1031, CAST(N'2021-03-27T13:45:02.510' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (79, 108, 1032, 1031, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:45:16.883' AS DateTime), 1031, CAST(N'2021-03-27T13:45:16.883' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (80, 109, 1032, 1031, 0, N'~/UserFile/FileName/calculas.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(65 AS Decimal(18, 0)), N'calculas', N'CA', CAST(N'2021-03-27T13:45:36.583' AS DateTime), 1031, CAST(N'2021-03-27T13:45:36.583' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (81, 110, 1032, 1031, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-03-27T13:46:01.743' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:46:01.767' AS DateTime), 1031, CAST(N'2021-03-27T13:46:01.767' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (82, 82, 1031, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:46:50.447' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:46:50.450' AS DateTime), 1030, CAST(N'2021-03-27T13:46:50.450' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (83, 83, 1031, 1030, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:46:55.830' AS DateTime), 1030, CAST(N'2021-03-27T13:46:55.830' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (84, 86, 1031, 1030, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:47:06.553' AS DateTime), 1030, CAST(N'2021-03-27T13:47:06.553' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (85, 88, 1031, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-10T10:02:41.373' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:47:17.300' AS DateTime), 1030, CAST(N'2021-03-27T13:47:17.300' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (86, 89, 1031, 1030, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:47:24.520' AS DateTime), 1030, CAST(N'2021-03-27T13:47:24.520' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (87, 90, 1031, 1030, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:47:37.517' AS DateTime), 1030, CAST(N'2021-03-27T13:47:37.517' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (88, 100, 1032, 1030, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:47:53.897' AS DateTime), 1030, CAST(N'2021-03-27T13:47:53.897' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (89, 101, 1032, 1030, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:48:05.060' AS DateTime), 1030, CAST(N'2021-03-27T13:48:05.060' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (90, 102, 1032, 1030, 0, N'~/UserFile/FileName/engineering graphics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(210 AS Decimal(18, 0)), N'engineering graphics', N'CA', CAST(N'2021-03-27T13:48:17.277' AS DateTime), 1030, CAST(N'2021-03-27T13:48:17.277' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (91, 103, 1032, 1030, 0, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:48:32.060' AS DateTime), 1030, CAST(N'2021-03-27T13:48:32.060' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (92, 104, 1032, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:48:45.493' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:48:45.497' AS DateTime), 1030, CAST(N'2021-03-27T13:48:45.497' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (93, 105, 1032, 1030, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:48:54.317' AS DateTime), 1030, CAST(N'2021-03-27T13:48:54.317' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (95, 107, 1032, 1030, 0, N'~/UserFile/FileName/Control Systems Engineering.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(120 AS Decimal(18, 0)), N'Control Systems Engineering', N'CS', CAST(N'2021-03-27T13:49:24.427' AS DateTime), 1030, CAST(N'2021-03-27T13:49:24.427' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (96, 108, 1032, 1030, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:49:41.813' AS DateTime), 1030, CAST(N'2021-03-27T13:49:41.813' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (97, 109, 1032, 1030, 0, N'~/UserFile/FileName/calculas.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(65 AS Decimal(18, 0)), N'calculas', N'CA', CAST(N'2021-03-27T13:50:09.043' AS DateTime), 1030, CAST(N'2021-03-27T13:50:09.043' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (98, 110, 1032, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-10T02:43:12.590' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:50:24.033' AS DateTime), 1030, CAST(N'2021-03-27T13:50:24.033' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (99, 82, 1031, 1032, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:52:21.460' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:52:21.460' AS DateTime), 1032, CAST(N'2021-03-27T13:52:21.460' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (100, 83, 1031, 1032, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:52:26.717' AS DateTime), 1032, CAST(N'2021-03-27T13:52:26.717' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (101, 86, 1031, 1032, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:52:39.953' AS DateTime), 1032, CAST(N'2021-03-27T13:52:39.953' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (102, 88, 1031, 1032, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-03-27T13:52:50.663' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:52:50.663' AS DateTime), 1032, CAST(N'2021-03-27T13:52:50.663' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (103, 89, 1031, 1032, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:52:59.677' AS DateTime), 1032, CAST(N'2021-03-27T13:52:59.677' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (104, 90, 1031, 1032, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:53:11.993' AS DateTime), 1032, CAST(N'2021-03-27T13:53:11.993' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (105, 92, 1030, 1032, 1, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:53:24.793' AS DateTime), 1032, CAST(N'2021-03-27T13:53:24.793' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (106, 97, 1030, 1032, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:53:36.400' AS DateTime), 1032, CAST(N'2021-03-27T13:53:36.400' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (108, 82, 1031, 1032, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T14:33:20.797' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T14:33:20.833' AS DateTime), 1032, CAST(N'2021-03-27T14:33:20.833' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (111, 96, 1030, 1030, 1, N'~/UserFile/FileName/Control Systems Engineering.pdf', 0, CAST(N'2021-04-09T14:49:59.483' AS DateTime), 1, CAST(120 AS Decimal(18, 0)), N'Control Systems Engineering', N'CS', CAST(N'2021-04-09T14:46:22.017' AS DateTime), 1030, CAST(N'2021-04-09T14:46:22.017' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (113, 82, 1031, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-04-09T14:53:16.423' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-04-09T14:53:16.427' AS DateTime), 1030, CAST(N'2021-04-09T14:53:16.427' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (114, 82, 1031, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-04-09T16:32:08.643' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-04-09T16:32:08.647' AS DateTime), 1030, CAST(N'2021-04-09T16:32:08.647' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (116, 88, 1031, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-09T16:54:29.953' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-04-09T16:54:29.953' AS DateTime), 1030, CAST(N'2021-04-09T16:54:29.953' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (117, 110, 1032, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-09T16:54:58.673' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-04-09T16:54:58.673' AS DateTime), 1030, CAST(N'2021-04-09T16:54:58.673' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (118, 106, 1032, 1030, 0, N'~/UserFile/FileName/Automatic Control Systems.pdf', 0, CAST(N'2021-04-09T16:58:27.220' AS DateTime), 1, CAST(240 AS Decimal(18, 0)), N'Automatic Control Systems', N'IT', CAST(N'2021-04-09T16:58:27.227' AS DateTime), 1030, CAST(N'2021-04-09T16:58:27.227' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (119, 97, 1030, 1030, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-04-09T17:55:21.137' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-04-09T17:55:21.137' AS DateTime), 1030, CAST(N'2021-04-09T17:55:21.137' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (120, 110, 1032, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-09T23:30:19.470' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-04-09T23:30:19.473' AS DateTime), 1030, CAST(N'2021-04-09T23:30:19.473' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (121, 110, 1032, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-04-09T23:33:33.570' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-04-09T23:33:33.573' AS DateTime), 1030, CAST(N'2021-04-09T23:33:33.573' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (122, 82, 1031, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-04-10T09:32:26.887' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-04-10T09:32:26.890' AS DateTime), 1030, CAST(N'2021-04-10T09:32:26.890' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (123, 80, 1031, 1030, 0, N'~/UserFile/FileName/engineering graphics.pdf', 0, CAST(N'2021-04-10T09:37:16.623' AS DateTime), 1, CAST(210 AS Decimal(18, 0)), N'engineering graphics', N'CA', CAST(N'2021-04-10T09:37:16.627' AS DateTime), 1030, CAST(N'2021-04-10T09:37:16.627' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (124, 82, 1031, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-04-10T09:37:40.130' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-04-10T09:37:40.133' AS DateTime), 1030, CAST(N'2021-04-10T09:37:40.133' AS DateTime), 1030)
SET IDENTITY_INSERT [dbo].[Downloads] OFF
GO
SET IDENTITY_INSERT [dbo].[NoteCategories] ON 

INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1, N'IT', N'abcds', NULL, 1030, CAST(N'2021-04-07T14:35:47.070' AS DateTime), 1038, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'CA', N'abcd', NULL, 1031, CAST(N'2021-04-10T11:00:12.767' AS DateTime), 1038, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'CS', N'afasfaasfaaaaaaaaaaaaaaa', NULL, 1032, CAST(N'2021-04-01T14:50:03.590' AS DateTime), 1033, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'MBA', N'sasdas', NULL, 1030, NULL, 1030, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1003, N'mba', N'aaaaaaaaaaa', CAST(N'2021-04-01T14:49:35.283' AS DateTime), 1033, CAST(N'2021-04-10T11:01:03.150' AS DateTime), 1038, 0)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1004, N'CIVIL', N'CIVIL ENGINEERING', CAST(N'2021-04-05T20:04:08.433' AS DateTime), 1038, CAST(N'2021-04-05T20:04:08.433' AS DateTime), 1038, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1005, N'CIVIL', N'gfb', CAST(N'2021-04-05T21:37:32.807' AS DateTime), 1038, CAST(N'2021-04-05T21:38:00.027' AS DateTime), 1038, 0)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1006, N'CIVIL', N'gfbdfbdfbfbfg', CAST(N'2021-04-05T21:37:35.887' AS DateTime), 1038, CAST(N'2021-04-05T21:37:35.887' AS DateTime), 1038, 0)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1007, N'CIVIL', N'fvsdvd', CAST(N'2021-04-05T21:39:16.183' AS DateTime), 1038, CAST(N'2021-04-05T21:39:16.183' AS DateTime), 1038, 0)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1008, N'mba', N'dfdxsvd', CAST(N'2021-04-07T14:36:18.343' AS DateTime), 1038, CAST(N'2021-04-07T14:36:18.343' AS DateTime), 1038, 0)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1009, N'mba nb', N'vvhvh', CAST(N'2021-04-10T11:01:41.300' AS DateTime), 1038, CAST(N'2021-04-10T11:01:41.300' AS DateTime), 1038, 1)
SET IDENTITY_INSERT [dbo].[NoteCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[NoteTypes] ON 

INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1, N'Handwritten Notes', N'abcd', NULL, NULL, CAST(N'2021-04-01T18:27:50.410' AS DateTime), 1033, 0)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'University Notes', N'adfc', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'NoteBook', N'sdasdsad', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (5, N'Novel', N'xzccscsac', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1003, N'mba', N'vvvvvvvvvvvvvvvvvv', CAST(N'2021-04-01T18:27:35.853' AS DateTime), 1033, CAST(N'2021-04-01T18:27:35.853' AS DateTime), 1033, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1004, N'Copy', N'Copied from original1', CAST(N'2021-04-05T21:21:38.603' AS DateTime), 1038, CAST(N'2021-04-07T14:42:18.290' AS DateTime), 1038, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1005, N'CIVIL', N'ctcc
', CAST(N'2021-04-05T21:39:44.093' AS DateTime), 1038, CAST(N'2021-04-05T21:40:10.697' AS DateTime), 1038, 0)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1006, N'cv', N'cvcvc', CAST(N'2021-04-07T14:42:44.713' AS DateTime), 1038, CAST(N'2021-04-07T14:42:44.713' AS DateTime), 1038, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1007, N'mba nb', N'vvbvbvbn', CAST(N'2021-04-10T11:02:18.807' AS DateTime), 1038, CAST(N'2021-04-10T11:02:34.317' AS DateTime), 1038, 0)
SET IDENTITY_INSERT [dbo].[NoteTypes] OFF
GO
INSERT [dbo].[Paid] ([ID], [PaidType]) VALUES (0, N'Free')
INSERT [dbo].[Paid] ([ID], [PaidType]) VALUES (1, N'Paid')
GO
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1, N'Male', N'M', N'Gender', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'Female', N'Fe', N'Gender', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'Unknown', N'U', N'Gender', NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'Paid', N'P', N'Selling Mode', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (5, N'Free', N'F', N'Selling Mode', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (6, N'Draft', N'Draft', N'Notes Status', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (7, N'Submitted For Review', N'Submitted For Review', N'Notes Status', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (8, N'In Review', N'In Review', N'Notes Status', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (9, N'Published', N'Published', N'Notes Status', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (10, N'Rejected', N'Rejected', N'Notes Status', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[ReferenceData] ([ID], [Value], [DataValue], [RefCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (11, N'Removed', N'Removed', N'Notes Status', NULL, NULL, NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[SellerNotes] ON 

INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (78, 1030, 9, 1038, N'not fine', CAST(N'2021-03-26T23:26:18.827' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1030, CAST(N'2021-04-10T10:52:44.790' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (79, 1030, 10, 1038, N'fdfdfdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1030, CAST(N'2021-04-07T13:09:52.313' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (80, 1031, 9, NULL, NULL, CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1031, CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (81, 1031, 8, 1038, NULL, CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1031, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (82, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:07:44.133' AS DateTime), N'Electronic Devices and Circuits', 2, N'search3.png', 1, NULL, N'Electronic Devices and Circuits. Front Cover. Jacob Millman. McGraw-Hill International Book Company, 1985 - Electronic apparatus and appliances ', NULL, 3, N'Electronic Devices', N'ED121', N'Jacob Millman', 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1031, CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (83, 1031, 9, 1038, N'boring
', CAST(N'2021-03-27T11:11:29.080' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1031, CAST(N'2021-04-07T17:17:13.827' AS DateTime), 1038, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (84, 1031, 11, 1038, N'not so impressive
', CAST(N'2021-03-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1031, CAST(N'2021-04-10T10:31:51.090' AS DateTime), 1038, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (85, 1031, 10, 1038, N'not so good', CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1031, CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (86, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1031, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (87, 1031, 11, 1038, N'note so good 
', CAST(N'2021-02-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1031, CAST(N'2021-04-10T10:47:50.890' AS DateTime), 1038, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (88, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'python python python python python python ', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1031, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (89, 1031, 9, 1038, NULL, CAST(N'2021-04-09T15:14:49.690' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1031, CAST(N'2021-03-26T23:26:18.827' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (90, 1031, 9, 1038, NULL, CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1031, CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (91, 1030, 10, 1038, N'hbhbh', CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1030, CAST(N'2021-04-07T14:10:47.870' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (92, 1030, 11, 1038, N'this is not good', CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1030, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (94, 1030, 11, NULL, NULL, CAST(N'2021-04-09T14:46:04.200' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1030, CAST(N'2021-04-09T14:46:04.200' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (95, 1030, 9, 1038, N'very low performance
', CAST(N'2021-03-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1030, CAST(N'2021-04-03T13:40:59.687' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (96, 1030, 11, NULL, NULL, CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1030, CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (97, 1030, 11, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1030, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (98, 1030, 11, 1038, N'not fine
', CAST(N'2021-02-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1030, CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (99, 1030, 11, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'python python python python python python python python python python python python ', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1030, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (100, 1032, 9, 1038, N'not so effective
', CAST(N'2021-03-26T23:26:18.827' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1032, CAST(N'2021-03-26T23:26:18.827' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (101, 1032, 9, 1033, N'not so good
', CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1032, CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (102, 1032, 9, NULL, NULL, CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1032, CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (103, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1032, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (104, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:07:44.133' AS DateTime), N'Electronic Devices and Circuits', 2, N'search3.png', 1, NULL, N'Electronic Devices and Circuits. Front Cover. Jacob Millman. McGraw-Hill International Book Company, 1985 - Electronic apparatus and appliances ', NULL, 3, N'Electronic Devices', N'ED121', N'Jacob Millman', 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1032, CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (105, 1032, 9, 1033, NULL, CAST(N'2021-03-27T11:11:29.080' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1032, CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (106, 1032, 9, 1038, N'very bad
', CAST(N'2021-04-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1032, CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (107, 1032, 11, 1038, N' not so good boring', CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1032, CAST(N'2021-04-09T15:16:26.993' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (108, 1032, 11, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1032, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (109, 1032, 9, 1033, NULL, CAST(N'2021-04-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1032, CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (110, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'pythonpythonpythonpythonpythonpythonpythonpythonpythonpythonpython', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1032, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (117, 1030, 11, NULL, NULL, CAST(N'2021-04-09T14:49:38.000' AS DateTime), N'Management', 4, N'Automatic Control Systems.jpg', 4, 44, N'management management management management management management management management management management management management management ', N'u v patel', 5, N'BCOM', N'note11433', N'mr. rathod', 1, CAST(43 AS Decimal(18, 0)), N'java.pdf', CAST(N'2021-04-09T14:49:25.313' AS DateTime), 1030, CAST(N'2021-04-09T14:49:38.000' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (118, 1030, 11, NULL, NULL, CAST(N'2021-04-09T15:02:31.610' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-04-09T15:02:31.610' AS DateTime), 1030, CAST(N'2021-04-09T15:02:31.610' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (119, 1030, 11, NULL, NULL, CAST(N'2021-04-09T15:07:26.947' AS DateTime), N'maths', 1, N'', 4, 54, N'maths maths maths maths maths maths maths maths maths maths maths maths maths maths ', N'u v patel', 5, N'civil', NULL, N'mr patel', 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-04-09T15:07:26.947' AS DateTime), 1030, CAST(N'2021-04-09T15:07:26.947' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (120, 1030, 10, 1038, N'book in not so good', CAST(N'2021-04-10T10:36:10.653' AS DateTime), N'electric', 3, N'search5.png', 2, 15, N'elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric elctric ', N'u v patel', 3, N'Computer', N'11ssa', N'mr. rathod', 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-04-09T16:05:15.597' AS DateTime), 1030, CAST(N'2021-04-09T16:05:15.597' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (121, 1030, 7, NULL, NULL, CAST(N'2021-04-09T17:40:08.947' AS DateTime), N'Data science', 1, N'Digitallogic.jpg', 4, 43, N'Data scienceData scienceData scienceData scienceData scienceData scienceData science', N'u v patel', 5, N'Computer', N'11', N'mr patel', 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-04-09T17:40:08.947' AS DateTime), 1030, CAST(N'2021-04-09T17:40:08.947' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (122, 1030, 6, NULL, NULL, CAST(N'2021-04-09T23:21:44.360' AS DateTime), N'noteewew', 3, N'computer-science.png', 2, 44, N'noteewew noteewewnoteewew noteewew noteewew noteewew noteewew ', N'ganpat university', 3, N'Computer', N'note112', N'mr. rathod', 1, CAST(650 AS Decimal(18, 0)), N'Automatic Control Systems (11).pdf', CAST(N'2021-04-09T23:14:33.857' AS DateTime), 1030, CAST(N'2021-04-09T23:21:44.360' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (123, 1030, 7, NULL, NULL, CAST(N'2021-04-09T23:19:03.630' AS DateTime), N'notee', 4, N'computer-science.png', 2, 65, N'note2 note2 note2 note2 note2 note2 note2 note2 note2 note2 note2 note2 ', NULL, 6, NULL, NULL, NULL, 1, CAST(30 AS Decimal(18, 0)), N'', CAST(N'2021-04-09T23:19:03.630' AS DateTime), 1030, CAST(N'2021-04-09T23:19:03.630' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (126, 1030, 6, NULL, NULL, CAST(N'2021-04-10T02:36:31.797' AS DateTime), N'dfdfdfdf', 3, N'', 4, NULL, N'cscccccccccccccccccccccccccccccccccccccccccccccccccccccccc', NULL, 5, NULL, NULL, NULL, 1, CAST(54 AS Decimal(18, 0)), N'', CAST(N'2021-04-10T02:36:31.797' AS DateTime), 1030, CAST(N'2021-04-10T02:36:31.797' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (127, 1030, 7, NULL, NULL, CAST(N'2021-04-10T09:20:12.450' AS DateTime), N'Designing', 1004, N'search1.png', 4, 54, N'designing designing designing designing designing designing designing designing designing designing designing ', N's r college', 5, N'Disigning processes', N'Des213', N'mr desai', 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-04-10T09:13:20.663' AS DateTime), 1030, CAST(N'2021-04-10T09:20:12.450' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (128, 1030, 7, NULL, NULL, CAST(N'2021-04-10T09:15:42.177' AS DateTime), N'data science and algorithm', 4, N'', 5, 54, N'designing designing designing designing designing designing designing ', NULL, 5, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-04-10T09:15:42.177' AS DateTime), 1030, CAST(N'2021-04-10T09:15:42.177' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (129, 1030, 7, NULL, NULL, CAST(N'2021-04-10T09:16:35.237' AS DateTime), N'data science and algorithm', 4, N'', 5, 54, N'designing designing designing designing designing designing designing ', NULL, 5, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-04-10T09:16:35.237' AS DateTime), 1030, CAST(N'2021-04-10T09:16:35.237' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (130, 1030, 7, NULL, NULL, CAST(N'2021-04-10T09:18:02.693' AS DateTime), N'data science and algorithm two', 4, N'', 5, NULL, N'designing designing designing designing designing designing designing designing designing ', NULL, 6, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'SQL_Server_2017_Editions_Datasheet.pdf', CAST(N'2021-04-10T09:18:02.693' AS DateTime), 1030, CAST(N'2021-04-10T09:18:02.693' AS DateTime), 1030, 1)
SET IDENTITY_INSERT [dbo].[SellerNotes] OFF
GO
SET IDENTITY_INSERT [dbo].[SellerNotesAttachements] ON 

INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1055, 78, N'java.pdf', N'~/UserFile/FileName/java.pdf', CAST(N'2021-03-26T23:14:50.487' AS DateTime), 1030, CAST(N'2021-03-26T23:26:18.887' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1056, 79, N'php.pdf', N'~/UserFile/FileName/php.pdf', CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1030, CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1057, 80, N'engineering graphics.pdf', N'~/UserFile/FileName/engineering graphics.pdf', CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1031, CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1058, 81, N'engineering electromics.pdf', N'~/UserFile/FileName/engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1031, CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1059, 82, N'Electronic Devices and Circuits.pdf', N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1031, CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1060, 83, N'Digital Logic and Computer Design.pdf', N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1031, CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1061, 84, N'Automatic Control Systems.pdf', N'~/UserFile/FileName/Automatic Control Systems.pdf', CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1031, CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1062, 85, N'Control Systems Engineering.pdf', N'~/UserFile/FileName/Control Systems Engineering.pdf', CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1031, CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1063, 86, N'thinkandgrow.pdf', N'~/UserFile/FileName/thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1031, CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1064, 87, N'calculas.pdf', N'~/UserFile/FileName/calculas.pdf', CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1031, CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1065, 88, N'python.pdf', N'~/UserFile/FileName/python.pdf', CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1031, CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1066, 89, N'java.pdf', N'~/UserFile/FileName/java.pdf', CAST(N'2021-03-26T23:14:50.487' AS DateTime), 1031, CAST(N'2021-03-26T23:26:18.887' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1067, 90, N'php.pdf', N'~/UserFile/FileName/php.pdf', CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1031, CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1068, 91, N'engineering graphics.pdf', N'~/UserFile/FileName/engineering graphics.pdf', CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1030, CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1069, 92, N'engineering electromics.pdf', N'~/UserFile/FileName/engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1030, CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1071, 94, N'Digital Logic and Computer Design.pdf', N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1030, CAST(N'2021-04-09T14:46:04.213' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1072, 95, N'Automatic Control Systems.pdf', N'~/UserFile/FileName/Automatic Control Systems.pdf', CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1030, CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1073, 96, N'Control Systems Engineering.pdf', N'~/UserFile/FileName/Control Systems Engineering.pdf', CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1030, CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1074, 97, N'thinkandgrow.pdf', N'~/UserFile/FileName/thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1030, CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1075, 98, N'calculas.pdf', N'~/UserFile/FileName/calculas.pdf', CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1030, CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1076, 99, N'python.pdf', N'~/UserFile/FileName/python.pdf', CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1030, CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1077, 100, N'java.pdf', N'~/UserFile/FileName/java.pdf', CAST(N'2021-03-26T23:14:50.487' AS DateTime), 1032, CAST(N'2021-03-26T23:26:18.887' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1078, 101, N'php.pdf', N'~/UserFile/FileName/php.pdf', CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1032, CAST(N'2021-03-26T23:17:10.223' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1079, 102, N'engineering graphics.pdf', N'~/UserFile/FileName/engineering graphics.pdf', CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1032, CAST(N'2021-03-27T10:58:04.013' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1080, 103, N'engineering electromics.pdf', N'~/UserFile/FileName/engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1032, CAST(N'2021-03-27T11:02:53.347' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1081, 104, N'Electronic Devices and Circuits.pdf', N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1032, CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1082, 105, N'Digital Logic and Computer Design.pdf', N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1032, CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1083, 106, N'Automatic Control Systems.pdf', N'~/UserFile/FileName/Automatic Control Systems.pdf', CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1032, CAST(N'2021-03-27T11:14:01.223' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1084, 107, N'Control Systems Engineering.pdf', N'~/UserFile/FileName/Control Systems Engineering.pdf', CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1032, CAST(N'2021-03-27T11:17:04.483' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1085, 108, N'thinkandgrow.pdf', N'~/UserFile/FileName/thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1032, CAST(N'2021-03-27T11:20:07.267' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1086, 109, N'calculas.pdf', N'~/UserFile/FileName/calculas.pdf', CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1032, CAST(N'2021-03-27T11:24:54.263' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1087, 110, N'python.pdf', N'~/UserFile/FileName/python.pdf', CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1032, CAST(N'2021-03-27T11:28:16.623' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1089, 117, N'Control Systems Engineering (3).pdf', N'~/UserFile/FileName/Control Systems Engineering (3).pdf', CAST(N'2021-04-09T14:49:25.437' AS DateTime), 1030, CAST(N'2021-04-09T14:49:38.043' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1090, 118, N'Automatic Control Systems.pdf', N'~/UserFile/FileName/Automatic Control Systems.pdf', CAST(N'2021-04-09T15:02:33.713' AS DateTime), 1030, CAST(N'2021-04-09T15:02:33.713' AS DateTime), 1030, 0)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1091, 119, N'sample.pdf', N'~/UserFile/FileName/sample.pdf', CAST(N'2021-04-09T15:07:27.030' AS DateTime), 1030, CAST(N'2021-04-09T15:07:27.030' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1092, 120, N'sample.pdf', N'~/UserFile/FileName/sample.pdf', CAST(N'2021-04-09T16:05:17.593' AS DateTime), 1030, CAST(N'2021-04-09T16:05:17.593' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1093, 121, N'Automatic Control Systems (12).pdf', N'~/UserFile/FileName/Automatic Control Systems (12).pdf', CAST(N'2021-04-09T17:40:10.547' AS DateTime), 1030, CAST(N'2021-04-09T17:40:10.547' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1094, 122, N'Electronic Devices and Circuits (5).pdf', N'~/UserFile/FileName/Electronic Devices and Circuits (5).pdf', CAST(N'2021-04-09T23:14:37.023' AS DateTime), 1030, CAST(N'2021-04-09T23:21:44.403' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1095, 123, N'python (2).pdf', N'~/UserFile/FileName/python (2).pdf', CAST(N'2021-04-09T23:19:05.087' AS DateTime), 1030, CAST(N'2021-04-09T23:19:05.087' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1098, 126, N'sample.pdf', N'~/UserFile/FileName/sample.pdf', CAST(N'2021-04-10T02:36:31.880' AS DateTime), 1030, CAST(N'2021-04-10T02:36:31.880' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1099, 127, N'sample.pdf', N'~/UserFile/FileName/sample.pdf', CAST(N'2021-04-10T09:13:20.727' AS DateTime), 1030, CAST(N'2021-04-10T09:20:12.470' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1100, 129, N'sample.pdf', N'~/UserFile/FileName/sample.pdf', CAST(N'2021-04-10T09:16:35.260' AS DateTime), 1030, CAST(N'2021-04-10T09:16:35.260' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1101, 130, N'__UserFile_FileName_python.pdf', N'~/UserFile/FileName/__UserFile_FileName_python.pdf', CAST(N'2021-04-10T09:18:02.733' AS DateTime), 1030, CAST(N'2021-04-10T09:18:02.733' AS DateTime), 1030, 1)
SET IDENTITY_INSERT [dbo].[SellerNotesAttachements] OFF
GO
SET IDENTITY_INSERT [dbo].[SellerNotesReportedIssues] ON 

INSERT [dbo].[SellerNotesReportedIssues] ([ID], [NoteID], [ReportedByID], [AgainstDownloadID], [Remarks], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (13, 82, 1032, 82, N'not so good ', NULL, NULL, NULL, NULL)
INSERT [dbo].[SellerNotesReportedIssues] ([ID], [NoteID], [ReportedByID], [AgainstDownloadID], [Remarks], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (16, 82, 1030, 82, N'csdcdsccsc', CAST(N'2021-04-09T23:34:35.300' AS DateTime), 1030, CAST(N'2021-04-09T23:34:35.300' AS DateTime), 1030)
INSERT [dbo].[SellerNotesReportedIssues] ([ID], [NoteID], [ReportedByID], [AgainstDownloadID], [Remarks], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (17, 88, 1030, 85, N'not so good', CAST(N'2021-04-10T10:02:12.650' AS DateTime), 1030, CAST(N'2021-04-10T10:02:12.650' AS DateTime), 1030)
SET IDENTITY_INSERT [dbo].[SellerNotesReportedIssues] OFF
GO
SET IDENTITY_INSERT [dbo].[SellerNotesReviews] ON 

INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (24, 82, 1032, 82, CAST(4 AS Decimal(18, 0)), N'very good book', CAST(N'2021-03-27T14:33:52.330' AS DateTime), 1032, CAST(N'2021-03-27T14:33:52.330' AS DateTime), 1032, 0)
INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (25, 106, 1032, 85, CAST(5 AS Decimal(18, 0)), N'nice very good for learn the python
', CAST(N'2021-03-27T14:35:38.410' AS DateTime), 1032, CAST(N'2021-03-27T14:35:38.410' AS DateTime), 1032, 0)
INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (29, 110, 1030, 77, CAST(3 AS Decimal(18, 0)), N'fbhdvbdfhaclasnsn', CAST(N'2021-04-08T19:08:52.580' AS DateTime), 1030, CAST(N'2021-04-08T19:08:52.580' AS DateTime), 1030, 0)
INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (32, 96, 1030, 111, CAST(4 AS Decimal(18, 0)), N'very good noe for learning the Control System', CAST(N'2021-04-10T09:53:11.433' AS DateTime), 1030, CAST(N'2021-04-10T09:53:11.433' AS DateTime), 1030, 0)
SET IDENTITY_INSERT [dbo].[SellerNotesReviews] OFF
GO
SET IDENTITY_INSERT [dbo].[SystemConfiguration] ON 

INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'email', N'note.mk.p@gmail.com', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'phone', N'8200187620', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'facebook', N'https://www.facebook.com/groups/457637638167569/', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (5, N'twitter', N'https://www.facebook.com/groups/457637638167569/', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (6, N'linkedin', N'https://www.facebook.com/groups/457637638167569/', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (8, N'defaultnoteimage', N'defaultnote.png', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[SystemConfiguration] ([ID], [Key], [Value], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (9, N'defaultprofileimage', N'member.png', NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[SystemConfiguration] OFF
GO
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1030, 1030, CAST(N'2000-05-02T00:00:00.000' AS DateTime), 1, N'janakpatel00002@gmail.com', N'91', N'8200187620', N'customer-4.png', N'balaji bunglows', N'near navjivan', N'unjha', N'gujrat', N'384170', N'india', N'ganpat', N'u. v. patel', CAST(N'2021-03-26T23:07:38.973' AS DateTime), 1030, CAST(N'2021-04-10T10:05:36.537' AS DateTime), 1030)
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1032, 1032, CAST(N'2000-12-03T00:00:00.000' AS DateTime), 1, N'janakpatel00005@gmail.com', N'91', N'7041407223', N'', N'kalyan banglows', N'near navjivan', N'mehsana', N'gujrat', N'384170', N'india', N'M.R.S', N'ASBP College of commerce', CAST(N'2021-03-27T10:04:06.907' AS DateTime), 1037, CAST(N'2021-04-10T18:09:51.037' AS DateTime), 1037)
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1033, 1033, NULL, NULL, N'janakpatel00002@gmail.com', N'91', N'8499454539', N'', N'', N'', N'', N'', N'', N'', NULL, NULL, CAST(N'2021-04-02T15:47:10.797' AS DateTime), 1033, CAST(N'2021-04-10T12:25:52.020' AS DateTime), 1033)
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1038, 1038, NULL, NULL, N'janakpatel00002@gmail.com', N'44', N'8200187620', N'customer-4.png', N'-', N'-', N'-', N'-', N'-', N'-', NULL, NULL, CAST(N'2021-04-05T22:20:47.430' AS DateTime), 1038, CAST(N'2021-04-10T11:03:57.607' AS DateTime), 1038)
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1039, 1039, NULL, NULL, N'kath12@gmail.com', N'44', N'8200187620', N'customer-1.png', N'-', N'-', N'-', N'-', N'-', N'-', NULL, NULL, CAST(N'2021-04-07T14:57:11.893' AS DateTime), 1039, CAST(N'2021-04-07T14:57:11.893' AS DateTime), 1039)
GO
SET IDENTITY_INSERT [dbo].[UserRoles] ON 

INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1030, N'janak', N'User', CAST(N'2021-03-26T23:06:02.753' AS DateTime), NULL, CAST(N'2021-03-26T23:06:02.753' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1031, N'kevin', N'User', CAST(N'2021-03-27T10:00:05.020' AS DateTime), NULL, CAST(N'2021-03-27T10:00:05.020' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1032, N'neel', N'Admin', CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1033, N'abhi', N'Admin', CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1037, N'janak patel', N'Admin', CAST(N'2021-04-03T11:44:44.523' AS DateTime), NULL, CAST(N'2021-04-03T11:44:44.527' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1038, N'dax patel', N'Admin', CAST(N'2021-04-03T11:44:44.523' AS DateTime), NULL, CAST(N'2021-04-03T11:44:44.523' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1039, N'kathan patel', N'SuperAdmin', CAST(N'2021-04-03T11:44:44.523' AS DateTime), NULL, CAST(N'2021-04-03T11:44:44.523' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1040, N'jeel patel', N'Admin', CAST(N'2021-04-06T13:04:59.770' AS DateTime), NULL, CAST(N'2021-04-06T13:04:59.770' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1041, N'janak patel', N'Admin', CAST(N'2021-04-06T13:24:47.037' AS DateTime), NULL, CAST(N'2021-04-06T13:24:47.037' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1042, N'janak patel', N'Admin', CAST(N'2021-04-07T14:53:58.230' AS DateTime), NULL, CAST(N'2021-04-07T14:53:58.230' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1043, N'janak patel', N'Admin', CAST(N'2021-04-07T15:11:57.300' AS DateTime), NULL, CAST(N'2021-04-07T15:11:57.300' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1044, N'mansi', N'User', CAST(N'2021-04-07T21:36:30.307' AS DateTime), NULL, CAST(N'2021-04-07T21:36:30.307' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1045, N'janak', N'User', CAST(N'2021-04-08T18:39:28.930' AS DateTime), NULL, CAST(N'2021-04-08T18:39:28.930' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1046, N'janak patel', N'User', CAST(N'2021-04-10T08:52:45.577' AS DateTime), NULL, CAST(N'2021-04-10T08:52:45.577' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1047, N'janak patel', N'Admin', CAST(N'2021-04-10T11:30:45.877' AS DateTime), NULL, CAST(N'2021-04-10T11:30:45.877' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1048, N'janak patel', N'Admin', CAST(N'2021-04-10T11:39:33.303' AS DateTime), NULL, CAST(N'2021-04-10T11:39:33.303' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1049, N'janak patel', N'Admin', CAST(N'2021-04-10T12:24:24.610' AS DateTime), NULL, CAST(N'2021-04-10T12:24:24.610' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[UserRoles] OFF
GO
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1030, 1030, N'janak', N'patel', N'janakpatel00002@gmail.com', N'Janak$12', 1, CAST(N'2021-03-26T23:06:04.807' AS DateTime), 1030, CAST(N'2021-04-03T11:49:21.810' AS DateTime), 1030, 1, N'b31ea7e1-60a5-4b9a-99be-630dd3991865')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1031, 1031, N'kevin', N'patel', N'jkpatel43@yahoo.com', N'Janak$12', 1, CAST(N'2021-03-27T10:00:06.443' AS DateTime), 1031, CAST(N'2021-03-27T10:00:06.447' AS DateTime), 1031, 1, N'7e794d45-a63f-4fe1-be51-904998f2a4dd')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1032, 1032, N'neel', N'patel', N'janakpatel522000@gmail.com', N'Janak$12', 1, CAST(N'2021-03-27T13:09:01.350' AS DateTime), 1032, CAST(N'2021-04-10T18:09:50.697' AS DateTime), 1032, 1, N'dd488500-52b1-4dbf-8b48-b17433304343')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1033, 1033, N'abhi', N'patel', N'abhi123@gmail.com', N'Janak$12', 1, CAST(N'2021-03-27T13:09:01.350' AS DateTime), 1033, CAST(N'2021-04-10T12:25:51.877' AS DateTime), 1033, 1, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1037, 1037, N'janak', N'patel', N'janakpatel02@gmail.com', N'janak1037', 1, CAST(N'2021-04-03T11:44:48.677' AS DateTime), 1037, CAST(N'2021-04-03T11:44:48.677' AS DateTime), 1037, 1, N'859bb50d-0c8b-4a4d-ba9c-3f62ce9689c3')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1038, 1038, N'dax', N'patel', N'dax12@gmail.com', N'Janak123', 1, CAST(N'2021-04-03T11:44:48.677' AS DateTime), 1038, CAST(N'2021-04-10T11:03:57.600' AS DateTime), 1038, 1, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1039, 1039, N'kathan', N'patel', N'kathan12@gmail.com', N'kathan123', 1, CAST(N'2021-04-03T11:44:48.677' AS DateTime), 1039, CAST(N'2021-04-07T14:57:11.873' AS DateTime), 1039, 1, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1040, 1040, N'jeel', N'patel', N'jeel123@gmail.com', N'jeel1040', 1, CAST(N'2021-04-06T13:05:01.150' AS DateTime), 1040, CAST(N'2021-04-06T13:32:24.033' AS DateTime), 1040, 1, N'ab723a01-025d-4769-80b9-cbb4c5330685')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1041, 1041, N'janak', N'patel', N'janakpatel02@gmail.com', N'janak1041', 0, CAST(N'2021-04-06T13:24:50.247' AS DateTime), 1041, CAST(N'2021-04-06T13:24:50.247' AS DateTime), 1041, 0, N'1d803e18-302d-41df-a69a-39ef4a7c8529')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1042, 1042, N'janak', N'patel', N'janakpatel02@gmail.com', N'janak1042', 0, CAST(N'2021-04-07T14:53:58.440' AS DateTime), 1042, CAST(N'2021-04-07T14:53:58.440' AS DateTime), 1042, 0, N'75fd6f1d-0cd5-44be-8751-4c628ecd4706')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1043, 1043, N'janak', N'patel', N'janakpatel02@gmail.com', N'janak1043', 0, CAST(N'2021-04-07T15:12:02.050' AS DateTime), 1043, CAST(N'2021-04-07T15:12:02.050' AS DateTime), 1043, 1, N'3a15e267-4eae-4304-bc11-d798109055e4')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1044, 1044, N'mansi', N'patel', N'mansipatel3107@gmail.com', N'janak123', 0, CAST(N'2021-04-07T21:36:32.700' AS DateTime), 1044, CAST(N'2021-04-07T21:36:32.700' AS DateTime), 1044, 1, N'f6b20d61-afcf-473d-9c96-ad61ab9b76ba')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1045, 1045, N'janak', N'patel', N'janakpat@gmail.com', N'hunub', 0, CAST(N'2021-04-08T18:39:31.060' AS DateTime), 1045, CAST(N'2021-04-08T18:39:31.063' AS DateTime), 1045, 0, N'e479f242-1374-4109-b2a2-2481521ad281')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1046, 1046, N'janak', N'patel', N'Janakpatel00005@gmail.com', N'Janak$12', 1, CAST(N'2021-04-10T08:52:47.627' AS DateTime), 1046, CAST(N'2021-04-10T08:52:47.627' AS DateTime), 1046, 1, N'3d93858d-4c48-4970-b1e4-ae01eddbc4be')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1047, 1047, N'janak', N'patel', N'Janakpatel00012@gmail.com', N'janak1047', 0, CAST(N'2021-04-10T11:30:46.577' AS DateTime), 1047, CAST(N'2021-04-10T11:30:46.577' AS DateTime), 1047, 1, N'f0b79f27-209d-4407-912f-3bb19e6642f1')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1048, 1048, N'janak', N'patel', N'Janakpatel000013@gmail.com', N'janak1048', 0, CAST(N'2021-04-10T11:39:33.690' AS DateTime), 1048, CAST(N'2021-04-10T11:39:33.690' AS DateTime), 1048, 1, N'fbf3468b-c104-44d7-8a3e-a92cc24eadb6')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1049, 1049, N'janak', N'patel', N'Janakpatel000023@gmail.com', N'janak1049', 0, CAST(N'2021-04-10T12:24:25.113' AS DateTime), 1049, CAST(N'2021-04-10T12:24:25.113' AS DateTime), 1049, 1, N'64ca06ec-c6a5-4bfe-a959-dc42d25fe91c')
GO
ALTER TABLE [dbo].[Countries] ADD  CONSTRAINT [DF_Countries_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[NoteCategories] ADD  CONSTRAINT [DF_NoteCategories_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[NoteTypes] ADD  CONSTRAINT [DF_NoteTypes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ReferenceData] ADD  CONSTRAINT [DF_ReferenceData_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SellerNotes] ADD  CONSTRAINT [DF_SellerNotes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SellerNotesAttachements] ADD  CONSTRAINT [DF_SellerNotesAttachements_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SellerNotesReviews] ADD  CONSTRAINT [DF_SellerNotesReviews_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SystemConfiguration] ADD  CONSTRAINT [DF_SystemConfiguration_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserRoles] ADD  CONSTRAINT [DF_UserRoles_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsEmailVerified]  DEFAULT ((0)) FOR [IsEmailVerified]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Downloads]  WITH CHECK ADD  CONSTRAINT [FK_Downloads_SellerNotes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[SellerNotes] ([ID])
GO
ALTER TABLE [dbo].[Downloads] CHECK CONSTRAINT [FK_Downloads_SellerNotes]
GO
ALTER TABLE [dbo].[Downloads]  WITH CHECK ADD  CONSTRAINT [FK_Downloads_Users] FOREIGN KEY([Seller])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Downloads] CHECK CONSTRAINT [FK_Downloads_Users]
GO
ALTER TABLE [dbo].[Downloads]  WITH CHECK ADD  CONSTRAINT [FK_Downloads_Users1] FOREIGN KEY([Downloader])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Downloads] CHECK CONSTRAINT [FK_Downloads_Users1]
GO
ALTER TABLE [dbo].[SellerNotes]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotes_Countries] FOREIGN KEY([Country])
REFERENCES [dbo].[Countries] ([ID])
GO
ALTER TABLE [dbo].[SellerNotes] CHECK CONSTRAINT [FK_SellerNotes_Countries]
GO
ALTER TABLE [dbo].[SellerNotes]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotes_NoteCategories] FOREIGN KEY([Category])
REFERENCES [dbo].[NoteCategories] ([ID])
GO
ALTER TABLE [dbo].[SellerNotes] CHECK CONSTRAINT [FK_SellerNotes_NoteCategories]
GO
ALTER TABLE [dbo].[SellerNotes]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotes_NoteTypes] FOREIGN KEY([NoteType])
REFERENCES [dbo].[NoteTypes] ([ID])
GO
ALTER TABLE [dbo].[SellerNotes] CHECK CONSTRAINT [FK_SellerNotes_NoteTypes]
GO
ALTER TABLE [dbo].[SellerNotes]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotes_Users] FOREIGN KEY([SellerID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[SellerNotes] CHECK CONSTRAINT [FK_SellerNotes_Users]
GO
ALTER TABLE [dbo].[SellerNotes]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotes_Users1] FOREIGN KEY([ActionedBy])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[SellerNotes] CHECK CONSTRAINT [FK_SellerNotes_Users1]
GO
ALTER TABLE [dbo].[SellerNotesAttachements]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesAttachements_SellerNotes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[SellerNotes] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesAttachements] CHECK CONSTRAINT [FK_SellerNotesAttachements_SellerNotes]
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReportedIssues_Downloads] FOREIGN KEY([AgainstDownloadID])
REFERENCES [dbo].[Downloads] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues] CHECK CONSTRAINT [FK_SellerNotesReportedIssues_Downloads]
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReportedIssues_SellerNotes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[SellerNotes] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues] CHECK CONSTRAINT [FK_SellerNotesReportedIssues_SellerNotes]
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReportedIssues_Users] FOREIGN KEY([ReportedByID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReportedIssues] CHECK CONSTRAINT [FK_SellerNotesReportedIssues_Users]
GO
ALTER TABLE [dbo].[SellerNotesReviews]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReviews_Downloads] FOREIGN KEY([AgainstDownloadsID])
REFERENCES [dbo].[Downloads] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReviews] CHECK CONSTRAINT [FK_SellerNotesReviews_Downloads]
GO
ALTER TABLE [dbo].[SellerNotesReviews]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReviews_SellerNotes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[SellerNotes] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReviews] CHECK CONSTRAINT [FK_SellerNotesReviews_SellerNotes]
GO
ALTER TABLE [dbo].[SellerNotesReviews]  WITH CHECK ADD  CONSTRAINT [FK_SellerNotesReviews_Users] FOREIGN KEY([ReviewedByID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[SellerNotesReviews] CHECK CONSTRAINT [FK_SellerNotesReviews_Users]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Users]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserRoles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[UserRoles] ([ID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserRoles]
GO
USE [master]
GO
ALTER DATABASE [NotesMarketPlace] SET  READ_WRITE 
GO

USE [master]
GO
/****** Object:  Database [NotesMarketPlace]    Script Date: 3/27/2021 2:44:08 PM ******/
CREATE DATABASE [NotesMarketPlace]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Notes-marketplace', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Notes-marketplace.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Notes-marketplace_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Notes-marketplace_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
EXEC sys.sp_db_vardecimal_storage_format N'NotesMarketPlace', N'ON'
GO
ALTER DATABASE [NotesMarketPlace] SET QUERY_STORE = OFF
GO
USE [NotesMarketPlace]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Downloads]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoteCategories]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NoteTypes]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paid]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReferenceData]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotes]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesAttachements]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesReportedIssues]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SellerNotesReviews]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemConfiguration]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/27/2021 2:44:10 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Countries] ON 

INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'India', N'91', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[Countries] ([ID], [Name], [CountryCode], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'USA', N'43', NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Countries] OFF
GO
SET IDENTITY_INSERT [dbo].[Downloads] ON 

INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (69, 92, 1030, 1031, 0, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:41:47.617' AS DateTime), 1031, CAST(N'2021-03-27T13:41:47.617' AS DateTime), 1031)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (70, 97, 1030, 1031, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:42:07.550' AS DateTime), 1031, CAST(N'2021-03-27T13:42:07.550' AS DateTime), 1031)
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
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (85, 88, 1031, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-03-27T13:47:17.300' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:47:17.300' AS DateTime), 1030, CAST(N'2021-03-27T13:47:17.300' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (86, 89, 1031, 1030, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:47:24.520' AS DateTime), 1030, CAST(N'2021-03-27T13:47:24.520' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (87, 90, 1031, 1030, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:47:37.517' AS DateTime), 1030, CAST(N'2021-03-27T13:47:37.517' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (88, 100, 1032, 1030, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:47:53.897' AS DateTime), 1030, CAST(N'2021-03-27T13:47:53.897' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (89, 101, 1032, 1030, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:48:05.060' AS DateTime), 1030, CAST(N'2021-03-27T13:48:05.060' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (90, 102, 1032, 1030, 0, N'~/UserFile/FileName/engineering graphics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(210 AS Decimal(18, 0)), N'engineering graphics', N'CA', CAST(N'2021-03-27T13:48:17.277' AS DateTime), 1030, CAST(N'2021-03-27T13:48:17.277' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (91, 103, 1032, 1030, 0, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:48:32.060' AS DateTime), 1030, CAST(N'2021-03-27T13:48:32.060' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (92, 104, 1032, 1030, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:48:45.493' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:48:45.497' AS DateTime), 1030, CAST(N'2021-03-27T13:48:45.497' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (93, 105, 1032, 1030, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:48:54.317' AS DateTime), 1030, CAST(N'2021-03-27T13:48:54.317' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (94, 106, 1032, 1030, 1, N'~/UserFile/FileName/Automatic Control Systems.pdf', 0, CAST(N'2021-03-27T14:32:06.023' AS DateTime), 1, CAST(240 AS Decimal(18, 0)), N'Automatic Control Systems', N'IT', CAST(N'2021-03-27T13:49:07.583' AS DateTime), 1030, CAST(N'2021-03-27T13:49:07.583' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (95, 107, 1032, 1030, 0, N'~/UserFile/FileName/Control Systems Engineering.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(120 AS Decimal(18, 0)), N'Control Systems Engineering', N'CS', CAST(N'2021-03-27T13:49:24.427' AS DateTime), 1030, CAST(N'2021-03-27T13:49:24.427' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (96, 108, 1032, 1030, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:49:41.813' AS DateTime), 1030, CAST(N'2021-03-27T13:49:41.813' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (97, 109, 1032, 1030, 0, N'~/UserFile/FileName/calculas.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(65 AS Decimal(18, 0)), N'calculas', N'CA', CAST(N'2021-03-27T13:50:09.043' AS DateTime), 1030, CAST(N'2021-03-27T13:50:09.043' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (98, 110, 1032, 1030, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:50:24.033' AS DateTime), 1030, CAST(N'2021-03-27T13:50:24.033' AS DateTime), 1030)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (99, 82, 1031, 1032, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T13:52:21.460' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T13:52:21.460' AS DateTime), 1032, CAST(N'2021-03-27T13:52:21.460' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (100, 83, 1031, 1032, 0, N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design', N'CS', CAST(N'2021-03-27T13:52:26.717' AS DateTime), 1032, CAST(N'2021-03-27T13:52:26.717' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (101, 86, 1031, 1032, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:52:39.953' AS DateTime), 1032, CAST(N'2021-03-27T13:52:39.953' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (102, 88, 1031, 1032, 1, N'~/UserFile/FileName/python.pdf', 1, CAST(N'2021-03-27T13:52:50.663' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'python', N'MBA', CAST(N'2021-03-27T13:52:50.663' AS DateTime), 1032, CAST(N'2021-03-27T13:52:50.663' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (103, 89, 1031, 1032, 0, N'~/UserFile/FileName/java.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(100 AS Decimal(18, 0)), N'java', N'IT', CAST(N'2021-03-27T13:52:59.677' AS DateTime), 1032, CAST(N'2021-03-27T13:52:59.677' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (104, 90, 1031, 1032, 0, N'~/UserFile/FileName/php.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(50 AS Decimal(18, 0)), N'php ', N'CA', CAST(N'2021-03-27T13:53:11.993' AS DateTime), 1032, CAST(N'2021-03-27T13:53:11.993' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (105, 92, 1030, 1032, 0, N'~/UserFile/FileName/engineering electromics.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics', N'IT', CAST(N'2021-03-27T13:53:24.793' AS DateTime), 1032, CAST(N'2021-03-27T13:53:24.793' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (106, 97, 1030, 1032, 0, N'~/UserFile/FileName/thinkandgrow.pdf', 0, CAST(N'2021-03-27T13:43:31.350' AS DateTime), 1, CAST(215 AS Decimal(18, 0)), N'Think and Grow Rich', N'MBA', CAST(N'2021-03-27T13:53:36.400' AS DateTime), 1032, CAST(N'2021-03-27T13:53:36.400' AS DateTime), 1032)
INSERT [dbo].[Downloads] ([ID], [NoteID], [Seller], [Downloader], [IsSellerHasAllowedDownload], [AttachmentPath], [IsAttachmentDownloaded], [AttachmentDownloadedDate], [IsPaid], [PurchasedPrice], [NoteTitle], [NoteCategory], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (108, 82, 1031, 1032, 1, N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', 1, CAST(N'2021-03-27T14:33:20.797' AS DateTime), 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits', N'CA', CAST(N'2021-03-27T14:33:20.833' AS DateTime), 1032, CAST(N'2021-03-27T14:33:20.833' AS DateTime), 1032)
SET IDENTITY_INSERT [dbo].[Downloads] OFF
GO
SET IDENTITY_INSERT [dbo].[NoteCategories] ON 

INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1, N'IT', N'abcd', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'CA', N'abcd', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (3, N'CS', N'afasfaasf', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteCategories] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'MBA', N'sasdas', NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[NoteCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[NoteTypes] ON 

INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1, N'Handwritten Notes', N'abcd', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (2, N'University Notes', N'adfc', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (4, N'NoteBook', N'sdasdsad', NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[NoteTypes] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (5, N'Novel', N'xzccscsac', NULL, NULL, NULL, NULL, 1)
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

INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (78, 1030, 6, NULL, NULL, CAST(N'2021-03-26T23:26:18.827' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1030, CAST(N'2021-03-26T23:26:18.827' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (79, 1030, 7, NULL, NULL, CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1030, CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (80, 1031, 6, NULL, NULL, CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1031, CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (81, 1031, 10, NULL, NULL, CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1031, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (82, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:07:44.133' AS DateTime), N'Electronic Devices and Circuits', 2, N'search3.png', 1, NULL, N'Electronic Devices and Circuits. Front Cover. Jacob Millman. McGraw-Hill International Book Company, 1985 - Electronic apparatus and appliances ', NULL, 3, N'Electronic Devices', N'ED121', N'Jacob Millman', 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1031, CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (83, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:11:29.080' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1031, CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (84, 1031, 6, NULL, NULL, CAST(N'2021-03-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1031, CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (85, 1031, 7, NULL, NULL, CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1031, CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (86, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1031, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (87, 1031, 7, NULL, NULL, CAST(N'2021-03-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1031, CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (88, 1031, 9, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'pythonpythonpythonpythonpythonpythonpythonpythonpythonpythonpython', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1031, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (89, 1031, 9, NULL, NULL, CAST(N'2021-03-26T23:26:18.827' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1031, CAST(N'2021-03-26T23:26:18.827' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (90, 1031, 9, NULL, NULL, CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1031, CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1031, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (91, 1030, 6, NULL, NULL, CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1030, CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (92, 1030, 9, NULL, NULL, CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1030, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (93, 1030, 6, NULL, NULL, CAST(N'2021-03-27T11:07:44.133' AS DateTime), N'Electronic Devices and Circuits', 2, N'search3.png', 1, NULL, N'Electronic Devices and Circuits. Front Cover. Jacob Millman. McGraw-Hill International Book Company, 1985 - Electronic apparatus and appliances ', NULL, 3, N'Electronic Devices', N'ED121', N'Jacob Millman', 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1030, CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (94, 1030, 7, NULL, NULL, CAST(N'2021-03-27T11:11:29.080' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1030, CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (95, 1030, 6, NULL, NULL, CAST(N'2021-03-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1030, CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (96, 1030, 7, NULL, NULL, CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1030, CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (97, 1030, 9, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1030, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (98, 1030, 6, NULL, NULL, CAST(N'2021-03-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1030, CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (99, 1030, 10, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'pythonpythonpythonpythonpythonpythonpythonpythonpythonpythonpython', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1030, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (100, 1032, 9, NULL, NULL, CAST(N'2021-03-26T23:26:18.827' AS DateTime), N'java', 1, N'search3.png', 2, 40, N'ava allows you to play online games, chat with people around the world, calculate your mortgage interest, and view images in 3D.', N'u v patel', 3, N'Computer', N'java12', N'mr patel', 1, CAST(100 AS Decimal(18, 0)), N'sample.pdf', CAST(N'2021-03-26T23:14:50.107' AS DateTime), 1032, CAST(N'2021-03-26T23:26:18.827' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (101, 1032, 9, NULL, NULL, CAST(N'2021-03-26T23:17:10.080' AS DateTime), N'php ', 2, N'computer-science.png', 4, 60, N'PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is a widely-used, free, and efficient alternative to .', N'ganpat university', 4, N'Informmation technology', N'php101', N'mr. rathod', 1, CAST(50 AS Decimal(18, 0)), N'php.pdf', CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1032, CAST(N'2021-03-26T23:17:10.080' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (102, 1032, 9, NULL, NULL, CAST(N'2021-03-27T10:58:02.030' AS DateTime), N'engineering graphics', 2, N'', 1, 75, N'Engineering drawing, most commonly referred to as engineering graphics, is the art of manipulation of designs of a variety of components, especially those related to engineering. ', N'ganpat university', 4, N'civil', N'EN1101', N'mr. singh', 1, CAST(210 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1032, CAST(N'2021-03-27T10:58:02.030' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (103, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:02:53.110' AS DateTime), N'engineering electromics', 1, N'search6.png', 4, 12, N'Engineering Electromagnetics. EIGHTH EDITION. William H. Hayt, Jr. Late Emeritus Professor. Purdue University. John A. Buck.', N'Purdue University', 4, N' Electromagnetics', N'EN1231', N'John A. Buck.', 1, CAST(70 AS Decimal(18, 0)), N'engineering electromics.pdf', CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1032, CAST(N'2021-03-27T11:02:53.110' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (104, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:07:44.133' AS DateTime), N'Electronic Devices and Circuits', 2, N'search3.png', 1, NULL, N'Electronic Devices and Circuits. Front Cover. Jacob Millman. McGraw-Hill International Book Company, 1985 - Electronic apparatus and appliances ', NULL, 3, N'Electronic Devices', N'ED121', N'Jacob Millman', 0, CAST(0 AS Decimal(18, 0)), N'Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1032, CAST(N'2021-03-27T11:07:44.133' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (105, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:11:29.080' AS DateTime), N'Digital Logic and Computer Design', 3, N'Digitallogic.jpg', 2, NULL, N'Digital Logic and Computer Design By M. Morris Mano Book Free Download · About Author · Book Details · Download Link · Preview · Other Useful Links ·', NULL, 4, N'Computer Design', NULL, N'M. Morris Mano ', 1, CAST(340 AS Decimal(18, 0)), N'Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1032, CAST(N'2021-03-27T11:11:29.080' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (106, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:14:01.113' AS DateTime), N'Automatic Control Systems', 1, N'Automatic Control Systems.jpg', 2, NULL, N'9THED1T10N. Automatic Control. Systems. FARID GOLNARAGHI. Simon Frase,- University. BENJAMIN C. KUO. University of Illinois at Urbarw-Champaign', NULL, 4, NULL, NULL, N'FARID GOLNARAGHI', 1, CAST(240 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1032, CAST(N'2021-03-27T11:14:01.113' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (107, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:17:04.373' AS DateTime), N'Control Systems Engineering', 3, N'Control Systems Engineering.jpg', 4, NULL, N'M. Gopal is Professor of Electrical Engineering at the Indian Institute of Technology (IIT), New Delhi. His research focuses on Robust Control, Neural, and Fuzzy.', NULL, 4, NULL, NULL, NULL, 1, CAST(120 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1032, CAST(N'2021-03-27T11:17:04.373' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (108, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:20:07.203' AS DateTime), N'Think and Grow Rich', 4, N'thinkandgrow.jpg', 1, NULL, N'Think and Grow RichThink and Grow RichThink and Grow RichThink and Grow Rich', NULL, 3, NULL, NULL, NULL, 1, CAST(215 AS Decimal(18, 0)), N'thinkandgrow.pdf', CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1032, CAST(N'2021-03-27T11:20:07.203' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (109, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:24:54.183' AS DateTime), N'calculas', 2, N'', 4, 43, N'calculascalculascalculascalculascalculascalculascalculascalculascalculas', N'u v patel', 3, NULL, NULL, NULL, 1, CAST(65 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1032, CAST(N'2021-03-27T11:24:54.183' AS DateTime), 1032, 1)
INSERT [dbo].[SellerNotes] ([ID], [SellerID], [Status], [ActionedBy], [AdminRemark], [PublishedDate], [Title], [Category], [DisplayPicture], [NoteType], [NumberOfPages], [Description], [UniversityName], [Country], [Course], [CourseCode], [Professor], [IsPaid], [SellingPrice], [NotesPreview], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (110, 1032, 9, NULL, NULL, CAST(N'2021-03-27T11:28:16.560' AS DateTime), N'python', 4, N'search5.png', 4, NULL, N'pythonpythonpythonpythonpythonpythonpythonpythonpythonpythonpython', NULL, 4, NULL, NULL, NULL, 0, CAST(0 AS Decimal(18, 0)), N'', CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1032, CAST(N'2021-03-27T11:28:16.560' AS DateTime), 1032, 1)
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
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1070, 93, N'Electronic Devices and Circuits.pdf', N'~/UserFile/FileName/Electronic Devices and Circuits.pdf', CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1030, CAST(N'2021-03-27T11:07:44.213' AS DateTime), 1030, 1)
INSERT [dbo].[SellerNotesAttachements] ([ID], [NoteID], [FileName], [FilePath], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1071, 94, N'Digital Logic and Computer Design.pdf', N'~/UserFile/FileName/Digital Logic and Computer Design.pdf', CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1030, CAST(N'2021-03-27T11:11:29.193' AS DateTime), 1030, 1)
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
SET IDENTITY_INSERT [dbo].[SellerNotesAttachements] OFF
GO
SET IDENTITY_INSERT [dbo].[SellerNotesReportedIssues] ON 

INSERT [dbo].[SellerNotesReportedIssues] ([ID], [NoteID], [ReportedByID], [AgainstDownloadID], [Remarks], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (5, 82, 1032, 82, N'note so good 
', CAST(N'2021-03-27T14:35:02.473' AS DateTime), 1032, CAST(N'2021-03-27T14:35:02.473' AS DateTime), 1032)
SET IDENTITY_INSERT [dbo].[SellerNotesReportedIssues] OFF
GO
SET IDENTITY_INSERT [dbo].[SellerNotesReviews] ON 

INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (24, 82, 1032, 82, CAST(4 AS Decimal(18, 0)), N'very good book', CAST(N'2021-03-27T14:33:52.330' AS DateTime), 1032, CAST(N'2021-03-27T14:33:52.330' AS DateTime), 1032, 0)
INSERT [dbo].[SellerNotesReviews] ([ID], [NoteID], [ReviewedByID], [AgainstDownloadsID], [Ratings], [Comments], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (25, 88, 1032, 85, CAST(5 AS Decimal(18, 0)), N'nice very good for learn the python
', CAST(N'2021-03-27T14:35:38.410' AS DateTime), 1032, CAST(N'2021-03-27T14:35:38.410' AS DateTime), 1032, 0)
SET IDENTITY_INSERT [dbo].[SellerNotesReviews] OFF
GO
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1030, 1030, CAST(N'2000-05-02T00:00:00.000' AS DateTime), 1, N'janakpatel00002@gmail.com', N'91', N'8200187620', N'customer-4.png', N'balaji bunglows', N'near navjivan', N'unjha', N'gujrat', N'384170', N'india', N'ganpat', N'u. v. patel', CAST(N'2021-03-26T23:07:38.973' AS DateTime), 1030, CAST(N'2021-03-26T23:08:42.290' AS DateTime), 1030)
INSERT [dbo].[UserProfile] ([ID], [UserID], [DOB], [Gender], [SecondaryEmailAddress], [PhoneNumberCountryCode], [PhoneNumber], [ProfilePicture], [AddressLine1], [AddressLine2], [City], [State], [ZipCode], [Country], [University], [College], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy]) VALUES (1031, 1031, CAST(N'2000-12-03T00:00:00.000' AS DateTime), 1, N'janakpatel00005@gmail.com', N'91', N'7041407223', N'customer-1.png', N'kalyan banglows', N'near navjivan', N'mehsana', N'gujrat', N'384170', N'india', N'M.R.S', N'ASBP College of commerce', CAST(N'2021-03-27T10:04:06.907' AS DateTime), 1031, CAST(N'2021-03-27T10:04:06.907' AS DateTime), 1031)
GO
SET IDENTITY_INSERT [dbo].[UserRoles] ON 

INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1030, N'janak', N'User', CAST(N'2021-03-26T23:06:02.753' AS DateTime), NULL, CAST(N'2021-03-26T23:06:02.753' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1031, N'kevin', N'User', CAST(N'2021-03-27T10:00:05.020' AS DateTime), NULL, CAST(N'2021-03-27T10:00:05.020' AS DateTime), NULL, 1)
INSERT [dbo].[UserRoles] ([ID], [Name], [Description], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive]) VALUES (1032, N'neel', N'User', CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, CAST(N'2021-03-27T13:08:59.843' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[UserRoles] OFF
GO
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1030, 1030, N'janak', N'patel', N'janakpatel00002@gmail.com', N'Janak$12', 1, CAST(N'2021-03-26T23:06:04.807' AS DateTime), 1030, CAST(N'2021-03-26T23:06:04.810' AS DateTime), 1030, 1, N'b31ea7e1-60a5-4b9a-99be-630dd3991865')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1031, 1031, N'kevin', N'patel', N'janakpatel00005@gmail.com', N'Janak$12', 1, CAST(N'2021-03-27T10:00:06.443' AS DateTime), 1031, CAST(N'2021-03-27T10:00:06.447' AS DateTime), 1031, 1, N'7e794d45-a63f-4fe1-be51-904998f2a4dd')
INSERT [dbo].[Users] ([ID], [RoleID], [FirstName], [LastName], [EmailID], [Password], [IsEmailVerified], [CreatedDate], [CreatedBy], [ModifiedDate], [ModifiedBy], [IsActive], [ActivationCode]) VALUES (1032, 1032, N'neel', N'patel', N'janakpatel522000@gmail.com', N'Janak$12', 1, CAST(N'2021-03-27T13:09:01.350' AS DateTime), 1032, CAST(N'2021-03-27T13:09:01.350' AS DateTime), 1032, 1, N'dd488500-52b1-4dbf-8b48-b17433304343')
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

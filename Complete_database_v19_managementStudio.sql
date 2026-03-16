-- BUOC 1: Xoa DB cu neu co

USE [master];
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DigitalLibraryDB')
BEGIN
    ALTER DATABASE [DigitalLibraryDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [DigitalLibraryDB];
END
GO

-- BUOC 2: Tao DB moi
CREATE DATABASE [DigitalLibraryDB];
GO
ALTER DATABASE [DigitalLibraryDB] SET COMPATIBILITY_LEVEL = 150;
GO

-- B3 : Tạo Bảng và insert Dữ liệu
USE [DigitalLibraryDB]
GO
/****** Object:  Table [dbo].[Author]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[AuthorID] [int] IDENTITY(1,1) NOT NULL,
	[AuthorName] [nvarchar](255) NOT NULL,
	[bio] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Summary] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CoverURL] [nvarchar](255) NULL,
	[ContentPath] [nvarchar](500) NULL,
	[Price] [decimal](10, 2) NULL,
	[Currency] [nvarchar](10) NULL,
	[TotalPages] [int] NULL,
	[PreviewPages] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[AuthorID] [int] NULL,
	[CategoryID] [int] NULL,
	[CreatedByEmployeeID] [int] NULL,
	[UpdatedByEmployeeID] [int] NULL,
	[Language] [nvarchar](50) NULL,
	[PublicationYear] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookCopy]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookCopy](
	[copy_id] [int] IDENTITY(1,1) NOT NULL,
	[book_id] [int] NOT NULL,
	[copy_code] [nvarchar](100) NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[copy_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bookmark]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookmark](
	[bookmark_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[page_number] [int] NOT NULL,
	[note] [nvarchar](max) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[bookmark_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Borrow]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrow](
	[borrow_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[request_id] [int] NULL,
	[borrow_date] [datetime2](7) NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[approved_by_employee_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[borrow_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Borrow_Extend]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrow_Extend](
	[extend_id] [int] IDENTITY(1,1) NOT NULL,
	[borrow_item_id] [int] NOT NULL,
	[old_due_date] [datetime2](7) NOT NULL,
	[requested_due_date] [datetime2](7) NOT NULL,
	[approved_due_date] [datetime2](7) NULL,
	[status] [nvarchar](30) NOT NULL,
	[requested_at] [datetime2](7) NOT NULL,
	[processed_at] [datetime2](7) NULL,
	[decision_note] [nvarchar](max) NULL,
	[approved_by_employee_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[extend_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Borrow_Item]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrow_Item](
	[borrow_item_id] [int] IDENTITY(1,1) NOT NULL,
	[borrow_id] [int] NOT NULL,
	[copy_id] [int] NOT NULL,
	[due_date] [datetime2](7) NOT NULL,
	[returned_at] [datetime2](7) NULL,
	[status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[borrow_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Borrow_Request]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrow_Request](
	[request_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[requested_at] [datetime2](7) NOT NULL,
	[note] [nvarchar](max) NULL,
	[expected_start_date] [date] NULL,
	[expected_return_date] [date] NULL,
	[processed_by_employee_id] [int] NULL,
	[processed_at] [datetime2](7) NULL,
	[decision_note] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Borrow_Request_Item]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrow_Request_Item](
	[request_item_id] [int] IDENTITY(1,1) NOT NULL,
	[request_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[request_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[status] [nvarchar](30) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart_Item]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart_Item](
	[cart_item_id] [int] IDENTITY(1,1) NOT NULL,
	[cart_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[unit_price] [decimal](10, 2) NOT NULL,
	[added_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[employee_id] [int] IDENTITY(1,1) NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[email] [nvarchar](255) NOT NULL,
	[password_hash] [nvarchar](255) NOT NULL,
	[status] [nvarchar](50) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[role_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fine]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fine](
	[fine_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[borrow_item_id] [int] NOT NULL,
	[fine_type_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[reason] [nvarchar](max) NULL,
	[status] [nvarchar](30) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[paid_at] [datetime2](7) NULL,
	[handled_by_employee_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[fine_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fine_Type]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fine_Type](
	[fine_type_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NULL,
	[default_amount] [decimal](10, 2) NULL,
	[per_day_rate] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[fine_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notification]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification](
	[notification_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[message] [nvarchar](max) NULL,
	[type] [nvarchar](30) NULL,
	[is_read] [bit] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[currency] [nvarchar](10) NULL,
	[status] [nvarchar](30) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order_Book]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Book](
	[order_book_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[payment_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[payment_method] [nvarchar](50) NULL,
	[payment_status] [nvarchar](30) NOT NULL,
	[transaction_code] [nvarchar](100) NULL,
	[paid_at] [datetime2](7) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[payment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reader]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reader](
	[reader_id] [int] IDENTITY(1,1) NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[email] [nvarchar](255) NOT NULL,
	[password_hash] [nvarchar](255) NOT NULL,
	[phone] [nvarchar](30) NULL,
	[avatar] [nvarchar](255) NULL,
	[status] [nvarchar](50) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[role_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[reader_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reader_Account]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reader_Account](
	[account_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[provider] [nvarchar](50) NOT NULL,
	[provider_user_id] [nvarchar](255) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reader_Book_Ownership]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reader_Book_Ownership](
	[ownership_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[acquired_at] [datetime2](7) NOT NULL,
	[acquired_via] [nvarchar](30) NULL,
	[status] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[ownership_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reading_History]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reading_History](
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[last_read_position] [int] NULL,
	[last_read_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Review]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[review_id] [int] IDENTITY(1,1) NOT NULL,
	[reader_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[rating] [int] NULL,
	[comment] [nvarchar](max) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 04/02/2026 1:18:02 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](30) NOT NULL,
	[description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (1, N'Nguyễn Nhật Ánh', N'Tác giả nổi tiếng với những tác phẩm văn học thiếu nhi và tuổi teen như "Tôi thấy hoa vàng trên cỏ xanh", "Mắt biếc".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (2, N'Tô Hoài', N'Nhà văn nổi tiếng với tác phẩm "Dế Mèn phiêu lưu ký". Ông là một trong những cây bút xuất sắc nhất của văn học thiếu nhi Việt Nam.')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (3, N'Nam Cao', N'Nhà văn hiện thực phê phán nổi tiếng với các tác phẩm "Chi Phèo", "Lão Hạc", "Sống mòn".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (4, N'Haruki Murakami', N'Tiểu thuyết gia Nhật Bản nổi tiếng thế giới với những tác phẩm như "Rừng Na Uy", "Kafka bên bờ biển", "1Q84".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (5, N'Paulo Coelho', N'Tác giả người Brazil nổi tiếng với tác phẩm "Nhà giả kim". Sách của ông đã được dịch ra hơn 80 ngôn ngữ.')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (6, N'J.K. Rowling', N'Tác giả người Anh, nổi tiếng với bộ truyện Harry Potter - một trong những series sách bán chạy nhất mọi thời đại.')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (7, N'Stephen King', N'Vua của thể loại kinh dị, với hơn 60 tiểu thuyết và 200 truyện ngắn.')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (8, N'Agatha Christie', N'Nữ hoàng trinh thám, tác giả của Hercule Poirot và Miss Marple.')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (9, N'Dan Brown', N'Tác giả người Mỹ nổi tiếng với series Robert Langdon, bao gồm "The Da Vinci Code".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (10, N'George Orwell', N'Tác giả người Anh với những tác phẩm kinh điển như "1984", "Animal Farm".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (11, N'Yuval Noah Harari', N'Sử gia và triết gia người Israel, tác giả của "Sapiens", "Homo Deus".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (12, N'Robert Kiyosaki', N'Doanh nhân và tác giả người Mỹ, nổi tiếng với cuốn "Rich Dad Poor Dad".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (13, N'Dale Carnegie', N'Tác giả người Mỹ với cuốn "How to Win Friends and Influence People".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (14, N'Mark Twain', N'Tác giả kinh điển người Mỹ với "The Adventures of Tom Sawyer".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (15, N'Jane Austen', N'Tiểu thuyết gia người Anh với những tác phẩm bất hủ như "Pride and Prejudice".')
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [bio]) VALUES (1001, N'Tuấn Vũ', N'aaaaa')
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
SET IDENTITY_INSERT [dbo].[Book] ON

INSERT [dbo].[Book] VALUES (1,N'Tôi thấy hoa vàng trên cỏ xanh',N'Câu chuyện tuổi thơ đẹp đẽ về tình anh em và tình yêu đầu đời.',N'Tác phẩm kể về cuộc sống của hai anh em Thiều và Tường trong một ngôi làng quê Bắc Bộ.',N'https://salt.tikicdn.com/cache/w1200/media/catalog/product/t/o/toi_thay_hoa_vang.jpg',N'books/content/toi-thay-hoa-vang.pdf',150000,N'VND',227,30,N'active','2026-01-28T20:05:44.2066667',NULL,1,1,NULL,NULL,N'Tiếng Việt',2018)

INSERT [dbo].[Book] VALUES (2,N'Mắt biếc',N'Chuyện tình đẹp và buồn của Ngạn với cô gái hàng xóm Hà Lan.',N'Tác phẩm xoay quanh chuyện tình yêu trong sáng của Ngạn dành cho Hà Lan.',N'https://sachnoi.vip/wp-content/uploads/2023/01/mat-biec.jpg',N'books/content/mat-biec.pdf',120000,N'VND',184,25,N'active','2026-01-28T20:05:44.2066667',NULL,1,1,NULL,NULL,N'Tiếng Việt',2019)

INSERT [dbo].[Book] VALUES (3,N'Dế Mèn phiêu lưu ký',N'Cuộc phiêu lưu thú vị của chú dế Mèn trong thế giới côn trùng.',N'Tác phẩm kinh điển của văn học thiếu nhi Việt Nam về cuộc phiêu lưu của chú dế Mèn.',N'https://phunugioi.com/wp-content/uploads/2022/03/Anh-De-Men-phieu-luu-ky.jpg',N'books/content/de-men.pdf',80000,N'VND',157,20,N'active','2026-01-28T20:05:44.2066667',NULL,2,3,NULL,NULL,N'Tiếng Việt',1941)

INSERT [dbo].[Book] VALUES (4,N'Chi Phèo',N'Tác phẩm nổi tiếng về số phận bi thảm của người nông dân Chi Phèo.',N'Truyện ngắn kinh điển của Nam Cao, phản ánh thực trạng xã hội Việt Nam đầu thế kỷ 20.',N'https://th.bing.com/th/id/OIP.VNulO-UgcwtKU7IlAHcGQwHaLH?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/chi-pheo.pdf',NULL,N'VND',41,15,N'active','2026-01-28T20:05:44.2066667',NULL,3,1,NULL,NULL,N'Tiếng Việt',1941)

INSERT [dbo].[Book] VALUES (5,N'Rừng Na Uy',N'Câu chuyện tình yêu và mất mát của Watanabe trong bối cảnh Nhật Bản những năm 60.',N'Tiểu thuyết nổi tiếng của Haruki Murakami khám phá tình yêu, cô đơn và sự trưởng thành.',N'https://chiasemoi.com/wp-content/uploads/2018/03/rung-na-uy-haruki-murakami.jpg',N'books/content/rung-na-uy.pdf',200000,N'VND',390,35,N'active','2026-01-28T20:05:44.2066667',NULL,4,2,NULL,NULL,N'Tiếng Anh',1987)

INSERT [dbo].[Book] VALUES (6,N'Nhà giả kim',N'Hành trình tìm kiếm kho báu và ý nghĩa cuộc đời của chàng chăn cừu Santiago.',N'Câu chuyện về Santiago và những triết lý sâu sắc về ước mơ và ý nghĩa cuộc sống.',N'https://th.bing.com/th/id/OIP._yzetDs3gher9vBV-Ax_iAHaL0?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/nha-gia-kim.pdf',180000,N'VND',84,30,N'active','2026-01-28T20:05:44.2066667',NULL,5,2,NULL,NULL,N'Tiếng Anh',1988)

INSERT [dbo].[Book] VALUES (7,N'Harry Potter và Hòn đá Phù thủy',N'Cuộc phiêu lưu đầu tiên của Harry Potter tại trường Hogwarts.',N'Câu chuyện bắt đầu cuộc phiêu lưu thần kỳ của Harry Potter trong thế giới phù thủy.',N'https://tse2.mm.bing.net/th/id/OIP.hH_4GOsGCoCqQBwCc-5J7wHaLS?rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/harry-potter-1.pdf',250000,N'VND',327,40,N'active','2026-01-28T20:05:44.2066667',NULL,6,3,NULL,NULL,N'Tiếng Anh',1997)

INSERT [dbo].[Book] VALUES (8,N'IT (Gã hề ma quái)',N'Câu chuyện kinh hoàng về gã hề Pennywise và những đứa trẻ ở thị trấn Derry.',N'Tiểu thuyết kinh dị kinh điển của Stephen King về cuộc chiến với thực thể siêu nhiên.',N'https://th.bing.com/th/id/OIP.H__CmxOK_Dw3UeSGqVqRrwHaLU?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/it.pdf',320000,N'VND',1553,50,N'active','2026-01-28T20:05:44.2066667',NULL,7,4,NULL,NULL,N'Tiếng Anh',1986)

INSERT [dbo].[Book] VALUES (9,N'Án mạng trên tàu tốc hành Phương Đông',N'Thám tử Hercule Poirot điều tra vụ án mạng bí ẩn trên tàu hỏa.',N'Tác phẩm trinh thám xuất sắc của Agatha Christie với bí ẩn phức tạp.',N'https://thuviensach.vn/img/news/2022/11/larger/8037-an-mang-tren-chuyen-tau-toc-hanh-phuong-dong-1.jpg',N'books/content/murder-orient-express.pdf',160000,N'VND',318,25,N'active','2026-01-28T20:05:44.2066667',NULL,8,4,NULL,NULL,N'Tiếng Anh',1934)

INSERT [dbo].[Book] VALUES (10,N'Mật mã Da Vinci',N'Cuộc phiêu lưu giải mã những bí ẩn nghìn năm của Robert Langdon.',N'Thriller hấp dẫn kết hợp lịch sử, nghệ thuật và tôn giáo.',N'https://tse3.mm.bing.net/th/id/OIP.nhwRU9NHV98CxdxqmW54lQHaKX?rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/da-vinci-code.pdf',280000,N'VND',627,45,N'active','2026-01-28T20:05:44.2066667',NULL,9,4,NULL,NULL,N'Tiếng Anh',2003)

INSERT [dbo].[Book] VALUES (11,N'Sapiens: Lược sử loài người',N'Câu chuyện về sự tiến hóa của loài Homo sapiens từ động vật đến chủ nhân hành tinh.',N'Yuval Noah Harari dẫn dắt qua 70,000 năm lịch sử loài người.',N'https://cdn0.fahasa.com/media/flashmagazine/images/page_images/sapiens_luoc_su_loai_nguoi/2023_03_21_16_35_44_1-390x510.jpg',N'books/content/sapiens.pdf',350000,N'VND',439,40,N'active','2026-01-28T20:05:44.2066667',NULL,11,6,NULL,NULL,N'Tiếng Anh',2011)

INSERT [dbo].[Book] VALUES (12,N'1984',N'Tiểu thuyết phản địa đàng kinh điển về xã hội toàn trị và sự giám sát tuyệt đối.',N'Tác phẩm dystopia kinh điển của George Orwell về thế giới Big Brother.',N'https://m.media-amazon.com/images/I/819ijTWp9JL._SL1500_.jpg',N'books/content/1984.pdf',190000,N'VND',393,30,N'active','2026-01-28T20:05:44.2066667',NULL,10,10,NULL,NULL,N'Tiếng Anh',1949)

INSERT [dbo].[Book] VALUES (13,N'Đắc nhân tâm',N'Nghệ thuật giao tiếp và ảnh hưởng đến người khác trong cuộc sống hàng ngày.',N'Cuốn sách kinh điển của Dale Carnegie về giao tiếp và xây dựng mối quan hệ.',N'https://bookfun.vn/wp-content/uploads/2024/07/dac-nhan-tam-sach.jpg',N'books/content/how-to-win-friends.pdf',150000,N'VND',321,35,N'active','2026-01-28T20:05:44.2066667',NULL,13,7,NULL,NULL,N'Tiếng Anh',1936)

INSERT [dbo].[Book] VALUES (14,N'Cha giàu, Cha nghèo',N'Những bài học về tiền bạc và đầu tư từ hai người cha.',N'Robert Kiyosaki chia sẻ những bài học tài chính thay đổi cách nhìn về tiền bạc.',N'https://tse3.mm.bing.net/th/id/OIP.tXfyOuJeN2JYZk1_06U1AwHaKX?rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/rich-dad-poor-dad.pdf',200000,N'VND',467,30,N'active','2026-01-28T20:05:44.2066667',NULL,12,8,NULL,NULL,N'Tiếng Anh',1997)

INSERT [dbo].[Book] VALUES (15,N'Truyện Kiều',N'Tác phẩm kinh điển của Nguyễn Du về số phận bi thảm của Thúy Kiều.',N'Một trong những tác phẩm văn học vĩ đại nhất của Việt Nam.',N'https://th.bing.com/th/id/OIP.tN5JyOolMVLDsDMrc4vdAQHaLL?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/truyen-kieu.pdf',NULL,N'VND',123,20,N'active','2026-01-28T20:05:44.2066667',NULL,3,1,NULL,NULL,N'Tiếng Việt',1987)

INSERT [dbo].[Book] VALUES (16,N'Lập trình Java cơ bản',N'Hướng dẫn học lập trình Java từ cơ bản đến nâng cao.',N'Cuốn sách hướng dẫn toàn diện về ngôn ngữ lập trình Java.',N'https://th.bing.com/th/id/OIP.AwyVNca1uF34K9icqcIO-gHaKY?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/java-basic.pdf',300000,N'VND',130,50,N'active','2026-01-28T20:05:44.2066667',NULL,11,9,NULL,NULL,N'Tiếng Anh',2020)

INSERT [dbo].[Book] VALUES (17,N'Cuộc phiêu lưu của Tom Sawyer',N'Những cuộc phiêu lưu thú vị của cậu bé Tom Sawyer bên bờ sông Mississippi.',N'Câu chuyện kinh điển về Tom Sawyer và những cuộc phiêu lưu thời thơ ấu.',N'https://th.bing.com/th/id/OIP.-0NXLGrZEvIjB220SA45OgHaLx?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/tom-sawyer.pdf',NULL,N'VND',74,25,N'active','2026-01-28T20:05:44.2066667',NULL,14,3,NULL,NULL,N'Tiếng Anh',1876)

INSERT [dbo].[Book] VALUES (18,N'Kiêu hãnh và Định kiến',N'Câu chuyện tình yêu giữa Elizabeth Bennet và Mr. Darcy trong xã hội Anh thế kỷ 19.',N'Tác phẩm kinh điển của Jane Austen về tình yêu và xã hội thời Victoria.',N'https://tse1.explicit.bing.net/th/id/OIP.dtWOwTfJq0M7Cy89m7DNZAHaK7?rs=1&pid=ImgDetMain&o=7&rm=3',N'books/content/pride-prejudice.pdf',170000,N'VND',424,35,N'active','2026-01-28T20:05:44.2066667',NULL,15,2,NULL,NULL,N'Tiếng Anh',1813)

INSERT [dbo].[Book] VALUES (19,N'Cấu trúc dữ liệu và Giải thuật',N'Kiến thức nền tảng về cấu trúc dữ liệu và các thuật toán cơ bản.',N'Cuốn sách cung cấp kiến thức căn bản về cấu trúc dữ liệu và thuật toán.',N'https://images.vnuhcmpress.edu.vn/Picture/2024/7/1/image-20240701150234854.jpg',N'books/content/data-structure.pdf',350000,N'VND',263,40,N'active','2026-01-28T20:05:44.2066667',NULL,11,9,NULL,NULL,N'Tiếng Anh',2019)

INSERT [dbo].[Book] VALUES (20,N'Đôrêmon - Tập 1',N'Cuộc phiêu lưu đầu tiên của Nobita và chú mèo máy Đôrêmon.',N'Bộ truyện tranh nổi tiếng về chú mèo máy Đôrêmon và cậu bé Nobita.',N'/images/covers/doraemon-1.jpg',N'/books/content/doraemon-1.pdf',NULL,N'VND',191,30,N'active','2026-01-28T20:05:44.2066667',NULL,2,3,NULL,NULL,N'Tiếng Nhật',1970)

SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (1, N'Văn học Việt Nam', N'Các tác phẩm văn học của các tác giả Việt Nam, bao gồm tiểu thuyết, truyện ngắn, thơ.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (2, N'Văn học nước ngoài', N'Tác phẩm văn học được dịch từ các ngôn ngữ khác, bao gồm tiểu thuyết, thơ và văn xuôi.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (3, N'Sách thiếu nhi', N'Sách dành cho trẻ em và thiếu niên, bao gồm truyện cổ tích, truyện tranh và sách giáo dục.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (4, N'Kinh dị - Bí ẩn', N'Tiểu thuyết kinh dị, trinh thám và những câu chuyện bí ẩn kích thích trí tò mò.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (5, N'Khoa học viễn tưởng', N'Những tác phẩm khai thác chủ đề công nghệ, tương lai và những khả năng của khoa học.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (6, N'Lịch sử', N'Sách về lịch sử thế giới, lịch sử Việt Nam và những sự kiện lịch sử quan trọng.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (7, N'Tâm lý - Tự lực', N'Sách phát triển bản thân, tâm lý học và hướng dẫn cải thiện cuộc sống.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (8, N'Kinh tế - Kinh doanh', N'Sách về quản trị, kinh doanh, tài chính và phát triển sự nghiệp.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (9, N'Công nghệ - Khoa học', N'Sách về công nghệ thông tin, khoa học máy tính và các lĩnh vực khoa học khác.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (10, N'Triết học', N'Các tác phẩm triết học, tư tưởng và những câu hỏi về ý nghĩa cuộc sống.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (11, N'Thể thao - Sức khỏe', N'Sách về thể thao, fitness, dinh dưỡng và chăm sóc sức khỏe.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (12, N'Du lịch', N'Cẩm nang du lịch, hướng dẫn khám phá các địa điểm trên thế giới.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (13, N'Nấu ăn', N'Sách dạy nấu ăn, công thức món ngon và văn hóa ẩm thực.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (14, N'Nghệ thuật', N'Sách về hội họa, âm nhạc, điêu khắc và các loại hình nghệ thuật khác.')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (15, N'Tôn giáo - Tâm linh', N'Sách về các tôn giáo, tâm linh và phát triển tinh thần.')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (1, N'Admin User', N'admin@digitallibrary.vn', N'admin123', N'active', CAST(N'2026-01-26T18:12:16.3841498' AS DateTime2), 1)
INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (2, N'Nguyễn Thị Hoa', N'librarian@digitallibrary.vn', N'librarian123', N'active', CAST(N'2026-01-26T18:12:16.3841498' AS DateTime2), 2)
INSERT [dbo].[Employee] ([employee_id], [full_name], [email], [password_hash], [status], [created_at], [role_id]) VALUES (3, N'Trần Văn Nam', N'seller@digitallibrary.vn', N'seller123', N'active', CAST(N'2026-01-26T18:12:16.3841498' AS DateTime2), 3)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
SET IDENTITY_INSERT [dbo].[Fine_Type] ON 

INSERT [dbo].[Fine_Type] ([fine_type_id], [name], [description], [default_amount], [per_day_rate]) VALUES (1, N'late_return', N'Phạt trả sách trễ', NULL, CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[Fine_Type] ([fine_type_id], [name], [description], [default_amount], [per_day_rate]) VALUES (2, N'lost', N'Phạt mất sách', CAST(500000.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[Fine_Type] ([fine_type_id], [name], [description], [default_amount], [per_day_rate]) VALUES (3, N'damaged', N'Phạt làm hỏng sách', CAST(200000.00 AS Decimal(10, 2)), NULL)
SET IDENTITY_INSERT [dbo].[Fine_Type] OFF
GO
SET IDENTITY_INSERT [dbo].[Reader] ON 

INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (1, N'Nguyễn Văn A', N'nguyenvana@example.com', N'password123', N'0123456789', NULL, N'active', CAST(N'2026-01-26T18:12:16.3886646' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (2, N'Trần Thị B', N'tranthib@example.com', N'password123', N'0987654321', NULL, N'active', CAST(N'2026-01-26T18:12:16.3886646' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (3, N'Lê Văn C', N'levanc@example.com', N'password123', N'0369852147', NULL, N'active', CAST(N'2026-01-26T18:12:16.3886646' AS DateTime2), 4)
INSERT [dbo].[Reader] ([reader_id], [full_name], [email], [password_hash], [phone], [avatar], [status], [created_at], [role_id]) VALUES (4, N'Phạm Thị D', N'phamthid@example.com', N'password123', N'0741852963', NULL, N'active', CAST(N'2026-01-26T18:12:16.3886646' AS DateTime2), 4)
SET IDENTITY_INSERT [dbo].[Reader] OFF
GO
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (1, N'ADMIN', N'Quản trị viên hệ thống')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (2, N'LIBRARIAN', N'Thủ thư quản lý sách')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (3, N'SELLER', N'Nhân viên bán hàng')
INSERT [dbo].[Role] ([role_id], [role_name], [description]) VALUES (4, N'USER', N'Nguời dùng thông thuờng')
SET IDENTITY_INSERT [dbo].[Role] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__BookCopy__5196394F19721CD6]    Script Date: 04/02/2026 1:18:02 CH ******/
ALTER TABLE [dbo].[BookCopy] ADD UNIQUE NONCLUSTERED 
(
	[copy_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Borrow__18D3B90E75C8915D]    Script Date: 04/02/2026 1:18:02 CH ******/
ALTER TABLE [dbo].[Borrow] ADD UNIQUE NONCLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__AB6E6164F6258F26]    Script Date: 04/02/2026 1:18:02 CH ******/
ALTER TABLE [dbo].[Employee] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Reader__AB6E61647AE2BFA0]    Script Date: 04/02/2026 1:18:02 CH ******/
ALTER TABLE [dbo].[Reader] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Role__783254B1077992DB]    Script Date: 04/02/2026 1:18:02 CH ******/
ALTER TABLE [dbo].[Role] ADD UNIQUE NONCLUSTERED 
(
	[role_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[BookCopy] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Bookmark] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Borrow] ADD  DEFAULT (sysutcdatetime()) FOR [borrow_date]
GO
ALTER TABLE [dbo].[Borrow] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Borrow_Extend] ADD  DEFAULT (sysutcdatetime()) FOR [requested_at]
GO
ALTER TABLE [dbo].[Borrow_Request] ADD  DEFAULT (sysutcdatetime()) FOR [requested_at]
GO
ALTER TABLE [dbo].[Borrow_Request_Item] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Cart_Item] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[Cart_Item] ADD  DEFAULT (sysutcdatetime()) FOR [added_at]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Fine] ADD  DEFAULT ((0)) FOR [amount]
GO
ALTER TABLE [dbo].[Fine] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Notification] ADD  DEFAULT ((0)) FOR [is_read]
GO
ALTER TABLE [dbo].[Notification] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [total_amount]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Order_Book] ADD  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[Order_Book] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[Payment] ADD  DEFAULT ((0)) FOR [amount]
GO
ALTER TABLE [dbo].[Payment] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Reader] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Reader_Account] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Reader_Book_Ownership] ADD  DEFAULT (sysutcdatetime()) FOR [acquired_at]
GO
ALTER TABLE [dbo].[Review] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[Book]  WITH NOCHECK ADD  CONSTRAINT [FK_Book_Author] FOREIGN KEY([AuthorID])
REFERENCES [dbo].[Author] ([AuthorID])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_Author]
GO
ALTER TABLE [dbo].[Book]  WITH NOCHECK ADD  CONSTRAINT [FK_Book_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_Category]
GO
ALTER TABLE [dbo].[Book]  WITH NOCHECK ADD  CONSTRAINT [FK_Book_CreatedBy] FOREIGN KEY([CreatedByEmployeeID])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_CreatedBy]
GO
ALTER TABLE [dbo].[Book]  WITH NOCHECK ADD  CONSTRAINT [FK_Book_UpdatedBy] FOREIGN KEY([UpdatedByEmployeeID])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_UpdatedBy]
GO
ALTER TABLE [dbo].[BookCopy]  WITH NOCHECK ADD  CONSTRAINT [FK_BookCopy_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[BookCopy] CHECK CONSTRAINT [FK_BookCopy_Book]
GO
ALTER TABLE [dbo].[Bookmark]  WITH NOCHECK ADD  CONSTRAINT [FK_Bookmark_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Bookmark] CHECK CONSTRAINT [FK_Bookmark_Book]
GO
ALTER TABLE [dbo].[Bookmark]  WITH NOCHECK ADD  CONSTRAINT [FK_Bookmark_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Bookmark] CHECK CONSTRAINT [FK_Bookmark_Reader]
GO
ALTER TABLE [dbo].[Borrow]  WITH NOCHECK ADD  CONSTRAINT [FK_Borrow_ApprovedBy] FOREIGN KEY([approved_by_employee_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Borrow] CHECK CONSTRAINT [FK_Borrow_ApprovedBy]
GO
ALTER TABLE [dbo].[Borrow]  WITH NOCHECK ADD  CONSTRAINT [FK_Borrow_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Borrow] CHECK CONSTRAINT [FK_Borrow_Reader]
GO
ALTER TABLE [dbo].[Borrow]  WITH NOCHECK ADD  CONSTRAINT [FK_Borrow_Request] FOREIGN KEY([request_id])
REFERENCES [dbo].[Borrow_Request] ([request_id])
GO
ALTER TABLE [dbo].[Borrow] CHECK CONSTRAINT [FK_Borrow_Request]
GO
ALTER TABLE [dbo].[Borrow_Extend]  WITH NOCHECK ADD  CONSTRAINT [FK_Extend_ApprovedBy] FOREIGN KEY([approved_by_employee_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Borrow_Extend] CHECK CONSTRAINT [FK_Extend_ApprovedBy]
GO
ALTER TABLE [dbo].[Borrow_Extend]  WITH NOCHECK ADD  CONSTRAINT [FK_Extend_BorrowItem] FOREIGN KEY([borrow_item_id])
REFERENCES [dbo].[Borrow_Item] ([borrow_item_id])
GO
ALTER TABLE [dbo].[Borrow_Extend] CHECK CONSTRAINT [FK_Extend_BorrowItem]
GO
ALTER TABLE [dbo].[Borrow_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_BorrowItem_Borrow] FOREIGN KEY([borrow_id])
REFERENCES [dbo].[Borrow] ([borrow_id])
GO
ALTER TABLE [dbo].[Borrow_Item] CHECK CONSTRAINT [FK_BorrowItem_Borrow]
GO
ALTER TABLE [dbo].[Borrow_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_BorrowItem_Copy] FOREIGN KEY([copy_id])
REFERENCES [dbo].[BookCopy] ([copy_id])
GO
ALTER TABLE [dbo].[Borrow_Item] CHECK CONSTRAINT [FK_BorrowItem_Copy]
GO
ALTER TABLE [dbo].[Borrow_Request]  WITH NOCHECK ADD  CONSTRAINT [FK_BorrowRequest_ProcessedBy] FOREIGN KEY([processed_by_employee_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Borrow_Request] CHECK CONSTRAINT [FK_BorrowRequest_ProcessedBy]
GO
ALTER TABLE [dbo].[Borrow_Request]  WITH NOCHECK ADD  CONSTRAINT [FK_BorrowRequest_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Borrow_Request] CHECK CONSTRAINT [FK_BorrowRequest_Reader]
GO
ALTER TABLE [dbo].[Borrow_Request_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_BRItem_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Borrow_Request_Item] CHECK CONSTRAINT [FK_BRItem_Book]
GO
ALTER TABLE [dbo].[Borrow_Request_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_BRItem_Request] FOREIGN KEY([request_id])
REFERENCES [dbo].[Borrow_Request] ([request_id])
GO
ALTER TABLE [dbo].[Borrow_Request_Item] CHECK CONSTRAINT [FK_BRItem_Request]
GO
ALTER TABLE [dbo].[Cart]  WITH NOCHECK ADD  CONSTRAINT [FK_Cart_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Reader]
GO
ALTER TABLE [dbo].[Cart_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_CartItem_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Cart_Item] CHECK CONSTRAINT [FK_CartItem_Book]
GO
ALTER TABLE [dbo].[Cart_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_CartItem_Cart] FOREIGN KEY([cart_id])
REFERENCES [dbo].[Cart] ([cart_id])
GO
ALTER TABLE [dbo].[Cart_Item] CHECK CONSTRAINT [FK_CartItem_Cart]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([role_id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Role]
GO
ALTER TABLE [dbo].[Fine]  WITH NOCHECK ADD  CONSTRAINT [FK_Fine_BorrowItem] FOREIGN KEY([borrow_item_id])
REFERENCES [dbo].[Borrow_Item] ([borrow_item_id])
GO
ALTER TABLE [dbo].[Fine] CHECK CONSTRAINT [FK_Fine_BorrowItem]
GO
ALTER TABLE [dbo].[Fine]  WITH NOCHECK ADD  CONSTRAINT [FK_Fine_HandledBy] FOREIGN KEY([handled_by_employee_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Fine] CHECK CONSTRAINT [FK_Fine_HandledBy]
GO
ALTER TABLE [dbo].[Fine]  WITH NOCHECK ADD  CONSTRAINT [FK_Fine_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Fine] CHECK CONSTRAINT [FK_Fine_Reader]
GO
ALTER TABLE [dbo].[Fine]  WITH NOCHECK ADD  CONSTRAINT [FK_Fine_Type] FOREIGN KEY([fine_type_id])
REFERENCES [dbo].[Fine_Type] ([fine_type_id])
GO
ALTER TABLE [dbo].[Fine] CHECK CONSTRAINT [FK_Fine_Type]
GO
ALTER TABLE [dbo].[Notification]  WITH NOCHECK ADD  CONSTRAINT [FK_Notification_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Notification] CHECK CONSTRAINT [FK_Notification_Reader]
GO
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Reader]
GO
ALTER TABLE [dbo].[Order_Book]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderBook_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Order_Book] CHECK CONSTRAINT [FK_OrderBook_Book]
GO
ALTER TABLE [dbo].[Order_Book]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderBook_Order] FOREIGN KEY([order_id])
REFERENCES [dbo].[Order] ([order_id])
GO
ALTER TABLE [dbo].[Order_Book] CHECK CONSTRAINT [FK_OrderBook_Order]
GO
ALTER TABLE [dbo].[Payment]  WITH NOCHECK ADD  CONSTRAINT [FK_Payment_Order] FOREIGN KEY([order_id])
REFERENCES [dbo].[Order] ([order_id])
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment_Order]
GO
ALTER TABLE [dbo].[Reader]  WITH NOCHECK ADD  CONSTRAINT [FK_Reader_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([role_id])
GO
ALTER TABLE [dbo].[Reader] CHECK CONSTRAINT [FK_Reader_Role]
GO
ALTER TABLE [dbo].[Reader_Account]  WITH NOCHECK ADD  CONSTRAINT [FK_ReaderAccount_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Reader_Account] CHECK CONSTRAINT [FK_ReaderAccount_Reader]
GO
ALTER TABLE [dbo].[Reader_Book_Ownership]  WITH NOCHECK ADD  CONSTRAINT [FK_Ownership_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Reader_Book_Ownership] CHECK CONSTRAINT [FK_Ownership_Book]
GO
ALTER TABLE [dbo].[Reader_Book_Ownership]  WITH NOCHECK ADD  CONSTRAINT [FK_Ownership_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Reader_Book_Ownership] CHECK CONSTRAINT [FK_Ownership_Reader]
GO
ALTER TABLE [dbo].[Reading_History]  WITH NOCHECK ADD  CONSTRAINT [FK_ReadHistory_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Reading_History] CHECK CONSTRAINT [FK_ReadHistory_Book]
GO
ALTER TABLE [dbo].[Reading_History]  WITH NOCHECK ADD  CONSTRAINT [FK_ReadHistory_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Reading_History] CHECK CONSTRAINT [FK_ReadHistory_Reader]
GO
ALTER TABLE [dbo].[Review]  WITH NOCHECK ADD  CONSTRAINT [FK_Review_Book] FOREIGN KEY([book_id])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Book]
GO
ALTER TABLE [dbo].[Review]  WITH NOCHECK ADD  CONSTRAINT [FK_Review_Reader] FOREIGN KEY([reader_id])
REFERENCES [dbo].[Reader] ([reader_id])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Reader]
GO
USE [master]
GO
ALTER DATABASE [DigitalLibraryDB] SET  READ_WRITE 
GO

-- SECTION 2: AUTH & READER
-- ================================================
-- Digital Library - Reader Auth Schema (Fix for existing DB)
-- Cháº¡y file nÃ y trong SQL Server Management Studio
-- Database: DigitalLibraryDB
-- ================================================

USE DigitalLibraryDB;
GO

-- ================================================
-- 1. ThÃªm cá»™t cÃ²n thiáº¿u vÃ o báº£ng Reader hiá»‡n cÃ³
-- ================================================

-- ThÃªm cá»™t avatar_url náº¿u chÆ°a cÃ³
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader' AND COLUMN_NAME = 'avatar_url'
)
BEGIN
    ALTER TABLE Reader ADD avatar_url NVARCHAR(500) NULL;
    PRINT 'ÄÃ£ thÃªm cá»™t avatar_url vÃ o Reader.';
END
ELSE
    PRINT 'Cá»™t avatar_url Ä‘Ã£ tá»“n táº¡i.';
GO

-- ThÃªm updated_at náº¿u chÆ°a cÃ³
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader' AND COLUMN_NAME = 'updated_at'
)
BEGIN
    ALTER TABLE Reader ADD updated_at DATETIME2 NULL DEFAULT GETDATE();
    PRINT 'ÄÃ£ thÃªm cá»™t updated_at vÃ o Reader.';
END
ELSE
    PRINT 'Cá»™t updated_at Ä‘Ã£ tá»“n táº¡i.';
GO

-- ================================================
-- 2. ThÃªm cá»™t cÃ²n thiáº¿u vÃ o báº£ng Reader_Account
-- ================================================

-- ThÃªm provider_email náº¿u chÆ°a cÃ³
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader_Account' AND COLUMN_NAME = 'provider_email'
)
BEGIN
    ALTER TABLE Reader_Account ADD provider_email NVARCHAR(255) NULL;
    PRINT 'ÄÃ£ thÃªm cá»™t provider_email vÃ o Reader_Account.';
END
ELSE
    PRINT 'Cá»™t provider_email Ä‘Ã£ tá»“n táº¡i.';
GO

-- ================================================
-- 3. ThÃªm cá»™t cÃ²n thiáº¿u vÃ o báº£ng Notification
-- ================================================

-- Kiá»ƒm tra tÃªn cá»™t type (cÃ³ thá»ƒ lÃ  'type' hoáº·c 'notif_type')
-- ThÃªm cá»™t náº¿u thiáº¿u
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Notification' AND COLUMN_NAME = 'type'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Notification' AND COLUMN_NAME = 'notif_type'
    )
    BEGIN
        ALTER TABLE Notification ADD type NVARCHAR(50) NOT NULL DEFAULT 'general';
        PRINT 'ÄÃ£ thÃªm cá»™t type vÃ o Notification.';
    END
END
ELSE
    PRINT 'Cá»™t type Ä‘Ã£ tá»“n táº¡i trong Notification.';
GO

-- ================================================
-- 4. Táº¡o báº£ng PasswordResetToken (hoÃ n toÃ n má»›i)
-- ================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PasswordResetToken')
BEGIN
    CREATE TABLE PasswordResetToken (
        token_id        INT IDENTITY(1,1) PRIMARY KEY,
        reader_id       INT NOT NULL,
        token           VARCHAR(255) NOT NULL UNIQUE,
        expires_at      DATETIME2 NOT NULL,
        is_used         BIT NOT NULL DEFAULT 0,
        created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_PasswordResetToken_Reader 
            FOREIGN KEY (reader_id) REFERENCES Reader(reader_id) ON DELETE CASCADE
    );
    PRINT 'Báº£ng PasswordResetToken Ä‘Ã£ Ä‘Æ°á»£c táº¡o.';
END
ELSE
    PRINT 'Báº£ng PasswordResetToken Ä‘Ã£ tá»“n táº¡i.';
GO

-- ================================================
-- 5. Index tá»‘i Æ°u
-- ================================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PasswordResetToken_Token')
    CREATE INDEX IX_PasswordResetToken_Token ON PasswordResetToken(token);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Notification_Reader_Read')
    CREATE INDEX IX_Notification_Reader_Read ON Notification(reader_id, is_read, created_at);
GO

-- ================================================
-- 6. Dá»¯ liá»‡u thÃ´ng bÃ¡o máº«u (náº¿u cÃ³ reader nÃ o)
-- ================================================
INSERT INTO Notification (reader_id, title, message, type, is_read)
SELECT TOP 1 reader_id, 
    N'ChÃ o má»«ng Ä‘áº¿n vá»›i Digital Library!',
    N'Há»‡ thá»‘ng xÃ¡c thá»±c Ä‘Ã£ Ä‘Æ°á»£c nÃ¢ng cáº¥p. HÃ£y cáº­p nháº­t thÃ´ng tin há»“ sÆ¡ cá»§a báº¡n.',
    'general', 0
FROM Reader
WHERE NOT EXISTS (
    SELECT 1 FROM Notification n2 
    WHERE n2.reader_id = Reader.reader_id 
    AND n2.title LIKE N'ChÃ o má»«ng%'
);
GO

-- ================================================
-- 7. Táº¡o tÃ i khoáº£n Seller dÃ¹ng Ä‘á»ƒ test tÃ­nh nÄƒng
-- ================================================
-- LÆ°u Ã½: Máº­t kháº©u máº·c Ä‘á»‹nh lÃ  '123' (Ä‘Ã£ hash qua SHA-256)
IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'seller@fpt.edu.vn')
BEGIN
    -- role_id = 3 lÃ  SELLER
    INSERT INTO Employee (full_name, email, password_hash, role_id, status)
    VALUES (
        N'Pháº¡m Seller (NhÃ¢n viÃªn BÃ¡n hÃ ng)', 
        'seller@fpt.edu.vn', 
        'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 
        3, 
        'active'
    );
END
GO

PRINT 'Schema fix hoÃ n táº¥t!';
GO

-- SECTION 3: FEATURES
USE DigitalLibraryDB;
GO

-- 1. Cart & Cart_Item
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- active, checked_out, abandoned
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Cart_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart_Item]') AND type in (N'U'))
BEGIN
CREATE TABLE Cart_Item (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL DEFAULT 0,
    added_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

-- 2. Order, Order_Book, Payment
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
BEGIN
CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    currency NVARCHAR(10) NULL,
    status NVARCHAR(30) NOT NULL, -- pending, paid, cancelled, refunded
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Order_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_Book]') AND type in (N'U'))
BEGIN
CREATE TABLE Order_Book (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(50) NULL,
    payment_status NVARCHAR(30) NOT NULL, -- pending, success, failed
    transaction_code NVARCHAR(100) NULL,
    paid_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
END
GO

-- 3. Reading History
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reading_History]') AND type in (N'U'))
BEGIN
CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_position INT NULL,
    last_read_at DATETIME2 NULL,
    CONSTRAINT FK_ReadHistory_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_ReadHistory_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Reading_History_Reader_Book' AND object_id = OBJECT_ID('Reading_History'))
    CREATE UNIQUE INDEX IX_Reading_History_Reader_Book ON Reading_History(reader_id, book_id);
GO

-- 4. Bookmark
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookmark]') AND type in (N'U'))
BEGIN
CREATE TABLE Bookmark (
    bookmark_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    page_number INT NOT NULL,
    note NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Bookmark_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Bookmark_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

-- 5. Review
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Review]') AND type in (N'U'))
BEGIN
CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT NULL,
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Review_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Review_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Review_Reader_Book' AND object_id = OBJECT_ID('Review'))
    CREATE UNIQUE INDEX IX_Review_Reader_Book ON Review(reader_id, book_id);
GO

-- Ensure new column stock_quantity on Book table for Buy Book features
IF COL_LENGTH('Book', 'stock_quantity') IS NULL
BEGIN
    ALTER TABLE Book 
    ADD stock_quantity INT NOT NULL CONSTRAINT DF_Book_Stock DEFAULT 10;
END
GO

-- SECTION 4: OWNERSHIP
USE DigitalLibraryDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reader_Book_Ownership]') AND type in (N'U'))
BEGIN
CREATE TABLE Reader_Book_Ownership (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_via NVARCHAR(50) NULL,
    status NVARCHAR(30) DEFAULT 'active',
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Ownership_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Ownership_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO


-- SECTION 5: ADD TABLE RESERVATION
USE DigitalLibraryDB;
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reservation]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Reservation](
        [reservation_id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [reader_id] INT NOT NULL,
        [book_id] INT NOT NULL,
        [status] NVARCHAR(30) NOT NULL,          -- pending/active/fulfilled/cancelled/expired
        [queued_at] DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
        [expires_at] DATETIME2(7) NULL,
        [fulfilled_at] DATETIME2(7) NULL,
        [cancelled_at] DATETIME2(7) NULL,
        CONSTRAINT [FK_Reservation_Reader] FOREIGN KEY([reader_id]) REFERENCES [dbo].[Reader]([reader_id]),
        CONSTRAINT [FK_Reservation_Book] FOREIGN KEY([book_id]) REFERENCES [dbo].[Book]([BookID])
    );
    CREATE INDEX IX_Reservation_Reader_Status ON [dbo].[Reservation]([reader_id], [status], [queued_at] DESC);
END
GO

CREATE UNIQUE INDEX UX_Reservation_Reader_Book_Active
ON dbo.Reservation(reader_id, book_id)
WHERE status IN ('pending','active');
GO
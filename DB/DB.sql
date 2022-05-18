DROP DATABASE IF EXISTS [DataWarehouse]
GO
CREATE DATABASE [DataWarehouse]
GO
USE [DataWarehouse]
GO

CREATE TABLE [Clients]
(
    [Id_Client] [int] IDENTITY(1,1) NOT NULL,
    [CompanyName] [varchar](128) NOT NULL,
    [ContactName] [varchar](163) NOT NULL,
    [Phone] [varchar](25) NOT NULL,
    [Origin] [char](1) NOT NULL,
    [Origin_Id] [varchar](10) NOT NULL,
    CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[Id_Client] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Orders]
(
    [Id_order] [int] IDENTITY(1,1) NOT NULL,
    [OrderTime_Id] [int] NOT NULL,
    [ShipDate] [datetime] NULL,
    [Freight] [money] NOT NULL,
    [City] [varchar](50) NOT NULL,
    [CountryRegion] [varchar](50) NOT NULL,
    [PostalCode] [varchar](50) NULL,
    [Customer_Id] [int] NOT NULL,
    [Origin] [varchar](50) NOT NULL,
    [OriginO_Id] [varchar](50) NOT NULL,
    [AddressLine] [varchar](123) NOT NULL,
    [Product_Id] [int] NOT NULL,
    [UnitPrice] [money] NOT NULL,
    [Discount] [money] NOT NULL,
    [OriginOD_Id] [int] NOT NULL,
    [Quantity] [smallint] NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Products]
(
    [Id_Product] [int] IDENTITY(1,1) NOT NULL,
    [ProductName] [varchar](200) NOT NULL,
    [Price] [money] NOT NULL,
    [OriginP_Id] [int] NOT NULL,
    [OriginC_Id] [int] NOT NULL,
    [CategoryName] [varchar](103) NOT NULL,
    [Origin] [char](1) NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id_Product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Time]
(
    [Id_Time] [int] IDENTITY(1,1) NOT NULL,
    [Year] [smallint] NOT NULL,
    [Month] [tinyint] NOT NULL,
    [Day] [tinyint] NOT NULL,
    CONSTRAINT [PK_Time] PRIMARY KEY CLUSTERED 
(
	[Id_Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Orders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Clients] FOREIGN KEY([Customer_Id])
REFERENCES [Clients] ([Id_Client])
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [FK_Orders_Clients]
GO
ALTER TABLE [Orders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Products] FOREIGN KEY([Product_Id])
REFERENCES [Products] ([Id_Product])
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [FK_Orders_Products]
GO
ALTER TABLE [Orders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Time] FOREIGN KEY([OrderTime_Id])
REFERENCES [Time] ([Id_Time])
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [FK_Orders_Time]
GO
USE [master]
GO
ALTER DATABASE [DataWarehouse] SET  READ_WRITE 
GO

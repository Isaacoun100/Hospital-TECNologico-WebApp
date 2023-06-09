USE [master]
GO
/****** Object:  Database [Tarea_Corta_1]    Script Date: 26/3/2023 14:35:36 ******/
CREATE DATABASE [Tarea_Corta_1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Tarea_Corta_1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Tarea_Corta_1.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Tarea_Corta_1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Tarea_Corta_1_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Tarea_Corta_1] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Tarea_Corta_1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Tarea_Corta_1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET ARITHABORT OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Tarea_Corta_1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Tarea_Corta_1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Tarea_Corta_1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Tarea_Corta_1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET RECOVERY FULL 
GO
ALTER DATABASE [Tarea_Corta_1] SET  MULTI_USER 
GO
ALTER DATABASE [Tarea_Corta_1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Tarea_Corta_1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Tarea_Corta_1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Tarea_Corta_1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Tarea_Corta_1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Tarea_Corta_1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Tarea_Corta_1', N'ON'
GO
ALTER DATABASE [Tarea_Corta_1] SET QUERY_STORE = ON
GO
ALTER DATABASE [Tarea_Corta_1] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Tarea_Corta_1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLastInsertedReservation]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetLastInsertedReservation]()
RETURNS @LastInsertedReservation TABLE (
    ID INT,
    fecha_ingreso DATE,
    fecha_salida DATE,
    Cama_ID INT,
    Paciente_ID INT
)
AS
BEGIN
    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(ID) FROM Reservacion;

    INSERT INTO @LastInsertedReservation
    SELECT ID, fecha_ingreso, fecha_salida, Cama_ID, Paciente_ID
    FROM Reservacion
    WHERE ID = @MaxID;

    RETURN;
END
GO
/****** Object:  Table [dbo].[Personal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personal](
	[Cedula] [varchar](100) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Apellido1] [varchar](100) NOT NULL,
	[Apellido2] [varchar](100) NOT NULL,
	[Fecha_ingreso] [date] NULL,
	[Fecha_nac] [date] NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Tipo] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Personal] PRIMARY KEY CLUSTERED 
(
	[Cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Personal_Login]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Personal_Login] (@Cedula VARCHAR(100), @Password VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Personal
    WHERE Cedula = @Cedula AND Password = @Password

	UNION ALL
    
    SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    WHERE NOT EXISTS(SELECT 1 FROM Personal WHERE Cedula = @Cedula AND Password = @Password)
)
GO
/****** Object:  Table [dbo].[Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paciente](
	[Cedula] [varchar](100) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Apellido1] [varchar](100) NOT NULL,
	[Apellido2] [varchar](100) NOT NULL,
	[Sexo] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Fecha_nac] [date] NOT NULL,
	[Edad]  AS (datediff(year,[Fecha_nac],getdate())),
PRIMARY KEY CLUSTERED 
(
	[Cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Paciente_Login]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Paciente_Login] (@Cedula VARCHAR(100), @Password VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Paciente
    WHERE Cedula = @Cedula AND Password = @Password

	UNION ALL
    
    SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    WHERE NOT EXISTS(SELECT 1 FROM Paciente WHERE Cedula = @Cedula AND Password = @Password)
)
GO
/****** Object:  Table [dbo].[Historial_Clinico]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Historial_Clinico](
	[Paciente_cedula] [varchar](100) NOT NULL,
	[Fecha_procedimiento] [date] NOT NULL,
	[Tratamiento] [varchar](1000) NOT NULL,
	[Procedimiento_nombre] [varchar](100) NOT NULL,
	[Personal_cedula] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[buscarHistorialClinico]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[buscarHistorialClinico] (@cedula varchar(100))
RETURNS TABLE
AS
RETURN
    SELECT Paciente_cedula, Fecha_procedimiento, Tratamiento, Procedimiento_nombre, Personal_cedula
    FROM Historial_Clinico
    WHERE Paciente_cedula = @cedula
GO
/****** Object:  Table [dbo].[Reservacion]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservacion](
	[ID] [int] NOT NULL,
	[Fecha_ingreso] [date] NOT NULL,
	[Fecha_salida] [date] NULL,
	[Cama_ID] [int] NOT NULL,
	[Paciente_ID] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Reservacion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Obtener_reservaciones_por_paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Obtener_reservaciones_por_paciente](@Paciente_ID varchar(100))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM Reservacion
    WHERE Paciente_ID = @Paciente_ID
)
GO
/****** Object:  Table [dbo].[Cama]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cama](
	[ID] [int] NOT NULL,
	[is_UCI] [bit] NOT NULL,
	[Salon_ID] [int] NOT NULL,
	[Used] [bit] NULL,
 CONSTRAINT [PK_Cama] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cama_Equipo]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cama_Equipo](
	[Cama_ID] [int] NOT NULL,
	[Equipo_nombre] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Direccion_Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direccion_Paciente](
	[Paciente_cedula] [varchar](100) NOT NULL,
	[Provincia] [varchar](50) NOT NULL,
	[Canton] [varchar](50) NOT NULL,
	[Distrito] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Direccion_Personal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direccion_Personal](
	[Personal_cedula] [varchar](100) NOT NULL,
	[Provincia] [varchar](50) NOT NULL,
	[Canton] [varchar](50) NOT NULL,
	[Distrito] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Equipo]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipo](
	[Nombre] [varchar](50) NOT NULL,
	[Proveedor] [varchar](50) NOT NULL,
	[Cantidad_disponible] [int] NOT NULL,
 CONSTRAINT [PK_Equipo] PRIMARY KEY CLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patologia_Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patologia_Paciente](
	[Paciente_cedula] [varchar](100) NOT NULL,
	[Patologia] [varchar](100) NOT NULL,
	[Tratamiento] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Procedimiento]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Procedimiento](
	[Nombre] [varchar](100) NOT NULL,
	[Dias_recuperacion] [int] NOT NULL,
	[Descripcion] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Procedimiento] PRIMARY KEY CLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservacion_Procedimiento]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservacion_Procedimiento](
	[Reservacion_ID] [int] NOT NULL,
	[Procedimiento_nombre] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salon]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salon](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Capacidad] [int] NOT NULL,
	[Tipo] [varchar](50) NOT NULL,
	[Piso] [int] NOT NULL,
 CONSTRAINT [PK_Salon] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Telefono_Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telefono_Paciente](
	[Paciente_cedula] [varchar](100) NOT NULL,
	[Telefono] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Telefono_Personal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telefono_Personal](
	[Personal_cedula] [varchar](100) NOT NULL,
	[Telefono] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cama] ADD  DEFAULT ((0)) FOR [Used]
GO
ALTER TABLE [dbo].[Personal] ADD  CONSTRAINT [DF_Fecha_Personal]  DEFAULT (getdate()) FOR [Fecha_ingreso]
GO
ALTER TABLE [dbo].[Cama]  WITH CHECK ADD  CONSTRAINT [FK_Cama_Salon] FOREIGN KEY([Salon_ID])
REFERENCES [dbo].[Salon] ([ID])
GO
ALTER TABLE [dbo].[Cama] CHECK CONSTRAINT [FK_Cama_Salon]
GO
ALTER TABLE [dbo].[Cama_Equipo]  WITH CHECK ADD  CONSTRAINT [FK_Cama_Equipo_Cama] FOREIGN KEY([Cama_ID])
REFERENCES [dbo].[Cama] ([ID])
GO
ALTER TABLE [dbo].[Cama_Equipo] CHECK CONSTRAINT [FK_Cama_Equipo_Cama]
GO
ALTER TABLE [dbo].[Cama_Equipo]  WITH CHECK ADD  CONSTRAINT [FK_Cama_Equipo_Equipo] FOREIGN KEY([Equipo_nombre])
REFERENCES [dbo].[Equipo] ([Nombre])
GO
ALTER TABLE [dbo].[Cama_Equipo] CHECK CONSTRAINT [FK_Cama_Equipo_Equipo]
GO
ALTER TABLE [dbo].[Direccion_Paciente]  WITH CHECK ADD  CONSTRAINT [FK_Direccion_Paciente_Paciente] FOREIGN KEY([Paciente_cedula])
REFERENCES [dbo].[Paciente] ([Cedula])
GO
ALTER TABLE [dbo].[Direccion_Paciente] CHECK CONSTRAINT [FK_Direccion_Paciente_Paciente]
GO
ALTER TABLE [dbo].[Direccion_Personal]  WITH CHECK ADD  CONSTRAINT [FK_Direccion_Personal_Personal] FOREIGN KEY([Personal_cedula])
REFERENCES [dbo].[Personal] ([Cedula])
GO
ALTER TABLE [dbo].[Direccion_Personal] CHECK CONSTRAINT [FK_Direccion_Personal_Personal]
GO
ALTER TABLE [dbo].[Historial_Clinico]  WITH CHECK ADD  CONSTRAINT [FK_Historial_Clinico_Paciente] FOREIGN KEY([Paciente_cedula])
REFERENCES [dbo].[Paciente] ([Cedula])
GO
ALTER TABLE [dbo].[Historial_Clinico] CHECK CONSTRAINT [FK_Historial_Clinico_Paciente]
GO
ALTER TABLE [dbo].[Historial_Clinico]  WITH CHECK ADD  CONSTRAINT [FK_Historial_Clinico_Personal] FOREIGN KEY([Personal_cedula])
REFERENCES [dbo].[Personal] ([Cedula])
GO
ALTER TABLE [dbo].[Historial_Clinico] CHECK CONSTRAINT [FK_Historial_Clinico_Personal]
GO
ALTER TABLE [dbo].[Historial_Clinico]  WITH CHECK ADD  CONSTRAINT [FK_Historial_Clinico_Procedimiento] FOREIGN KEY([Procedimiento_nombre])
REFERENCES [dbo].[Procedimiento] ([Nombre])
GO
ALTER TABLE [dbo].[Historial_Clinico] CHECK CONSTRAINT [FK_Historial_Clinico_Procedimiento]
GO
ALTER TABLE [dbo].[Patologia_Paciente]  WITH CHECK ADD  CONSTRAINT [FK_Patologia_Paciente_Paciente] FOREIGN KEY([Paciente_cedula])
REFERENCES [dbo].[Paciente] ([Cedula])
GO
ALTER TABLE [dbo].[Patologia_Paciente] CHECK CONSTRAINT [FK_Patologia_Paciente_Paciente]
GO
ALTER TABLE [dbo].[Reservacion]  WITH CHECK ADD  CONSTRAINT [FK_Reservacion_Cama] FOREIGN KEY([Cama_ID])
REFERENCES [dbo].[Cama] ([ID])
GO
ALTER TABLE [dbo].[Reservacion] CHECK CONSTRAINT [FK_Reservacion_Cama]
GO
ALTER TABLE [dbo].[Reservacion]  WITH CHECK ADD  CONSTRAINT [FK_Reservacion_Paciente] FOREIGN KEY([Paciente_ID])
REFERENCES [dbo].[Paciente] ([Cedula])
GO
ALTER TABLE [dbo].[Reservacion] CHECK CONSTRAINT [FK_Reservacion_Paciente]
GO
ALTER TABLE [dbo].[Reservacion_Procedimiento]  WITH CHECK ADD  CONSTRAINT [FK_Reservacion_Procedimiento_Procedimiento] FOREIGN KEY([Procedimiento_nombre])
REFERENCES [dbo].[Procedimiento] ([Nombre])
GO
ALTER TABLE [dbo].[Reservacion_Procedimiento] CHECK CONSTRAINT [FK_Reservacion_Procedimiento_Procedimiento]
GO
ALTER TABLE [dbo].[Reservacion_Procedimiento]  WITH CHECK ADD  CONSTRAINT [FK_Reservacion_Procedimiento_Reservacion] FOREIGN KEY([Reservacion_ID])
REFERENCES [dbo].[Reservacion] ([ID])
GO
ALTER TABLE [dbo].[Reservacion_Procedimiento] CHECK CONSTRAINT [FK_Reservacion_Procedimiento_Reservacion]
GO
ALTER TABLE [dbo].[Telefono_Paciente]  WITH CHECK ADD  CONSTRAINT [FK_Telefono_Paciente_Paciente] FOREIGN KEY([Paciente_cedula])
REFERENCES [dbo].[Paciente] ([Cedula])
GO
ALTER TABLE [dbo].[Telefono_Paciente] CHECK CONSTRAINT [FK_Telefono_Paciente_Paciente]
GO
ALTER TABLE [dbo].[Telefono_Personal]  WITH CHECK ADD  CONSTRAINT [FK_Telefono_Personal_Personal] FOREIGN KEY([Personal_cedula])
REFERENCES [dbo].[Personal] ([Cedula])
GO
ALTER TABLE [dbo].[Telefono_Personal] CHECK CONSTRAINT [FK_Telefono_Personal_Personal]
GO
ALTER TABLE [dbo].[Paciente]  WITH CHECK ADD  CONSTRAINT [Sexo] CHECK  (([Sexo]='M' OR [Sexo]='F'))
GO
ALTER TABLE [dbo].[Paciente] CHECK CONSTRAINT [Sexo]
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD  CONSTRAINT [CK_Tipo_Personal] CHECK  (([Tipo]='Doctor' OR [Tipo]='Enfermero' OR [Tipo]='Administrativo'))
GO
ALTER TABLE [dbo].[Personal] CHECK CONSTRAINT [CK_Tipo_Personal]
GO
ALTER TABLE [dbo].[Salon]  WITH CHECK ADD  CONSTRAINT [Tipo] CHECK  (([Tipo]='Hombres' OR [Tipo]='Mujeres' OR [Tipo]='Niños'))
GO
ALTER TABLE [dbo].[Salon] CHECK CONSTRAINT [Tipo]
GO
/****** Object:  StoredProcedure [dbo].[Actualizar_Fecha_Salida]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Actualizar_Fecha_Salida]
(
    @ID INT
)
AS 
BEGIN
    -- Declarar variables locales
    DECLARE @fecha_salida DATE
    DECLARE @dias_recuperacion INT

    -- Calcular la fecha de salida sumando los días de recuperación de todos los procedimientos asociados a la reservación
    SELECT @dias_recuperacion = SUM(p.Dias_recuperacion)
    FROM Reservacion_procedimiento rp
    INNER JOIN Procedimiento p ON p.nombre = rp.Procedimiento_nombre
    WHERE rp.Reservacion_ID = @ID

    SELECT @fecha_salida = DATEADD(DAY, @dias_recuperacion, r.fecha_ingreso)
    FROM Reservacion r
    WHERE r.ID = @ID

    -- Actualizar la fecha de salida en la tabla Reservacion
    UPDATE Reservacion
    SET fecha_salida = @fecha_salida
    WHERE ID = @ID
END
GO
/****** Object:  StoredProcedure [dbo].[BuscarCamaDisponible]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BuscarCamaDisponible] (
    @Cedula varchar(100),
    @FechaIngreso date
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Sexo varchar(100);
    DECLARE @Edad INT;
    DECLARE @TipoSalon VARCHAR(100);
    DECLARE @CamaID INT;
    DECLARE @ReservacionID INT;
    
    SELECT @Sexo = Sexo, @Edad = Edad FROM Paciente WHERE Cedula = @Cedula;
    
		IF @Sexo = 'F' AND @Edad > 18
	BEGIN
		SELECT @TipoSalon = 'Mujeres' FROM Salon WHERE Tipo = @TipoSalon;
	END
	ELSE IF @Sexo = 'M' AND @Edad > 18
	BEGIN
		SELECT @TipoSalon = 'Hombres' FROM Salon WHERE Tipo = @TipoSalon;
	END
	ELSE
	BEGIN
		SELECT @TipoSalon = 'Niños' FROM Salon WHERE Tipo = @TipoSalon;
	END

	-- agregar una cláusula ELSE para asegurarse de que siempre se establezca un valor para @TipoSalon
	IF @TipoSalon IS NULL
	BEGIN
		SELECT TOP 1 @TipoSalon = Tipo FROM Salon;
	END

	SELECT TOP 1 @CamaID = ID FROM Cama
	WHERE Salon_ID IN (SELECT ID FROM Salon WHERE Tipo = @TipoSalon)
	AND Used = 0;
    
    SELECT @ReservacionID = ISNULL(MAX(ID), 0) FROM Reservacion;
    SET @ReservacionID = @ReservacionID + 1;
    
    INSERT INTO Reservacion (ID, Fecha_ingreso, Fecha_salida, Cama_ID, Paciente_ID)
    VALUES (@ReservacionID, @FechaIngreso, NULL, @CamaID, @Cedula);
    
    UPDATE Cama SET Used = 1 WHERE ID = @CamaID;
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarDireccionPaciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarDireccionPaciente]
    @Paciente_cedula varchar(50),
    @Provincia varchar(50),
    @Canton varchar(50),
    @Distrito varchar(50)
AS
BEGIN
    INSERT INTO Direccion_Paciente (Paciente_cedula, Provincia, Canton, Distrito)
    VALUES (@Paciente_cedula, @Provincia, @Canton, @Distrito)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarDireccionPersonal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarDireccionPersonal]
    @Personal_cedula varchar(50),
    @Provincia varchar(50),
    @Canton varchar(50),
    @Distrito varchar(50)
AS
BEGIN
    INSERT INTO Direccion_Personal(Personal_cedula, Provincia, Canton, Distrito)
    VALUES (@Personal_cedula, @Provincia, @Canton, @Distrito)
END
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Direccion_Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Obtener_Direccion_Paciente]
    @cedula_paciente VARCHAR(100)
AS
BEGIN
    SELECT Paciente_cedula, Provincia, Canton, Distrito
    FROM Direccion_Paciente
    WHERE Paciente_cedula = @cedula_paciente
END
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Direccion_Personal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Obtener_Direccion_Personal]
    @cedula_personal VARCHAR(100)
AS
BEGIN
    SELECT Personal_cedula, Provincia, Canton, Distrito
    FROM Direccion_Personal
    WHERE Personal_cedula = @cedula_personal
END
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Telefonos_Personal]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Obtener_Telefonos_Personal]
    @cedula_personal VARCHAR(100)
AS
BEGIN
    SELECT Personal_cedula, Telefono
    FROM Telefono_Personal
    WHERE Personal_cedula = @cedula_personal
END
GO
/****** Object:  StoredProcedure [dbo].[OcuparCama]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OcuparCama] (@cama_id int)
AS
BEGIN
    UPDATE Cama
    SET Used = 1
    WHERE ID = @cama_id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarHistorialClinico]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarHistorialClinico]
    @Paciente_cedula varchar(100),
    @Fecha_procedimiento date,
    @Tratamiento varchar(1000)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Historial_Clinico
    SET Tratamiento = @Tratamiento, Fecha_procedimiento = @Fecha_procedimiento
    WHERE Paciente_cedula = @Paciente_cedula;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_BorrarTelefonoPaciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BorrarTelefonoPaciente]
    @Paciente_cedula VARCHAR(100),
    @Telefono VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Telefono_Paciente WHERE Paciente_cedula = @Paciente_cedula AND Telefono = @Telefono) -- Verificar que la tupla exista
    BEGIN
        DELETE FROM Telefono_Paciente
        WHERE Paciente_cedula = @Paciente_cedula AND Telefono = @Telefono;
        
        SELECT 'La tupla ha sido eliminada correctamente' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'La tupla no existe en la tabla Telefono_Paciente' AS Mensaje;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Eliminar_Reservacion]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Eliminar_Reservacion]
    @reservacion_id int
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;

    -- Eliminar las entradas de Reservacion_Procedimiento
    DELETE FROM Reservacion_Procedimiento WHERE Reservacion_ID = @reservacion_id;
    
    -- Eliminar la entrada de Reservacion
    DELETE FROM Reservacion WHERE ID = @reservacion_id;

    COMMIT TRANSACTION;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Insertar_Paciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Insertar_Paciente]
    @Cedula VARCHAR(100),
    @Nombre VARCHAR(100),
    @Apellido1 VARCHAR(100),
    @Apellido2 VARCHAR(100),
    @Sexo VARCHAR(100),
    @Password VARCHAR(100),
    @Fecha_nac DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF (
        LEN(@Cedula) <= 100 AND -- verificar que la cédula tenga una longitud máxima de 20 caracteres
        LEN(@Nombre) <= 100 AND -- verificar que el nombre tenga una longitud máxima de 50 caracteres
        LEN(@Apellido1) <= 100 AND -- verificar que el primer apellido tenga una longitud máxima de 50 caracteres
        LEN(@Apellido2) <= 100 AND -- verificar que el segundo apellido tenga una longitud máxima de 50 caracteres
        @Sexo IN ('M', 'F') AND -- verificar que el sexo sea "M" o "F"
        LEN(@Password) <= 100 -- verificar que la contraseña tenga una longitud máxima de 50 caracteres
    )
    BEGIN
        INSERT INTO Paciente (Cedula, Nombre, Apellido1, Apellido2, Sexo, Password, Fecha_nac)
        VALUES (@Cedula, @Nombre, @Apellido1, @Apellido2, @Sexo, @Password, @Fecha_nac);
    END
    ELSE
    BEGIN
        SELECT NULL AS Cedula, NULL AS Nombre, NULL AS Apellido1, NULL AS Apellido2, NULL AS Sexo, NULL AS Password, NULL AS Fecha_nac
        WHERE 1=0; -- retorna una tabla vacía con columnas nulas
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarHistorialClinico]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarHistorialClinico]
    @Paciente_cedula varchar(100),
    @Fecha_procedimiento date,
    @Tratamiento varchar(1000),
    @Procedimiento_nombre varchar(100),
    @Personal_cedula varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial_Clinico (Paciente_cedula, Fecha_procedimiento, Tratamiento, Procedimiento_nombre, Personal_cedula)
    VALUES (@Paciente_cedula, @Fecha_procedimiento, @Tratamiento, @Procedimiento_nombre, @Personal_cedula);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarProcedimientoReservacion]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarProcedimientoReservacion]
    @Reservacion_ID int,
    @Procedimiento_nombre VARCHAR(100)
AS
BEGIN
        INSERT INTO Reservacion_Procedimiento (Reservacion_ID, Procedimiento_nombre) 
        VALUES (@Reservacion_ID, @Procedimiento_nombre);
        
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarTelefonoPaciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarTelefonoPaciente]
    @Paciente_cedula VARCHAR(20),
    @Telefono VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Paciente WHERE cedula = @Paciente_cedula) -- Verificar que la cedula del paciente exista
    BEGIN
        INSERT INTO Telefono_Paciente (Paciente_cedula, Telefono) 
        VALUES (@Paciente_cedula, @Telefono);
        
        SELECT 'La tupla ha sido insertada correctamente' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'La cedula del paciente no existe en la tabla Paciente' AS Mensaje;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerProcedimientosReservacion]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[sp_ObtenerProcedimientosReservacion]
	@reservacion_id INT
	as
	select Procedimiento_nombre from Reservacion_Procedimiento where Reservacion_ID = @reservacion_id
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerTelefonosPaciente]    Script Date: 26/3/2023 14:35:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ObtenerTelefonosPaciente]
    @Paciente_cedula VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Telefono
    FROM Telefono_Paciente
    WHERE Paciente_cedula = @Paciente_cedula;
END
GO
USE [master]
GO
ALTER DATABASE [Tarea_Corta_1] SET  READ_WRITE 
GO

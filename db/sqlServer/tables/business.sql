CREATE TABLE businesses (
    business_id BIGINT NOT NULL IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    address NVARCHAR(MAX),
    phone_number NVARCHAR(50), -- Ajusta la longitud según sea necesario
    email NVARCHAR(255),
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT PK_businesses PRIMARY KEY (bussiness_id),
    CONSTRAINT UQ_businesses_name UNIQUE (name),
    CONSTRAINT UQ_businesses_email UNIQUE (email) -- Asumiendo que el email del negocio debe ser único
);
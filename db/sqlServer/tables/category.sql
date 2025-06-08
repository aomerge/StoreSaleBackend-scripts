CREATE TABLE Categories (
    category_id BIGINT NOT NULL IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX), -- Usando NVARCHAR(MAX) para descripciones que pueden ser largas
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (id),
    CONSTRAINT UQ_Categories_name UNIQUE (name)
);
GO



CREATE TABLE users (
    user_id BIGINT NOT NULL IDENTITY(1,1),
    username NVARCHAR(255) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    phone_number NVARCHAR(255),
    address NVARCHAR(MAX), -- Usando NVARCHAR(MAX) para direcciones que pueden ser largas
    role NVARCHAR(255),
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT PK_users PRIMARY KEY (user_id),
    CONSTRAINT UQ_users_username UNIQUE (username),
    CONSTRAINT UQ_users_email UNIQUE (email)
);
GO


-- Add comments
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'User accounts table',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'users';
GO
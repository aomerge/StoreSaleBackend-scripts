-- Check if the table already exists and create only if it doesn't
CREATE TABLE products (
    product_id BIGINT NOT NULL IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX), -- Usar NVARCHAR(MAX) para textos largos
    image_url NVARCHAR(255),
    sku NVARCHAR(50) NOT NULL, -- Ajusta la longitud según tus necesidades para SKU
    price DECIMAL(19, 4) NOT NULL, -- DECIMAL es bueno para moneda
    stock_quantity INT NOT NULL,
    category_id BIGINT NOT NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT PK_products PRIMARY KEY (product_id),
    CONSTRAINT UQ_products_sku UNIQUE (sku),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
GO

-- Add comments
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'User accounts table',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'users';
GO
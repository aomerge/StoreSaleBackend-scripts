-- Check if the table already exists and create only if it doesn't
CREATE TABLE sales (
    sale_id BIGINT NOT NULL IDENTITY(1,1),
    user_id BIGINT NOT NULL,
    bussiness_id BIGINT NOT NULL, -- Corregido para coincidir con tu entidad
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATETIME2 NOT NULL,
    total_price DECIMAL(19, 4) NOT NULL, -- Usando DECIMAL para el precio
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,
    CONSTRAINT PK_sales PRIMARY KEY (sale_id),
    CONSTRAINT FK_sales_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_sales_business FOREIGN KEY (bussiness_id) REFERENCES businesses(bussiness_id),
    CONSTRAINT FK_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

-- Add comments
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'User accounts table',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'users';
GO
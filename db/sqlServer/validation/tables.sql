-- Check if the table already exists and create only if it doesn't
DECLARE @TableName NVARCHAR(128) = '$(tableName)';
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = @TableName AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    -- Create the users table only if it doesn't exist
    PRINT 'Creating users table...'
END
ELSE
BEGIN
    RAISERROR('Error: The users table already exists in the dbo schema', 16, 1)
END
GO
-- Check if the table already exists and create only if it doesn't
-- Usage: Provide the value for the $(TableName) variable when running this script using SQLCMD or a compatible tool.
-- Example: sqlcmd -v TableName="YourTableName" -i tables.sql
DECLARE @TableName NVARCHAR(128) = '$(TableName)';
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = @TableName AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    -- Create the users table only if it doesn't exist
    PRINT 'done'
    PRINT 'Creating users table...'
END
ELSE
BEGIN
    RAISERROR('Error: The users table already exists in the dbo schema', 16, 1)
END
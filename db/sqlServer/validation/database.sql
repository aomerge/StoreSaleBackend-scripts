-- Check if the table already exists and create only if it doesn't
-- Usage: Provide the value for the $(TableName) variable when running this script using SQLCMD or a compatible tool.
-- Example: sqlcmd -v TableName="YourTableName" -i tables.sql
DECLARE @DatabaseName NVARCHAR(128) = '$(DatabaseName)';
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = @DatabaseName)
BEGIN
    -- Create the database only if it doesn't exist
    PRINT 'done'
    PRINT 'Creating database...'
END
ELSE
BEGIN
    RAISERROR('Error: The %s database already exists', 16, 1, @DatabaseName)
END
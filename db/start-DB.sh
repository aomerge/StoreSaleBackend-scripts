DatabaseName="your_database_name"
# Check if the database exists, and create it if it doesn't
echo "Checking if database '$DatabaseName' exists..."
if psql -lqt | cut -d \| -f 1 | grep -qw "$DatabaseName"; then
    echo "Database '$DatabaseName' already exists."
else
    echo "Database '$DatabaseName' does not exist. Creating it..."
    createdb "$DatabaseName"
    echo "Database '$DatabaseName' created successfully."
fi
# Usage instructions
# Ensure you have PostgreSQL installed and configured.
# Run this script with appropriate permissions to create a database.
# Example: ./start-DB.sh


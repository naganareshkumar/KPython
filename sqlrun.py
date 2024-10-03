import sqlite3

def run_sql_file(db_name, sql_file_path):
    # Connect to the database (or create it)
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()

    # Read the SQL file
    with open(sql_file_path, 'r') as sql_file:
        sql_script = sql_file.read()

    try:
        # Execute the SQL script
        cursor.executescript(sql_script)
        print(f"SQL script executed successfully in {db_name} database.")

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")

    finally:
        # Close the connection
        conn.close()

# Usage example
if __name__ == "__main__":
    # Name of the SQLite database file
    db_name = "online_retail.db"
    
    # Path to the SQL file containing the schema creation commands
    sql_file_path = "datamodel.sql"
    
    run_sql_file(db_name, sql_file_path)

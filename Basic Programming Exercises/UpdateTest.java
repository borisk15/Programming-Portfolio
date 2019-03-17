import java . sql .*;

// this program executes a simple SQL Update query

public class UpdateTest { // Save as "UpdateTest.java"
	public static void main ( String [] args ) {
		try (
			// Step 1: Allocate a database 'Connection' object
			Connection conn1 = DriverManager.getConnection (
			"jdbc:mysql://localhost:3306/library_db?useSSL=false" , "myuser" , "BEK_myuser" );
			// Step 2: Allocate a 'Statement' object in the Connection
			Statement stmt = conn1 . createStatement ();
		) {
			// Step 3 & 4: Execute a SQL UPDATE via executeUpdate()
			// which returns an int indicating the number of rows affected.
			// Set the quantity to 0 for the book Introduction to Java
			String strUpdate = "update books set qty = 0 where title = 'Introduction to Java' " ;
			System . out . println ( "The SQL query is: " + strUpdate );
			int countUpdated = stmt . executeUpdate ( strUpdate );
			System . out . println ( countUpdated + " records affected." );
			// Step 3 & 4: Issue a SELECT to check the UPDATE.
			String strSelect = "select * from books where title = 'Introduction to Java' " ;
			System . out . println ( "The SQL query is: " + strSelect );
			ResultSet rset = stmt . executeQuery ( strSelect );
			while ( rset . next ()) { // Move the cursor to the next row
				System . out . println ( rset . getInt ( "id" ) + ", "
						+ rset . getString ( "author" ) + ", "
						+ rset . getString ( "title" ) + ", "
						+ rset . getInt ( "qty" ));
			}
		} catch ( SQLException ex ) {
			ex . printStackTrace ();
		}
		// Step 5: Close the resources - Done automatically by try-with-resources
	}
}

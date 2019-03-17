import java . sql .*;
import java.util.Scanner;

public class BookStoreClerk {
	public static void main ( String [] args ){
		try (
			// Step 1: Allocate a database 'Connection' object
			Connection conn = DriverManager . getConnection (
			"jdbc:mysql://localhost:3306/ebookstore?useSSL=false" , "myuser" , "BEK_myuser" );
			// Step 2: Allocate a 'Statement' object in the Connection
			Statement stmt = conn . createStatement ();
		) {
			System.out.println("Welcome to the book store database. How can I help you? (enter the number of your choice below)");
			System.out.println("1. Enter book");
			System.out.println("2. Update book");
			System.out.println("3. Delete book");
			System.out.println("4. Search books");
			System.out.println("0. exit");
			Scanner in = new Scanner(System.in);

			String choice = in.nextLine();
			int choice_Int = Integer.parseInt(choice);
			
			while (choice_Int!=0){
				if(choice_Int == 1){
					System.out.println("Please enter the title of the book you'd like to enter: ");
					String new_Title = in.nextLine();
					System.out.println("Please enter the Author of the book you'd like to enter: ");
					String new_Author = in.nextLine();
					System.out.println("Please enter the Quantity (as an integer) in store of the book you'd like to enter: ");
					String new_Qty = in.nextLine();

					String sqlInsert = "insert into books (Title, Author, Qty) values ("
							+ "'" + new_Title + "', "
							+ "'" + new_Author + "', "
							+ new_Qty + ")";

					int countInserted = stmt.executeUpdate(sqlInsert);
					System . out . println ( countInserted + " records inserted.\n" );

				}

				if(choice_Int == 2){
					System.out.println("Please enter the title of the book you'd like to update: ");
					String update_Title = in.nextLine();
					System.out.println("Please enter the updated Quantity (as an integer) of this book in-store: ");
					String updated_Qty = in.nextLine();

					String sqlUpdate = "update books set Qty = " 
							+ updated_Qty + 
							" where Title = '" + update_Title + "' ";

					int countUpdated = stmt . executeUpdate ( sqlUpdate );
					System . out . println ( countUpdated + " records affected." );		 
				}

				if (choice_Int == 3){
					System.out.println("Please enter the title of the book you'd like to delete: ");
					String delete_Title = in.nextLine();

					String sqlDelete = "delete from books where Title = '" + delete_Title + "'";

					int countDeleted = stmt . executeUpdate ( sqlDelete );
					System . out . println ( countDeleted + " records deleted.\n" );
				}

				if (choice_Int == 4){
					System.out.println("Please enter the title of the book you'd like to search: ");
					String search_Title = in.nextLine();

					String sqlSearch = "select * from books where Title = '" + search_Title + "'";
					ResultSet rset = stmt . executeQuery ( sqlSearch );
					System . out . println ( "The records selected are:" );
					int rowCount = 0;
					// Move the cursor to the next row, return false if no more row
					while ( rset . next ()) {
						int id = rset.getInt("id");
						String title = rset . getString ( "Title" );
						String author = rset . getString ( "Author" );
						int qty = rset . getInt ( "Qty" );
						System . out . println ( id + ", " + title + ", " + author + ", " + qty );
						++ rowCount ;
					}
					System . out . println ( "Total number of records = " + rowCount );
				}
				System.out.println("Please make another choice below: ");
				System.out.println("1. Enter book");
				System.out.println("2. Update book");
				System.out.println("3. Delete book");
				System.out.println("4. Search books");
				System.out.println("0. exit");

				choice = in.nextLine();
				choice_Int = Integer.parseInt(choice);
			}

			in.close();

		}
		catch ( SQLException ex ) {
			ex.printStackTrace ();
		}
		// Step 5: Close the resources - Done automatically by try-with-resources
	}
}
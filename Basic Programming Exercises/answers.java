package compulsorytasks;

import java.util.Scanner;

// this is a simple program that implements a quick mathematical test for the user to complete by
// providing the user with a set of subtraction questions from randomly generated numbers, accepting
// the user's answer and reporting whether the answer was correct or wrong. The test also keeps an 
// execution log of all the questions and answers, and at the end provides the amount of time taken
// to complete the test.

public class answers {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		final int ITERATIONS = 5;
		int correct_count = 0 ; 
		int iteration_no = 0 ; 
		long startTime = System.currentTimeMillis();
		String execution_log = " "; 
		Scanner user_input = new Scanner(System.in);
		
		while ( iteration_no < ITERATIONS ) 
		{
			// generate two random integers between 0 and 10
			int number1 = ( int )( Math . random () * 10 );
			int number2 = ( int )( Math . random () * 10 );
			
			if ( number1 < number2 ) 
			{
				// if number1 < number2, swap number1 and number2 such that the subtraction yields a positive #
				int temp = number1 ; 
				number1 = number2 ; 
				number2 = temp;
			}
			
			System.out.print("What is " + number1 + " - " + number2 + "? " );
			int answer = user_input.nextInt(); // get input from the user and assign that to the answer variable
			
			if ( number1 - number2 == answer ) 
			{ 
				System.out.println("You are correct!" ); 
				correct_count ++; // Increase the correct answer count
			}
			else 
			{
				System.out.println ( "Your answer is wrong.\n" + number1 + " - " + number2 + " should be " + ( number1 - number2 ));
			}
			
			iteration_no ++;
			execution_log += "\n" + number1 + "-" + number2 + "=" + answer +
			(( number1 - number2 == answer ) ? " correct" : " wrong" ); //Add a new line to the execution log for each operation, saying if it is correct or wrong
		}
		
		long endTime = System.currentTimeMillis();
		long testTime = endTime - startTime;
		System.out.println( "Correct count is " + correct_count + "\nTest time is " + testTime / 1000 + " seconds\n" + execution_log );
		
		user_input.close();
		
	}

}

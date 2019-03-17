package task2;

import java.util.Random;
import javax.swing.*;

// this program implements a simple game of Rock, Paper & Scissors

public class rockPaperScissors {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Random rand = new Random();
		int computerChoice = rand.nextInt(2);
		
		String response = JOptionPane.showInputDialog("Enter a choice (either Rock, Paper, or Scissors): ");
		// int responseInt = Integer.parseInt(response);
		
		// System.out.println("The computer selected: "+computerChoice);
		
		if (response.equalsIgnoreCase("Rock")) 
		{
			if (computerChoice == 0) {
				System.out.println("The computer selected: Rock");
				System.out.println("You draw.");
			}
			else if (computerChoice == 1) {
				System.out.println("The computer selected: Paper");
				System.out.println("You lose.");
			}
			else if (computerChoice == 2) {
				System.out.println("The computer selected: Scissors");
				System.out.println("You win.");
			}
		}
		else if (response.equalsIgnoreCase("Paper")) 
		{
			if (computerChoice == 0) {
				System.out.println("The computer selected: Rock");
				System.out.println("You win.");
			}
			else if (computerChoice == 1) {
				System.out.println("The computer selected: Paper");
				System.out.println("You draw.");
			}
			else if (computerChoice == 2) {
				System.out.println("The computer selected: Scissors");
				System.out.println("You lose.");
			}
		}
		else if (response.equalsIgnoreCase("Scissors")) 
		{
			if (computerChoice == 0) {
				System.out.println("The computer selected: Rock");
				System.out.println("You lose.");
			}
			else if (computerChoice == 1) {
				System.out.println("The computer selected: Paper");
				System.out.println("You win.");
			}
			else if (computerChoice == 2) {
				System.out.println("The computer selected: Scissors");
				System.out.println("You draw.");
			}
		}

	}

}

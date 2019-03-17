package task2;

import javax.swing.*;

// This program calculates the factorial of a user-inputted number

public class factorial {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String num = JOptionPane.showInputDialog("Enter a positive integer: ");
		int numInt = Integer.parseInt(num);
		long factorial = 1;
		
		for (int n = numInt; n > 0; n--) {
			factorial = factorial * n;
		}
		
		System.out.println("The factorial of " + num + " is: " + factorial);
	}
}

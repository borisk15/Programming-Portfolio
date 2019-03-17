package compulsorytasks;

import java.util.*;

// this program implements a class 'Course' class, that defines a course at university, and then 
// implements the Java Comparator interface to provide new Comparator Classes that will be used to 
// compare the courses using two different criteria. Finally, the program then compares some courses
// and using the Java Collections Framework, executes certain operations on the Course instances. 

public class Course {
	// variable declarations
	private String courseName;
	private int numberOfStudents;
	private String courseLecturer;
	
	// class constructor setting veriables to passed arguments
	public Course(String cName, int noOfStudents, String cLecturer) {
		setCourseName(cName);
		setNumberOfStudents(noOfStudents);
		setCourseLecturer(cLecturer);	
	}

	// the setter and getter methods for the variables come below
	String getCourseName() {
		return courseName;
	}

	void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	int getNumberOfStudents() {
		return numberOfStudents;
	}

	void setNumberOfStudents(int numberOfStudents) {
		this.numberOfStudents = numberOfStudents;
	}

	String getCourseLecturer() {
		return courseLecturer;
	}

	void setCourseLecturer(String courseLecturer) {
		this.courseLecturer = courseLecturer;
	}
	
	// the toString method enables the Class Course to be printed out as a string
	public String toString() {
		return String.format("(%s, %s, %d)", courseName, courseLecturer, numberOfStudents);
	}
	
	// implementation of the Comparator class to be able to compare Courses according to the noOfStudents
	static class CourseStudentComparator implements Comparator<Course> {

		@Override
		public int compare(Course course1, Course course2) {
			return course1.getNumberOfStudents() - course2.getNumberOfStudents();
		}	
	}
	
	// implementation of the Comparator class to be able to compare Courses according to the courseNames
	static class CourseNameComparator implements Comparator<Course> {

		@Override
		public int compare(Course course1, Course course2) {
			return course1.getCourseName().compareTo(course2.getCourseName());
		}
	}
	
	// the main method starts here - this is where the program starts to execute
	public static void main(String[] args) {
		// declare a list courses1 and add Courses to it
		List<Course> courses1 = new ArrayList<>();
		courses1.add(new Course("Mathematics 3000H", 30, "Dr. Francois Ebobisse"));
		courses1.add(new Course("Statistics 3045F", 65, "Dr. Miguel Lacerda"));
		courses1.add(new Course("Actuarial Risk Management 4027W", 50, "Joanna Legutko"));
		courses1.add(new Course("Financial Economics 4028F", 40, "Dave Strugnell"));
		courses1.add(new Course("Actuarial Mathematics for Life Contingent Risks 3024S", 55, "Prof. Iain MacDonald"));
		
		System.out.println("Original list of courses: " + courses1);
		
		// Sort courses1 according to noOfStudents
		Collections.sort(courses1, new CourseStudentComparator());
		
		System.out.println("Sorted list of courses: " + courses1);
		
		// swap the elements at indexes 1 and 2
		Collections.swap(courses1, 1, 2);
		
		System.out.println("List after swap: " + courses1);
		
		// declare new list called courses2 and add new Courses to it
		List<Course> courses2 = new ArrayList<>();
		Collections.addAll(courses2, new Course("Mathematics 1000W", 200, "Dr. Jon Shock"),
				new Course("Economics 1006F", 800, "Lecturer 1"),
				new Course("Statistics 1006S", 400, "Lecturer 2"),
				new Course("Introduction to Actuarial Science 1003H", 300, "Joanna Legutko"),
				new Course("Financial Accounting 1012F", 30, "Lecturer 3"));
		
		System.out.println("Course two list: " + courses2);
		
		// copy all the elements in courses 1 to courses2
		Collections.copy(courses2, courses1);
		
		// add a few more courses to courses2
		courses2.add(new Course("Java 101", 55, "Dr. P Green"));
		courses2.add(new Course("Advanced Programming", 93, "Prof. M Milton"));
		
		// Sort courses1 according to courseNames
		Collections.sort(courses2, new CourseNameComparator());
		
		System.out.println("Course two list after sort and add: " + courses2);
		
		// Find the index of the course with course name "Java 101" by looping through all courses
		for (Course c : courses2) {
			if(c.getCourseName().equalsIgnoreCase("Java 101")) {
				System.out.println("The index of Java 101 is: " + courses2.indexOf(c));
			}
		}
		
		// Control structure acting based on whether courses1 and courses2 are disjoint
		if(Collections.disjoint(courses1, courses2)) {
			System.out.println("Courses 1 & courses 2 contain no elements in common!");
		}
		else {
			System.out.println("Courses 1 & courses 2 contain some elements in common!");
		}
		
		// Sort courses2 according to noOfStudents
		Collections.sort(courses2, new CourseStudentComparator());
		
		// find and print the courses with the least and the most students
		Course leastStudents = courses2.get(0);
		Course mostStudents = courses2.get(courses2.size()-1);
		System.out.println("The course with the least number of students is: " + leastStudents.getCourseName());
		System.out.println("The course with the most number of students is: " + mostStudents.getCourseName());
	}
}

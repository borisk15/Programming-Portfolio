// this program is a simple implementation of the QuickSort algorithm

public class QuickSort {
	public static void quickSort ( int [] list ) {
		int first = list[0]
		int last = list[list.length-1]
		int middle = list[list.length/2]

		quickSort ( list , median(first, middle, last) , list . length - 1 );
	}
	
	public static void quickSort ( int [] list , int first , int last ) {
		if ( last > first ) {
			int pivotIndex = partition ( list , first , last );
			quickSort ( list , first , pivotIndex - 1 );
			quickSort ( list , pivotIndex + 1 , last );
		}
	}
	
	public static int median(int first, int middle, int last){
		if(first > middle){
			if(middle > last){
				return middle
			}
			else if(first > last){
				return last
			}
			else{
				return first
			}
		}
		else{
			if(first > last){
				return a
			}
			else if(middle > last){
				return last
			}
			else{
				return middle
			}
		}
	}


	public static int partition ( int [] list , int first , int last ) {
		int pivot = list [ first ]; // Choose the first element as the pivot int
		int low = first + 1 ; // Index for forward search
		int high = last ; // Index for backward search
		
		while ( high > low ) {
			// Search forward from left
			while ( low <= high && list [ low ] <= pivot )
				low ++;
			// Search backward from right
			while ( low <= high && list [ high ] > pivot )
				high --;
			// Swap two elements in the list
			if ( high > low ) {
				int temp = list [ high ];
				list [ high ] = list [ low ];
				list [ low ] = temp;
			}
		}
		
		while ( high > first && list [ high ] >= pivot )
			high --;
		
		// Swap pivot with list[high]
		if ( pivot > list [ high ]) {
			list [ first ] = list [ high ];
			list [ high ] = pivot ;
			return high;
		}
		else {
			return first;
		}
	}
}

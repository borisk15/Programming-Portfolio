import random 
from draw import draw
import argparse

class coin_robot:

    def __init__(self, row, column):
        random.seed(0)
        self.row = row
        self.column = column 
        # Get map
        self.map = [[0 for i in range(column)] for j in range(row)]
        self.generate_map()
        # Initialize self.F and self.path
        # Your code goes here:
        self.F = [[0 for i in range(column)] for j in range(row)]
        self.F[0][0] = self.map[0][0]
        self.F[0][1] = self.map[0][1] + self.F[0][0]
        self.F[1][0] = self.map[1][0] + self.F[0][0]
        self.path = [[[[0,0] for i in range(1)] for j in range(column)] for k in range(row)]

                    
    def solve(self):
        # Your code goes here:
        
        for i in range(1, self.row):
            for j in range(1, self.column):
                self.F[i][j] = max(self.F[i-1][j], self.F[i][j-1]) + self.map[i][j]
        
        for i in range(1 , self.row):
            for j in range(1, self.column):
                if (self.F[i-1][j] > self.F[i][j-1]):
                    self.path[i][j] = [[i-1, j]] + self.path[i-1][j]
                
                if(self.F[i-1][j] < self.F[i][j-1]):
                    self.path[i][j] = [[i, j-1]] + self.path[i][j-1]
                    
                if(self.F[i-1][j] == self.F[i][j-1]):
                    self.path[i][j] = [[i, j-1]] + self.path[i][j-1]
                    
                if(i-1 < 0):
                    self.path[i][j] = [[i, j-1]] + self.path[i][j-1]
                    
                if(j-1 < 0):
                    self.path[i][j] = [[i-1, j]] + self.path[i-1][j]
        
        self.path[self.row-1][self.column-1] =[[self.row-1,self.column-1]] + self.path[self.row-1][self.column-1]

    def generate_map(self):
        for i in range(self.row):
            for j in range(self.column):
                if random.random() > 0.7:
                    self.map[i][j] = 1 # coin
                else:
                    self.map[i][j] = 0

    def draw(self):
        title = "row_"+str(self.row)+"_column_"+str(self.column)+"_value_"+str(self.F[-1][-1])
        draw(self.map, self.path[-1][-1], title)
        
        
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='coin robot')

    parser.add_argument('-row', dest='row', required = True, type = int, help='number of row')
    parser.add_argument('-column', dest='column', required = True, type = int, help='number of column')

    args = parser.parse_args()

    # Example: 
    # python coin_robot.py -row 20 -column 20
    game = coin_robot(args.row, args.column)
    game.solve()
    game.draw()
    

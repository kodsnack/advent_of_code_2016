using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day3
    {
        List<string> rows;

        public Day3()
        {
            rows = Instructions.GetInput(rows,3);
        }

        public void Run()
        {
            int[,] numbers = new int[rows.Count, 3];
            int rowCount = 0;
            foreach(string row in rows)
            {
                List<int> tmpNumbers = row.Split(' ').Where(element => element.Length > 0)
                    .ToList().ConvertAll(value => int.Parse(value));

                for (int j = 0; j<3; j++)
                {
                    numbers[rowCount, j] = tmpNumbers[j];
                }
                rowCount++;
            }

            ///First
            int counter = 0;
            for(int i=0;i< rowCount; i++)
            {
                int x = numbers[i,0];
                int y = numbers[i,1];
                int z = numbers[i,2];
                if (!(x >= y + z) && !(y >= x + z) && !(z >= x + y))
                {
                    counter++;
                }
            }
            Console.WriteLine("3A: " + counter);

            ///Second
            counter = 0;
            for (int i = 0; i < rowCount; i+=3)
            {
                for(int j = 0; j < 3; j++)
                {
                    int x = numbers[i, j];
                    int y = numbers[i + 1, j];
                    int z = numbers[i + 2, j];
                    if (!(x >= y + z) && !(y >= x + z) && !(z >= x + y))
                    {
                        counter++;
                    }
                } 
            }
            Console.WriteLine("3B: " + counter);
        }
    }
}

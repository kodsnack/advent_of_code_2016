using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day2
    {

        private List<string> rows;
        int[,] keypad1;
        char[,] keypad2;

        public Day2()
        {
            ///Get rows of instructions
            rows = Instructions.GetInput(rows,2);

            keypad1 = new int[3, 3] 
            {
                {1,2,3},
                {4,5,6},
                {7,8,9}
            };           

            keypad2 = new char[5, 5] 
            { 
                { '.', '.', '1', '.', '.' },
                { '.', '2', '3', '4', '.' },
                { '5', '6', '7', '8', '9' },
                { '.', 'A', 'B', 'C', '.' },
                { '.', '.', 'D', '.', '.' }
            };
        }

        internal void Run()
        {
            Console.WriteLine("2A: "+runFirst());
            Console.WriteLine("2B: "+runSecond());
        }

        private string runFirst()
        {
            int length;
            int row = 1;
            int col = 1;
            int charcounter = 0;
            string code = "";

            foreach (string s in rows)
            {
                length = s.Length-1;

                foreach (char c in s)
                {
                    ///Edge points
                    if ((c == 'D' && row == 2) || (c == 'U' && row == 0) || (c == 'L' && col == 0) || (c == 'R' && col == 2))
                    {
                        if (charcounter == length)
                        {
                            code += keypad1[row, col].ToString();
                        }
                    }

                    else
                    {
                        switch (c)
                        {
                            case 'L':
                                col -= 1;
                                break;
                            case 'R':
                                col += 1;
                                break;
                            case 'U':
                                row -= 1;
                                break;
                            case 'D':
                                row += 1;
                                break;
                        }
                        if (charcounter == length)
                        {
                            code += keypad1[row, col].ToString();                       
                        }
                    }
                    charcounter++;
                }
                charcounter = 0;
            }

            return code;
        }

        private string runSecond()
        {
            int length;
            int row = 1;
            int col = 1;
            int charcounter = 0;
            string code = "";

            foreach (string s in rows)
            {
                length = s.Length - 1;

                foreach (char c in s)
                {
                    ///Edge points
                    if ((c == 'D' && (row == 4 || keypad2[row + 1, col] == '.')) ||
                        (c == 'U' && (row == 0 || keypad2[row - 1, col] == '.')) ||
                        (c == 'L' && (col == 0 || keypad2[row, col - 1] == '.')) ||
                        (c == 'R' && (col == 4 || keypad2[row, col + 1] == '.')))
                    {
                        if (charcounter == s.Length - 1)
                        {
                            code += keypad2[row, col].ToString();
                        }
                    }

                    else
                    {
                        switch (c)
                        {
                            case 'L':
                                col -= 1;
                                break;
                            case 'R':
                                col += 1;
                                break;
                            case 'U':
                                row -= 1;
                                break;
                            case 'D':
                                row += 1;
                                break;
                        }
                        if (charcounter == length)
                        {
                            code += keypad2[row, col].ToString();
                        }
                    }
                    charcounter++;
                }
                charcounter = 0;
            }

            return code;
        }
    }
}

using System;
using System.Collections.Generic;

namespace AdventOfCode
{
    class Day01
    {
        // C style modulo
        static int mod(int x, int m)
        {
            return (x % m + m) % m;
        }

        public static void Run()
        {
            string input = System.IO.File.ReadAllText(@"input_files\day01.txt");
            //string input = "R8, R4, R4, R8";
            int direction = 0; // 0 = N, 1 = W, 2 = S, 3 = E

            int x = 0, y = 0; // positive y = North, positive x = East
            var visitedLocations = new HashSet<Tuple<int, int>>();
            bool HQ_found = false;
            Tuple<int,int> HQ_location = null;


            foreach(var s in input.Split(new char[] { ',', ' ' },StringSplitOptions.RemoveEmptyEntries))
            {
                direction += s[0] == 'L' ? 1 : -1;
                direction = mod(direction, 4);
                int distance = int.Parse(s.Remove(0, 1));
                for (int i = 0; i < distance; i++) // one step at a time for part 2
                {
                    switch (direction)
                    {
                        case 0:
                            y += 1;
                            break;
                        case 1:
                            x -= 1;
                            break;
                        case 2:
                            y -= 1;
                            break;
                        case 3:
                            x += 1;
                            break;
                    }
                    // Check if we have been here before
                    if (!HQ_found && visitedLocations.Add(new Tuple<int, int>(x, y)) == false)
                    {
                        HQ_found = true;
                        HQ_location = new Tuple<int, int>(x, y);
                    }
                }
            }
            Console.WriteLine("Day 1, distance: " + (Math.Abs(x) + Math.Abs(y)));
            Console.WriteLine("Day 1, distance to HQ: " + (Math.Abs(HQ_location.Item1) + Math.Abs(HQ_location.Item2)) );
        }
    }
}

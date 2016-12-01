using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day1
    {
        string map = "R4, R5, L5, L5, L3, R2, R1, R1, L5, R5, R2, L1, L3, L4, " +
        "R3, L1, L1, R2, R3, R3, R1, L3, L5, R3, R1, L1, R1, R2, L1, L4, " +
        "L5, R4, R2, L192, R5, L2, R53, R1, L5, R73, R5, L5, R186, L3, L2, " +
        "R1, R3, L3, L3, R1, L4, L2, R3, L5, R4, R3, R1, L1, R5, R2, R1," +
        " R1, R1, R3, R2, L1, R5, R1, L5, R2, L2, L4, R3, L1, R4, L5, R4, " +
        "R3, L5, L3, R4, R2, L5, L5, R2, R3, R5, R4, R2, R1, L1, L5, L2, " +
        "L3, L4, L5, L4, L5, L1, R3, R4, R5, R3, L5, L4, L3, L1, L4, R2, R5," +
        " R5, R4, L2, L4, R3, R1, L2, R5, L5, R1, R1, L1, L5, L5, L2, L1, R5," +
        " R2, L4, L1, R4, R3, L3, R1, R5, L1, L4, R2, L3, R5, R3, R1, L3";

        string map2 = "R8, R4, R4, R8";
        List<string> mapSplit;

        public Day1()
        {
            mapSplit = map.Split(',').Select(s => s.Trim()).ToList();     
        }
        internal void Run()
        {
            ///For 1a
            int[] directions = new int[4] { 0, 90, 180, 270 };
            int dirIndex = 0;
            int direction;
            int x = 0;
            int y = 0;

            ///For 1b
            List<string> visitedPoints = new List<string>();
            bool found = false;

            foreach (string dir in mapSplit)
            {
                char turn = dir[0];
                int length = int.Parse(dir.Substring(1, dir.Length-1));

                ///Get direction N,E,S,W
                if(turn == 'L')
                {
                    dirIndex = (dirIndex == 0 ? 3 : dirIndex - 1);
                    direction = directions[dirIndex];
                }

                else
                {
                    dirIndex = (dirIndex == 3 ? 0 : dirIndex + 1);
                    direction = directions[dirIndex];
                }
               
                for(int i = 0; i < length; i++)
                {
                    x = (direction == 90 ? x += 1 : x);
                    x = (direction == 270 ? x -= 1 : x);
                    y = (direction == 0 ? y += 1 : y);
                    y = (direction == 180 ? y -= 1 : y);

                    ///1b - save visited waypoints
                    string waypoint = x.ToString() + "," + y.ToString();
                    if (visitedPoints.Contains(waypoint) && !found)
                    {
                        found = true;
                        Console.WriteLine("Distance to first intersection: " + (Math.Abs(x) + Math.Abs(y)));
                    }
                    else
                    {
                        visitedPoints.Add(waypoint);
                    }
                }
                length = 0;
            }

            Console.WriteLine("Distance: "+(Math.Abs(x)+Math.Abs(y)));          
        }
    }
}

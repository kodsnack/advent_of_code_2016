using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day1
    {
        string map="";

        List<string> mapSplit;

        public Day1()
        {
            map = Instructions.GetInput(map, 1);
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
                        Console.WriteLine("1B: " + (Math.Abs(x) + Math.Abs(y)));
                    }
                    else
                    {
                        visitedPoints.Add(waypoint);
                    }
                }
                length = 0;
            }

            Console.WriteLine("1A: "+(Math.Abs(x)+Math.Abs(y)));          
        }
    }
}

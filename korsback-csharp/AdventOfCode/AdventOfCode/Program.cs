﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AdventOfCode.Days;

namespace AdventOfCode
{
    class Program
    {
        static void Main(string[] args)
        {
            bool repeat = true;
            Console.WriteLine("ADVENT OF CODE 2016");

            while (repeat)
            {
                Console.Write("Select day(1-25): ");
                string day = Console.ReadLine();

                switch (day)
                {
                    case "1":
                        Day1 day1 = new Day1();
                        day1.Run();
                        break;
                    case "0":
                        repeat = false;
                        break;
                    default:
                        break;
                }
            }

            Console.WriteLine("hej då");
            Console.ReadKey();
        }
    }
}

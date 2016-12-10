using System;
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
            Console.WriteLine("#######GODJUL#######");

            while (repeat)
            {
                Console.Write("Select day(1-25, 0 to exit): ");
                string day = Console.ReadLine();
                Console.WriteLine();

                switch (day)
                {
                    case "1":
                        Day1 day1 = new Day1();
                        day1.Run();
                        break;
                    case "2":
                        Day2 day2 = new Day2();
                        day2.Run();
                        break;
                    case "3":
                        Day3 day3 = new Day3();
                        day3.Run();
                        break;
                    case "0":
                        repeat = false;
                        break;
                    default:
                        break;
                }
                Console.WriteLine();
            }

            Console.WriteLine("hej då");
            Console.ReadKey();
        }
    }
}

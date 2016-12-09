using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    public static class Instructions
    {
        public static T GetInput<T>(T container, int day)
        {
            ///Get rows of instructions
            List<string> rows = new List<string>();

            ///Read instructions
            string row;
            System.IO.StreamReader file = new System.IO.StreamReader(@"..\..\instructions\" + day + ".txt");
            while ((row = file.ReadLine()) != null)
            {
                rows.Add(row);
            }
            file.Close();

            if (typeof(T) == typeof(string))
            {
                return (T)(object)rows.First();
            }

            else
            {
                return (T)(object)rows;
            }
        }
    }
}

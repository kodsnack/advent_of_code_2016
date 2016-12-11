using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day4
    {
        private List<string> rows;
        private int idSum;

        public void Run()
        {
            idSum = 0;
            rows = Instructions.GetInput(rows, 4);
            Dictionary<char, int> charCounts = new Dictionary<char, int>();

            foreach (var row in rows)
            {
                List<string> parts = row.Split('-').ToList();
                string lastPart = parts.Last();
                parts.RemoveAt(parts.Count - 1);

                string letters = "";
                parts.ForEach(x => letters += x);
                int value = Convert.ToInt32(lastPart.Substring(0, lastPart.IndexOf('[')));
                string checksum = lastPart.Substring(lastPart.IndexOf('[') + 1, 5);

                foreach(char x in letters)
                {
                    if (charCounts.ContainsKey(x))
                    {
                        charCounts[x] += 1;
                    }
                    else
                        charCounts.Add(x, 1);
                }

                var orderedDictionary = charCounts
                                        .OrderBy(x=>x.Key)
                                        .OrderByDescending(x => x.Value)
                                        .ToList();
                ///Check room
                string result = "";
                for (int i = 0; i < 5; i++)
                {
                    result += orderedDictionary[i].Key;                  
                }

                if (result == checksum)
                {
                    idSum += value;
                }
                charCounts = new Dictionary<char, int>();
            }
            
            Console.WriteLine(idSum);
        }     
    }
}

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
        private int idSum=0;

        public void Run()
        {
            rows = Instructions.GetInput(rows, 4);
            Dictionary<char, int> charCounts = new Dictionary<char, int>();

            foreach (var row in rows)
            {
                List<string> parts = row.Split('-').ToList();
                string lastPart = parts.Last();
                parts.RemoveAt(parts.Count - 1);

                int value = Convert.ToInt32(lastPart.Substring(0, lastPart.IndexOf('[')));
                string checksum = lastPart.Substring(lastPart.IndexOf('[')+1).Split(']').First();

                foreach(var part in parts)
                {
                    foreach(char x in part)
                    {
                        if (charCounts.ContainsKey(x))
                        {
                            charCounts[x] += 1;
                        }
                        else
                            charCounts.Add(x, 1);
                    }
                }

                var orderedDictionary = charCounts
                                        .OrderBy(x=>x.Key)
                                        .OrderByDescending(x => x.Value)
                                        .ToList();
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

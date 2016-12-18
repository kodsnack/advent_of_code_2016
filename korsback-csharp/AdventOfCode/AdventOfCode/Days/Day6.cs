using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day6
    {
        private Dictionary<char,int> letters;
        List<string> rows;
        StringBuilder sb1; //6A
        StringBuilder sb2; //6B

        public void Run()
        {
            rows = Instructions.GetInput(rows, 6);
            letters = new Dictionary<char, int>();
            sb1 = new StringBuilder("");
            sb2 = new StringBuilder("");
            
            int length = rows.First().Length;
            for(int i = 0; i < length; i++)
            {
                foreach(string row in rows)
                {
                    if (letters.ContainsKey(row[i]))
                    {
                        letters[row[i]] += 1;
                    }
                    else
                        letters.Add(row[i], 1);
                }
                var orderedDictionary = letters
                                        .OrderBy(x => x.Key)
                                        .OrderByDescending(x => x.Value)
                                        .ToList();
                letters = new Dictionary<char, int>();
                sb1.Append(orderedDictionary.First().Key);
                sb2.Append(orderedDictionary.Last().Key);
            }
            Console.WriteLine("6A: "+ sb1.ToString());
            Console.WriteLine("6A: "+ sb2.ToString());
        }
    }
}

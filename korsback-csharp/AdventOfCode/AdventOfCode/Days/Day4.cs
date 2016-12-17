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
        private string npSectorID;

        public void Run()
        {
            ///Result containers
            idSum = 0;
            npSectorID = "";

            ///Input
            rows = Instructions.GetInput(rows, 4);
            Dictionary<char, int> charCounts = new Dictionary<char, int>();

            foreach (var row in rows)
            {
                List<string> parts = row.Split('-').ToList();
                string checksum = parts.Last().Substring(parts.Last().IndexOf('[') + 1, 5);
                int sectorID = int.Parse(parts.Last().Substring(0, parts.Last().IndexOf('[')));
                parts.RemoveAt(parts.Count - 1);

                string letters = "";
                parts.ForEach(x => letters += x);

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
                ///4A - Check room
                string result = "";
                for (int i = 0; i < 5; i++)
                {
                    result += orderedDictionary[i].Key;                  
                }

                if (result == checksum)
                {
                    idSum += sectorID;
                }

                charCounts = new Dictionary<char, int>();

                ///4B - Find north pole
                string encrypted = String.Join(" ", parts.ToArray());
                StringBuilder decrypted = new StringBuilder(encrypted);

                for(int i = 0; i < sectorID; i++)
                {
                    for(int j =0;j< encrypted.Length;j++)
                    {
                        if (encrypted[j] != ' ')
                        {
                            decrypted[j] = encrypted[j] == 'z' ? 'a' : (char)((int)encrypted[j] + 1);
                        }
                        else
                        {
                            decrypted[j] = ' ';
                        }                        
                    }
                    encrypted = decrypted.ToString();
                }
                if (encrypted.ToString().Contains("north"))
                {
                    npSectorID = sectorID.ToString();
                }
            }
            
            Console.WriteLine("4A: " + idSum);
            Console.WriteLine("4B: " + npSectorID);
        }     
    }
}

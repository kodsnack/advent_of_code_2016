using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
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
                string checksum = String.Join("", Regex.Split(row, @"^.*\[|\]"));
                string letters = String.Join("",Regex.Split(row, @"\-\d.*\]")).Replace('-',' ');
                int sectorID = int.Parse(String.Join("",Regex.Split(row, @"\D")));

                foreach(char x in letters)
                {
                    if(x!=' ')
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
                string encrypted = letters;
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

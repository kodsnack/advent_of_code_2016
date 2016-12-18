using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace AdventOfCode.Days
{
    class Day7
    {
        List<string> rows;
        int sumTLS;
        int sumSSL;
        string[] bracketsParts;
        string[] noBracketsParts;
        string inData, brackets, noBrackets;

        public void Run()
        {
            sumTLS = 0;
            sumSSL = 0;
            rows = Instructions.GetInput(rows, 7);

            foreach (string row in rows)
            {

                inData = row;
                noBracketsParts = Regex.Split(inData, @"\[.*?\]");
                bracketsParts = Regex.Split(inData, @"^.*?\[|\].*?\[|\]+.*?\w+$");

                brackets = string.Join(",", bracketsParts);
                noBrackets = string.Join(",", noBracketsParts);

                runTTL();
                runSSL();
            }
            Console.WriteLine("7A: " + sumTLS);
            Console.WriteLine("7B: " + sumSSL);
        }

        private void runTTL()
        {
            bool abbaInBracket = false;
            for (int j = 0; j < brackets.Length - 3; j++)
            {
                if (brackets.Substring(j, 4).Contains(','))
                {
                    continue;
                }

                if (isValidTTL(brackets.Substring(j, 4)))
                {
                    abbaInBracket = true;
                    break;
                }
            }
            if (!abbaInBracket)
            {
                for (int h = 0; h < noBrackets.Length - 3; h++)
                {
                    if (noBrackets.Substring(h, 4).Contains(','))
                    {
                        continue;
                    }
                    if (isValidTTL(noBrackets.Substring(h, 4)))
                    {
                        sumTLS += 1;
                        break;
                    }
                }
            }
        }

        private void runSSL()
        {
            for (int h = 0; h < noBrackets.Length - 2; h++)
            {
                if (noBrackets.Substring(h, 3).Contains(','))
                {
                    continue;
                }

                if (isValidSSL(noBrackets.Substring(h, 3),inData))
                {
                    sumSSL += 1;
                    break;
                } 
            }
        }

        private bool isValidSSL(string s, string data)
        {
            if (s[0] != s[1] && s[0] == s[2])
            {
                StringBuilder sb = new StringBuilder();
                string tmpssl = sb.Append(new char[] { s[1], s[0], s[1] }).ToString();
                if (brackets.Contains(tmpssl))
                    return true;
            }
            return false;
            
        }

        private bool isValidTTL(string s)
        {
            if(s[0]==s[3] && 
               s[1]==s[2] && 
               s[0] != s[1])
            {
                return true;
            }
            return false;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;

namespace AdventOfCode.Days
{
    class Day5
    {
        private string doorID = "wtnhxymk";

        public void Run()
        {
            Console.WriteLine("Decrypting..");
            string password1 = "";
            string[] password2 = new string[8];
            int foundPassword2 = 0;
            using (MD5 hasher = MD5.Create())
            {
                for(int i=0; foundPassword2 < 8 || password1.Length < 8;i++)
                {

                    byte[] result = hasher.ComputeHash(Encoding.UTF8.GetBytes(doorID + i.ToString()));
                    string hex = BitConverter.ToString(result).Replace("-", "");

                    if (hex.StartsWith("00000"))
                    {
                        ///5A
                        if(password1.Length<8)
                            password1 += hex[5];

                        ///5B
                        int pos;
                        char ch = hex[5];
                        if(int.TryParse(ch.ToString(), out pos))
                        {
                            if (pos >=0 && pos < 8 && password2[pos] == null)
                            {
                                password2[pos] = hex[6].ToString();
                                foundPassword2++;
                            }
                        }
                    }
                }
            }
            Console.WriteLine("5A: " + password1);
            Console.WriteLine("5B: " + String.Join("",password2));
        }
    }
}

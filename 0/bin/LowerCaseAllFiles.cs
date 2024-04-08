using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace LowerCaseAllFiles
{
    class LowerCaseAllFiles
    {
        static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                PrintHelp();
                return;
            }

            DirectoryInfo currentDir = new DirectoryInfo(".");
            Console.WriteLine("CurrentDir: "+ currentDir.Name);
            if (currentDir.Name != "addon2")
            {
                //Console.WriteLine("This should only be used from the Battlefront CC addon2 folder, exiting...");
                PrintHelp();
                return;
            }

            var allSubDirs = currentDir.GetDirectories("*", SearchOption.TopDirectoryOnly);
            foreach (DirectoryInfo di in allSubDirs)
            {
                if(di.Name != "0")
                    LowerCaseDirectories(di);
            }
        }

        private static void PrintHelp()
        {
            string msg =
@"This program is a companion to the Battlefront Classic Collection mod patch.
Source =     https://github.com/Gametoast/ClassicCollectionModPatch

This program is intended for use rename all addon files and folders to lower case files.
This should only be necessary for the Nintendo Switch game version.

It is only to be run from the 'addon2' folder of Battlefront Classic Collection with 0 arguments.
If the current folder is not called 'addon2', no action is taken.
If any arguments are passed, then this help message is printed and no other actions are taken.
";
            Console.WriteLine(msg);
        }

        private static void LowerCaseFiles(DirectoryInfo di)
        {
            var files = di.GetFiles();
            string tmp = "";
            string oldName = "";
            string newName = "";
            string lowerName = "";
            foreach (FileInfo fi in files)
            {
                lowerName = fi.Name.ToLower();
                if (fi.Name != lowerName)
                {
                    oldName = fi.FullName;
                    newName = fi.FullName.ToLower();
                    tmp = oldName + "_tmp_";
                    File.Move(oldName, tmp);
                    File.Move(tmp, newName);
                    Console.WriteLine("Renamed to: {0}", newName);
                }
            }
        }

        private static void LowerCaseDirectories(DirectoryInfo di)
        {
            LowerCaseFiles(di);
            string lowerName = "";
            string tmp = "";
            string oldName = di.FullName;
            string newName = di.FullName.ToLower();
            lowerName = di.Name.ToLower();
            if (lowerName != di.Name)
            {
                tmp = di.FullName + "__tmp__";
                Directory.Move(oldName, tmp);
                Directory.Move(tmp, newName);
                Console.WriteLine("Renamed to: {0}", newName);
            }
            var allSubDirs = new DirectoryInfo(newName).GetDirectories("*", SearchOption.TopDirectoryOnly);
            foreach (DirectoryInfo child in allSubDirs)
                LowerCaseDirectories(child);
        }
    }
}

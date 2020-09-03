using System;
using System.Net;
using System.Threading;
using System.IO;
using System.Collections.Generic;
using System.Text.Json;
using System.Windows.Input;
using System.Security.Permissions;


namespace FINCommunicator
{
    public class JSONReturn
    {
        public string mod;
        public string sup;
        public object[] data;
    }
    public class WatcherReqArgs : EventArgs
    {
        public JSONReturn dynamics;
        public string path;
        public WatcherReqArgs(JSONReturn _dynamics, string mainDir)
        {
            dynamics = _dynamics;
            path = mainDir;
        }
    }
    public class FINWatcher
    {
        private List<FileSystemWatcher> theWatchers;
        public static int Delay { get { return 20; } }
        private string CheckForCommunicator(string dir)
        {
            string ret = "";
            foreach(string candidate in Directory.EnumerateDirectories(dir))
            {
                if (candidate.EndsWith(".communicator"))
                {
                    ret = candidate;
                    break;
                }
            }
            return ret;
        }
        private void RequestProcessing(string fileContents, string dir)
        {
            DoWrite(dir + "/input.bin", "");
            JSONReturn request = JsonSerializer.Deserialize<JSONReturn>(fileContents);
            Console.WriteLine(fileContents);
            RequestFound.Invoke(this, new WatcherReqArgs(request, dir));

        }
        public event EventHandler RequestFound;
        private Thread watcher;

        public void Reply(string dir, object encoder)
        {
            DoWrite(dir + "/output.bin", JsonSerializer.Serialize(encoder));
        }
        [PermissionSet(SecurityAction.Demand, Name = "FullTrust")]
        public FINWatcher()
        {
            theWatchers = new List<FileSystemWatcher>();

            watcher = new Thread(StartWatching);
            watcher.Start();
        }
        private void StartWatching()
        {
            while (true)
            {
                Thread.Sleep(20);

                string appLocal = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
                appLocal = Path.Combine(appLocal.Substring(0, appLocal.Length - ("\\Roaming").Length), "Local\\FactoryGame\\Saved\\SaveGames\\Computers");
                foreach (string dir in Directory.GetDirectories(appLocal))
                {
                    // First level, we might find a .communicator in here
                    if (CheckForCommunicator(dir) != "")
                    {
                        string inputText = DoRead(CheckForCommunicator(dir) + "/input.bin");
                        if (inputText != "")
                        {
                            RequestProcessing(inputText, CheckForCommunicator(dir));
                        }
                    }
                    // But we will search a level deeper
                    foreach (string subDir in Directory.GetDirectories(dir))
                    {
                        // Second level, we might find a .communicator in here
                        if (CheckForCommunicator(dir) != "")
                        {
                            string inputText = DoRead(CheckForCommunicator(dir) + "/input.bin");
                            if (inputText != "")
                            {
                                RequestProcessing(inputText, CheckForCommunicator(dir));
                            }
                        }
                    }
                }

            }
        }
        private static string DoRead(string file)
        {
            bool read = false;
            string output = "";
            do
            {
                Thread.Sleep(Delay);
                read = true;
                try { output = File.ReadAllText(file); }
                catch (IOException except)
                {
                    read = false;
                }
            } while (read == false);
            return output;
        }
        private static void DoWrite(string file, string outputs)
        {
            bool wrote = false;
            do
            {
                Thread.Sleep(Delay);
                wrote = true;
                try { File.WriteAllText(file, outputs); }
                catch (IOException except)
                {
                    wrote = false;
                }
            } while (wrote == false);
        }
    }
}

using System;
using FINCommunicator;
using System.IO;


namespace FINDebugger
{
    class Program
    {
        private static FINWatcher watcher;
        static void Main(string[] args)
        {
            watcher = new FINWatcher();
            watcher.RequestFound += Watcher_RequestFound;

            Console.WriteLine("Press 'q' to quit the sample.");
            while (Console.Read() != 'q') ;
        }

        private static void Watcher_RequestFound(object sender, EventArgs e)
        {
            WatcherReqArgs reqArgs = (WatcherReqArgs)e;
            Console.WriteLine(reqArgs.path);
            Console.WriteLine(reqArgs.dynamics.mod);
            Console.WriteLine(reqArgs.dynamics.sup);
        }
    }
}

using CommandLine;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Feed.Feeder
{
    class Program
    {
        public class Options
        {
            [Option('f', "file", Required = true, HelpText = "file to import")]
            public string File { get; set; }

            [Option('c', "connectionString", Required = false, HelpText = "connection string to the Storage Account", Default = "UseDevelopmentStorage=true")]
            public string ConnectionString { get; set; }

            [Option('t', "type", Required = false, HelpText = "type of input file. Valid values are: 'Actions', 'Options' .", Default = FeederSourceTypes.Actions)]
            public FeederSourceTypes Type { get; set; }
        }

        public static async Task Main(string[] args)
        {
            await Parser.Default.ParseArguments<Options>(args)
                .WithParsedAsync<Options>(async o =>
                {
                    Console.WriteLine($"processing file {o.File} ... with connection string {o.ConnectionString}");

                    var feeder = new DbFeeder(o.ConnectionString);
                    var entities = await feeder.FromFileAsync(o.File, o.Type);

                    Console.WriteLine($"processing complete! Imported {entities.Count()} entities.");

                });
        }
    }
}

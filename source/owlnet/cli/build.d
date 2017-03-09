module owlnet.cli.build;

import owlnet.cli.options : BuildOptions, GlobalOptions;

import io.text, io.file;

import owlnet.textcolor;
import owlnet.log;

/**
 * Returns a build logger based on the command options.
 */
Logger buildLogger(in BuildOptions opts)
{
    import owlnet.log.file;
    return new FileLogger(stdout, opts.verbose);
}

/**
 * Updates the build.
 *
 * All outputs are brought up-to-date based on their inputs. If '--autopilot' is
 * specified, once the build finishes, we watch for changes to inputs and run
 * another build.
 */
int buildCommand(BuildOptions opts, GlobalOptions globalOpts)
{
    import std.path : dirName, absolutePath;

    auto logger = buildLogger(opts);

    immutable color = TextColor(colorOutput(opts.color));

    return 0;
}

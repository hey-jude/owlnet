module owlnet.command;

import owlnet.log;
import owlnet.resource;
import owlnet.context;

/**
 * Thrown if a command fails.
 */
class CommandError : Exception
{
    int exitCode;

    this(int exitCode)
    {
        import std.format : format;

        super("Command failed with exit code %d".format(exitCode));

        this.exitCode = exitCode;
    }
}

/**
 * Escapes the argument according to the rules of bash, the most commonly used
 * shell. This is mostly used for cosmetic purposes when printing out argument
 * arrays where they could be copy-pasted into a shell.
 */
string escapeShellArg(string arg) pure
{
    import std.array : appender;
    import std.algorithm.searching : findAmong;
    import std.range : empty;
    import std.exception : assumeUnique;

    if (arg.empty)
        return `""`;

    // Characters that require the string to be quoted.
    static immutable special = " '~*[]?";

    immutable quoted = !arg.findAmong(special).empty;

    auto result = appender!(char[]);

    if (quoted)
        result.put('"');

    foreach (c; arg)
    {
        // Characters to escape
        if (c == '\\' || c == '"' || c == '$' || c == '`')
        {
            result.put("\\");
            result.put(c);
        }
        else
        {
            result.put(c);
        }
    }

    if (quoted)
        result.put('"');

    return assumeUnique(result.data);
}

unittest
{
    assert(escapeShellArg(``) == `""`);
    assert(escapeShellArg(`foo`) == `foo`);
    assert(escapeShellArg(`foo bar`) == `"foo bar"`);
    assert(escapeShellArg(`foo'bar`) == `"foo'bar"`);
    assert(escapeShellArg(`foo?bar`) == `"foo?bar"`);
    assert(escapeShellArg(`foo*.c`) == `"foo*.c"`);
    assert(escapeShellArg(`foo.[ch]`) == `"foo.[ch]"`);
    assert(escapeShellArg(`~foobar`) == `"~foobar"`);
    assert(escapeShellArg(`$PATH`) == `\$PATH`);
    assert(escapeShellArg(`\`) == `\\`);
    assert(escapeShellArg(`foo"bar"`) == `foo\"bar\"`);
    assert(escapeShellArg("`pwd`") == "\\`pwd\\`");
}

/**
 * A single command.
 */
struct Command
{
    /**
     * Arguments to execute. The first argument is the name of the executable.
     */
    immutable(string)[] args;

    alias args this;

    // Root of the build directory. This is used to normalize implicit resource
    // paths.
    string buildRoot;

    /**
     * The result of executing a command.
     */
    struct Result
    {
        import core.time : TickDuration;

        /**
         * Implicit input and output resources this command used.
         */
        Resource[] inputs, outputs;

        /**
         * How long it took the command to run from start to finish.
         */
        TickDuration duration;
    }

    this(immutable(string)[] args)
    {
        assert(args.length > 0, "A command must have >0 arguments");

        this.args = args;
    }

    /**
     * Compares this command with another.
     */
    int opCmp()(const auto ref typeof(this) that) const pure nothrow
    {
        import std.algorithm.comparison : cmp;
        return cmp(this.args, that.args);
    }

    /// Ditto
    bool opEquals()(const auto ref typeof(this) that) const pure nothrow
    {
        return this.opCmp(that) == 0;
    }

    unittest
    {
        import std.algorithm.comparison : cmp;

        static assert(Command(["a", "b"]) == Command(["a", "b"]));
        static assert(Command(["a", "b"]) != Command(["a", "c"]));
        static assert(Command(["a", "b"]) <  Command(["a", "c"]));
        static assert(Command(["b", "a"]) >  Command(["a", "b"]));

        static assert(cmp([Command(["a", "b"])], [Command(["a", "b"])]) == 0);
        static assert(cmp([Command(["a", "b"])], [Command(["a", "c"])]) <  0);
        static assert(cmp([Command(["a", "c"])], [Command(["a", "b"])]) >  0);
    }

    /**
     * Returns a string representation of the command.
     *
     * Since the command is in argv format, we format it into a string as one
     * would enter into a shell.
     */
    string toPrettyString() const pure
    {
        import std.array : join;
        import std.algorithm.iteration : map;

        return args.map!(arg => arg.escapeShellArg).join(" ");
    }

    /**
     * Returns a short string representation of the command.
     */
    @property string toPrettyShortString() const pure nothrow
    {
        return args[0];
    }

    /**
     * Executes the command.
     */
    Result execute(ref BuildContext ctx, string workDir, TaskLogger logger) const
    {
        import std.path : buildPath;
        import std.datetime : StopWatch, AutoStart;
        import owlnet.handler : executeHandler = execute;

        auto inputs  = Resources(ctx.root, workDir);
        auto outputs = Resources(ctx.root, workDir);

        auto sw = StopWatch(AutoStart.yes);

        executeHandler(
                ctx,
                args,
                buildPath(ctx.root, workDir),
                inputs, outputs,
                logger
                );

        return Result(inputs.data, outputs.data, sw.peek());
    }
}

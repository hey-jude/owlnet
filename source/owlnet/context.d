module owlnet.context;

import owlnet.log : Logger;
import owlnet.textcolor : TextColor;

/**
 * The build context. The members of this struct are very commonly used
 * throughout the build system. Thus, it is more convenient to bundle them
 * together and pass this struct around instead.
 *
 * Each of these values should be propagated to recursive runs of the build
 * system. That is, all child builds should use these settings instead of
 * constructing their own.
 */
struct BuildContext
{
    string root;

    Logger logger;

    bool dryRun;

    // TODO: Move these settings into the logger.
    bool verbose;
    TextColor color;
}

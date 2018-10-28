Gipeda configuration for Adverse
=======================================

What is gipeda?
---------------

Gipeda is a a tool that presents data from your program’s benchmark suite (or
any other source), with nice tables and shiny graphs.

For more information about gipeda, see its own [GitHub repo](https://github.com/nomeata/gipeda). The rest of this README will focus on
Adverse-specific details.

Setup
-------------

 * Clone this repo somewhere, possibly directly into your webspace.
 * Ensure you have Haskell Stack installed.
 * You may need a few other packages:

        apt-get install git unzip libssl-dev libfile-slurp-perl libipc-run-perl libicu-dev

 * `stack build`

 * Clone *Adverse* into a subdirectory of this repo named `repository`.

        git clone git@github.com:plsyssec/adverse repository

   Note if you want to actually do development on Adverse, you should
   probably use a different copy somewhere else. Scripts in `adverse-gipeda`
   will expect the `repository` directory to never be dirty, and will (for
   instance) checkout any commit you want to benchmark, without restoring
   back to whatever commit you previously had checked out.

 * Run the `install-jslibs.sh` shell script to download some required JS assets.

Collecting data
-----------

To collect data for a particular commit, run `./bench-commit.sh`. With no
arguments, the script defaults to collecting data for the current
`origin/master` (after fetching). To collect data for some other commit, run
`./bench-commit.sh COMMIT` where `COMMIT` is anything recognized by `git` as
a commit, e.g. a hash, branch name, tag, etc.

`./bench-commit.sh` will refuse to collect data for any commit you've already
benchmarked (to avoid overwriting the previous data). If you really want to
re-collect data for a commit you've already collected for, just delete
`logs/<hash>.log`, where `<hash>` is the Git hash of the commit whose data
you want to remove.

Viewing data
--------------

Having run `./bench-commit.sh` at least once, there will be pretty tables,
graphs, etc for you to see. Just point a browser at `site/index.html` in this
repo. If you don’t see anything, it might be because of the filter in the
top-right corner. Try to enable all buttons, even the `=`.

More details
-----------------

For more details about Gipeda see [its GitHub repo and readme](https://github.com/nomeata/gipeda), and likewise for more details about Adverse see [its Github repo and readme](https://github.com/plsyssec/adverse).

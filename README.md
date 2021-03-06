# Csound IDE for Atom

This [Atom](https://atom.io) package adds commands for

1. running [Csound](https://en.wikipedia.org/wiki/Csound) and displaying Csound output; and
2. displaying descriptions of opcodes from [Csound’s manual](http://csound.github.io/docs/manual/PartReference.html).

## Installing

Before you install this package, you’ll need [Boost](http://www.boost.org) and Csound.

### On OS&nbsp;X

The easiest way to install Boost is probably through [Homebrew](http://brew.sh). To install Homebrew, follow the instructions at [http://brew.sh](http://brew.sh). Then, run `brew install boost` in a Terminal.

If you aren’t able to build Csound from its [source code](https://github.com/csound/csound), the most reliable way to install Csound is probably to run an installer in a disk image you can download from [SourceForge](http://sourceforge.net/projects/csound/files/csound6/). (While Csound has a [tap](https://github.com/csound/homebrew-csound) on Homebrew, it does not install a necessary framework; this is a [known issue](https://github.com/csound/csound/blob/develop/BUILD.md#known-issues).) When you double-click the installer in the disk image, OS&nbsp;X may block the installer from running because it’s from an unidentified developer. To run the installer after this happens, open System Preferences, choose Security & Privacy, and click Open Anyway in the bottom half of the window.

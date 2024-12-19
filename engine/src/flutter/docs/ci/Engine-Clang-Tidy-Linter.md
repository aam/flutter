# Engine Clang Tidy Linter

## Description

In May 2020, [`clang-tidy`](https://clang.llvm.org/extra/clang-tidy/) was added as a CI step to the Flutter Engine.  Previously the only lint checks that were happening in the engine were formatting, there were no semantic checks.  Now there are, but that means there is work to be done migrating all the code to conform to all the lint checks.

If a file has `// FLUTTER_NOLINT` at the top, it has issues with the lint that haven't been addressed and the linter will ignore it.  As the issues are fixed the comments should be removed.

You can run the linter locally by running `flutter/ci/clang_tidy.sh`.

## CI background information

* The clang-tidy ci step is run 4 times: host_debug on mac, ios_debug on mac, host_debug on linux, android_debug_arm64 on linux.
* Before the linter can run, the target must be built in order to generate code.
* Clang-tidy jobs are sharded such that the intersection of files in iOS and macOS are shared, similarly for Linux and Android.

## FAQs

### I don't understand this lint error, where do I get help?

You can ask on the `hackers-engine` discord channel.  Ping @gaaclarke or @zanderso if you don't get the response you want.

### Hey, why are/aren't you checking for X?

The checks that are enabled are negotiable.  If you think we are missing something, please discuss it on `hacker-engine`.

### Can I just use `NOLINT` to turn off the error?

You can, but please get explicit approval to do from someone on the team.

### How do I turn on a large new lint?

Here are things that can make it easier to land large new lints.

#### Tips

* Try to reduce the number of checks you are turning on at a time, they can have cascading effects where fixing one check with "clang-tidy fix" can cause violations with other checks.
* Prefer using NOLINTNEXTLINE over NOLINT since auto formatting can move NOLINT comments and break them.

#### Clang-tidy fix on CI

Instead of running clang-tidy fix locally on your machines 4 times you can get the CI bots to print out the fix.  Here's steps on how to do that:

1. Edit `//ci/clang_tidy.sh`:
  ```diff
  # To run on CI, just uncomment the following line:
  -# FLUTTER_LINT_PRINT_FIX=1
  +FLUTTER_LINT_PRINT_FIX=1
  ```
  This will run on _all_ files, and print out the patch generated by `clang-tidy fix` in the CI bots.

2. Make a draft PR with the check added and FLUTTER_LINT_PRINT_FIX=1
3. Look at the output of failed clang-tidy runs and make sure that it didn't garble the fix.  Sometimes that happens and if it does, you'll have to manually fix where it garbled the fix or use NOLINTNEXTLINE.
4. Copy the patch the CI bot printed out to the clipboard, in the terminal, at the engine repo, use `git apply`, paste the patch, press ctrl+d then enter.  Watch out that there can be overlapping patches between the mac runs and the linux runs since we don't shard across platforms.
5. Commit and push that.
6. When the 4 CI runs are green, remove FLUTTER_LINT_PRINT_FIX=1 and put up for review
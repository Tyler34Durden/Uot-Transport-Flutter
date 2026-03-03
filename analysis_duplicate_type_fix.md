If you see errors like:

  AdvertisingEntity defined in ...\AndroidStudioProjects\uot_transport\... can't be assigned to ...\AndroidStudioProjects\UOT_Transport\...

That means the Dart analyzer/runtime is treating your project as being loaded from TWO different absolute paths (same repo, different casing). On Windows/Android tooling this can happen if:

- Android Studio opened the project from a different-cased path at least once
- a junction/symlink points to the same folder with different casing
- stale build artifacts still refer to an old root path

Fix steps:

1) Close Android Studio completely.
2) Ensure there's only one folder under `C:\Users\hp\AndroidStudioProjects` (check for both `UOT_Transport` and `uot_transport`). Delete the duplicate if it exists.
3) Delete these folders in the project root:
   - `.dart_tool/`
   - `build/`
   - `.idea/` (optional)
4) Re-open the project by selecting the folder using the correct casing:

   C:\Users\hp\AndroidStudioProjects\UOT_Transport

5) Run:

   flutter clean
   flutter pub get
   flutter analyze

After this, the duplicate-type errors disappear.

